//
//  ViewController.swift
//  BeyondTheApps Assignment
//
//  Created by Umer Farooq on 15/01/2023.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Variables & Outlets
    
    @IBOutlet weak var imageEditingButton: UIButton!
    @IBOutlet weak var videoEditingButton: UIButton!
    
    
    //MARK: UIViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
    }
    
    //MARK: UIViewController Helper Methods
    
    func setupViewControllerUI() {
        setupNavigationBar()
        imageEditingButton.layer.cornerRadius = 16.0
        videoEditingButton.layer.cornerRadius = 16.0
        
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.blue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        self.navigationItem.title = "My Assignment"
    }

    
    //MARK: Functions & IBActions Methods
    
    @IBAction func imageEditingTaskButtonTapped(_ sender: UIButton) {
        let imageEditingVC = getStoryBoardInitilized().instantiateViewController(withIdentifier: "ImageEditingViewController") as!  ImageEditingViewController
        self.navigationController?.pushViewController(imageEditingVC, animated: true)
    }
    

    @IBAction func videoEditingTaskButtonTapped(_ sender: UIButton) {
        let videoEditingVC = getStoryBoardInitilized().instantiateViewController(withIdentifier: "VideoEditingViewController") as!  VideoEditingViewController
        self.navigationController?.pushViewController(videoEditingVC, animated: true)
    }
    
    func getStoryBoardInitilized() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard
    }
}




