//
//  OnboardingCollectionViewCell.swift
//  FinanceApp
//
//  Created by Jayamal shanuka Hettiarachchi on 2022-03-21.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifire = String(describing: OnboardingCollectionViewCell.self)
    
    @IBOutlet weak var slideImageView: UIImageView!
    
    @IBOutlet weak var slideTitleLable: UILabel!
    
    @IBOutlet weak var slideDescriptionLable: UILabel!
    
    func setup(_ slide: OnboardingSlide){
        slideImageView.image = slide.image
        slideTitleLable.text = slide.title
        slideDescriptionLable.text = slide.description
    }
}
