//
//  ImageEditingViewController.swift
//  BeyondTheApps Assignment
//
//  Created by Umer Farooq on 15/01/2023.
//

import UIKit

class ImageEditingViewController: UIViewController {

    //MARK: Variables & Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var colorPickerSlider: UISlider!
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var createButton: UIButton!
    
    
    var textView = UIView()
    let textLayer = CATextLayer()
    var pointSize: CGFloat = 0

    //MARK: UIViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViewControllerUI()
    }
    
    //MARK: UIViewController Helper Methods
    
    func setupViewControllerUI() {
        self.title = "Image Editing"
        createButton.layer.cornerRadius = 16.0
        createColorBG()
    }
    
    func createColorBG() {
        var colorsArray = [CGColor]()
        for i in 0...10 {
            let point = CGFloat(i) / 10.0
            let loopedPoint = fmodf(Float(point), 1.0)
            colorsArray.append(UIColor(hue: CGFloat(loopedPoint), saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor)
        }
        colorPickerSlider.thumbTintColor = UIColor(cgColor: colorsArray.first!)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorsArray
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame =  CGRect(x: colorPickerSlider.bounds.origin.x + 10,
                                      y: colorPickerSlider.bounds.origin.y + 10,
                                      width: colorPickerSlider.bounds.width - 15,
                                      height: 10)
        colorPickerSlider.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func mapTextOnImage(text: String) {
        // Create a text layer
        let textAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        let textSize = text.size(withAttributes: textAttributes)
        textLayer.string = text
        textLayer.font = UIFont.systemFont(ofSize: 36)
        textLayer.foregroundColor = UIColor.red.cgColor
        textLayer.frame = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)

        // Create a view to hold the text layer
        textView = UIView(frame: textLayer.frame)
        textView.layer.addSublayer(textLayer)
        textView.isUserInteractionEnabled = true
        // Add the text view to the image view
        imageBackView.addSubview(textView)

        // Create a pan gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        textView.addGestureRecognizer(panGesture)
        
        let pintchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchRecoginze))
        textView.addGestureRecognizer(pintchGesture)
        
    }
    
    func makeNewImage() -> UIImage {
        // Add additional subviews or customizations to the subview

        let renderer = UIGraphicsImageRenderer(size: imageBackView.bounds.size)
        let image = renderer.image { (context) in
            imageBackView.layer.render(in: context.cgContext)
        }
        
        return image
    }
    
    func showNewImage() {
        let popover = UIViewController()
        let imageView = UIImageView(frame: CGRect(x: 10, y: 250, width:view.frame.width, height: view.frame.height - 250))
        imageView.image = makeNewImage()
        popover.view.addSubview(imageView)
        popover.modalPresentationStyle = .popover
        popover.popoverPresentationController?.sourceView = view
        popover.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        present(popover, animated: true, completion: nil)
        UIImageWriteToSavedPhotosAlbum(imageView.image ?? UIImage(), nil, nil, nil)
    }

    
    //MARK: IBActions, Selector and Func Methods
    
    // Action method for the color picker slider
    @IBAction func colorPickerSliderChanged(_ sender: UISlider) {
        // Get the current value of the slider
        let sliderValue = sender.value

        // Create a color object using the slider value
        let color = UIColor(hue: CGFloat(sliderValue), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        colorPickerSlider.thumbTintColor = color
        textLayer.foregroundColor = color.cgColor
    }
    
    @IBAction func addTextBtn (_ sender:UIButton) {
        textField.resignFirstResponder()
        if textField.text!.isEmpty {
            let alert = UIAlertController(title: "Alert!", message: "Please write some text first.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
        }else {
            mapTextOnImage(text: textField.text!)
        }
    }
    
    @IBAction func makePhoto (_ sender:UIButton) {
        showNewImage()
    }
        
    // Handle the pan gesture
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        // Get the translation of the gesture
        let translation = gesture.translation(in: imageView.superview)
        
        if textView.frame.origin.y < imageView.frame.origin.y ||  (textView.frame.origin.y + textView.frame.size.height) > (imageView.frame.origin.y + imageView.frame.size.height){
            if textView.frame.origin.y < imageView.frame.origin.y {
                textView.frame.origin.y = imageView.frame.origin.y + 10
            } else if (textView.frame.origin.y + textView.frame.size.height) > (imageView.frame.origin.y + imageView.frame.size.height){
                textView.frame.origin.y = (imageView.frame.origin.y + imageView.frame.size.height) - (textView.frame.size.height + 10)
            }
            return
        }
        
        if textView.frame.origin.x < imageView.frame.origin.x || (textView.frame.origin.x + textView.frame.size.width) > (imageView.frame.origin.x + imageView.frame.size.width) {
            
           if textView.frame.origin.x < imageView.frame.origin.x {
               textView.frame.origin.x = imageView.frame.origin.x + 10
           } else if (textView.frame.origin.x + textView.frame.size.width) > (imageView.frame.origin.x + imageView.frame.size.width) {
               textView.frame.origin.x = (imageView.frame.origin.x + imageView.frame.size.width) - (textView.frame.size.width + 10)
           }
           return
        }
        // Update the view's frame
        textView.frame = textView.frame.offsetBy(dx: translation.x, dy: translation.y)
        // Reset the translation
        gesture.setTranslation(.zero, in: imageView.superview)
        
        print(textView.frame)
    }
    
    
    // Handle the pintch gesture
    @objc func pinchRecoginze(_ pinchGesture: UIPinchGestureRecognizer) {
        guard pinchGesture.view != nil else {return}

        let view = pinchGesture.view!
        if (pinchGesture.view is UILabel) {
            let textLabel = view as! UILabel

            if pinchGesture.state == .began {
                let font = textLabel.font
                pointSize = font!.pointSize

                pinchGesture.scale = textLabel.font!.pointSize * 0.1
            }
            if 1 <= pinchGesture.scale && pinchGesture.scale <= 10  {
                textLabel.font = UIFont(name: textLabel.font!.fontName, size: pinchGesture.scale * 10)

                resizeLabelToText(textLabel: textLabel)
            }
        }
    }

    func resizeLabelToText(textLabel : UILabel) {
        let labelSize = textLabel.intrinsicContentSize
        textLabel.bounds.size = labelSize
        textLabel.font = textLabel.font.withSize(labelSize.height - 10)
    }
}
