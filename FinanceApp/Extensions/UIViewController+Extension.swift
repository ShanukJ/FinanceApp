//
//  UIViewController+Extension.swift
//  FinanceApp
//
//  Created by Jayamal shanuka Hettiarachchi on 2022-04-12.
//

import Foundation
import UIKit

extension UIViewController {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifier) as! Self
    }
}
