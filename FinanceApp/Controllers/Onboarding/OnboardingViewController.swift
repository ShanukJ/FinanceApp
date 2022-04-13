//
//  OnboardingViewController.swift
//  FinanceApp
//
//  Created by Jayamal shanuka Hettiarachchi on 2022-03-21.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [OnboardingSlide] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
    }
    
}
