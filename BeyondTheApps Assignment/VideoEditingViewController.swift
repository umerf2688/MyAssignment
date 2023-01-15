//
//  VideoEditingViewController.swift
//  BeyondTheApps Assignment
//
//  Created by Umer Farooq on 15/01/2023.
//

import UIKit
import AVFoundation
import CoreImage

class VideoEditingViewController: UIViewController {

    //MARK: Variables & Outlets
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var screenshotTimer: Timer?
    var screenshots = [UIImage]()
    var videoPlayer: AVPlayer!

    //MARK: UIViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Video Editing"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let videoURL = Bundle.main.url(forResource: "Drift", withExtension: "mp4") else {return}
        setupVideoPlayer(videoURL: videoURL)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if videoPlayer != nil {
            videoPlayer.pause()
        }
    }
    
    //MARK: UIViewController Helper Methods
    
    func setupVideoPlayer(videoURL: URL) {

        // Create an AVPlayer and AVPlayerLayer to play the video
        videoPlayer = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.frame = videoView.bounds

        // Add the player layer to your view
        videoView.layer.addSublayer(playerLayer)
        
        // Add a notification observer for the `AVPlayerItemDidPlayToEndTime` notification
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem)


        // Use a Timer to take a screenshot every 30 seconds
        screenshotTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) {[weak self] timer in
            
            guard let self = self else {return}
            
            // Get the current time of the video
            let currentTime = self.videoPlayer.currentTime()

            // Create an AVAssetImageGenerator to generate a screenshot
            let imageGenerator = AVAssetImageGenerator(asset: self.videoPlayer.currentItem!.asset)
            imageGenerator.appliesPreferredTrackTransform = true

            // Generate the image
            do {
                let imageRef = try imageGenerator.copyCGImage(at: currentTime, actualTime: nil)
                let image = UIImage(cgImage: imageRef)
                
                //Apply blur effect & Append the image to the array of screenshots
                self.screenshots.append(self.applyBlurEffect(imageToBlur: image)!)
            } catch {
                print("Error generating screenshot: \(error)")
            }
        }

        // Start the video
        videoPlayer.play()
    }
    
    func applyBlurEffect(imageToBlur: UIImage) -> UIImage? {
        // Create a CIImage from the UIImage
        let ciImage = CIImage(image: imageToBlur)

        // Create a blur filter
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(10.0, forKey: kCIInputRadiusKey)

        // Apply the blur filter and create a blurred CIImage
        guard let blurredCIImage = blurFilter?.outputImage else { return nil}

        // Create a UIImage from the blurred CIImage
        let blurredUIImage = UIImage(ciImage: blurredCIImage)
        return blurredUIImage
    }
    
    //MARK: IBActions and Selector Methods
    
    @objc func videoDidEnd(_ notification: Notification) {
        // Do something when the video ends
        print("Video has ended & SnapsCount -> \(screenshots.count)")
        screenshotTimer?.invalidate()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}





//MARK: *********  collectionView to show screen shots  *********
extension VideoEditingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: imagesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! imagesCell
        cell.imgView.image = screenshots[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 50, height: 300)
    }
    
}


class imagesCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
}
