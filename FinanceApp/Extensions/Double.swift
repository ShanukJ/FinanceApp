//
//  Double.swift
//  FinanceApp
//
//  Created by Jayamal shanuka Hettiarachchi on 2022-04-10.
//

import Foundation

extension Double {
    func toFixed(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (divisor*self).rounded() / divisor
    }
}
