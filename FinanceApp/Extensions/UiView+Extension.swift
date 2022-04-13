//
//  UiView+Extension.swift
//  FinanceApp
//
//  Created by Jayamal shanuka Hettiarachchi on 2022-03-21.
//

import Foundation
import UIKit

extension UIView{
   @IBInspectable var cornerRadius: CGFloat{
       get{ return self.cornerRadius }
        set{
            self.layer.cornerRadius = newValue
        }
    }
}
