//
//  UserDefaults+Extension.swift
//  FinanceApp
//
//  Created by Jayamal shanuka Hettiarachchi on 2022-04-12.
//

import Foundation

extension UserDefaults {
    private enum UserDefaultsKeys : String {
        case hasOnboarded
    }
    
    var hasOnboarded: Bool {
        get {
            bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        set {
            setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
    }
}
