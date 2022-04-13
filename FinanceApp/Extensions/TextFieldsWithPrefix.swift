//
//  TextFieldsWithPrefix.swift
//  FinanceApp
//
//  Created by Jayamal shanuka Hettiarachchi on 2022-04-11.
//

import Foundation
import UIKit

enum PrefixType {
    case currency, number, percentage
}

protocol TextFieldsWithPrefix {
    func addPrefix(textfileds: [UITextField], type: PrefixType)
}

extension TextFieldsWithPrefix {
    func addPrefix(textfileds: [UITextField], type: PrefixType) {
        var text = "  "
        switch type {
        case .currency:
            text = "  $"
        case .number:
            text = "  #"
        case .percentage:
            text = "  %"
        }
        
        for field in textfileds {
            let prefix = UILabel()
            
            prefix.text = text
            field.leftView = prefix
            field.leftViewMode = .always
            prefix.sizeToFit()
            prefix.font = prefix.font.withSize(14)
            prefix.textColor = UIColor.gray;
        }
    }
}
