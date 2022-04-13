//
//  Mortgage.swift
//  FinanceApp
//
//  Created by Jayamal shanuka Hettiarachchi on 2022-04-11.
//

import Foundation
class Mortgage: CalculationHelper {
    var mortgageAmount, interest, payment, numOfYears : Double?
    
    init() {
        mortgageAmount = nil
        interest = nil
        payment = nil
        numOfYears = nil
    }
    
    func canCalculate() -> Bool {
        var nonNilCount = 0
        if (self.mortgageAmount != nil) { nonNilCount += 1 }
        if (self.interest != nil) { nonNilCount += 1 }
        if (self.payment != nil) { nonNilCount += 1 }
        if (self.numOfYears != nil) { nonNilCount += 1 }
        
        return nonNilCount == 3;
    }
    
    func calculateMissingValue() -> (Double, String) {
        // Calculating mortgage Amount
        if (self.mortgageAmount == nil) {
            var calculatedMortgageAmount: Double = 0.0
            if let interest = self.interest, let payment = self.payment, let numOfYears = self.numOfYears {
                let i = (interest / 100) / 12
                let n = numOfYears * 12
                calculatedMortgageAmount = payment / (( i * pow(1 + i, n)) / (pow(1 + i, n) - 1))
            }
            return (calculatedMortgageAmount.toFixed(2), "mortgageAmount")
        }
        
        // Calculating interest
        if (self.interest == nil) {
            var calculatedInterest: Double = 0.0
            if let mortgageAmount = self.mortgageAmount, let payment = self.payment, let numOfYears = self.numOfYears {
                calculatedInterest = self.missingInterestRate(pa: mortgageAmount, payment: payment, terms: numOfYears * 12)
            }
            return (calculatedInterest.toFixed(2), "interest")
        }
        
        // Calculating payment
        if (self.payment == nil) {
            var calculatedPayment: Double = 0.0
            if let mortgageAmount = self.mortgageAmount, let interest = self.interest, let numOfYears = self.numOfYears {
                let i = (interest / 100) / 12
                let n = numOfYears * 12
                calculatedPayment = mortgageAmount * ( i * pow(1 + i, n)) / (pow(1 + i, n) - 1)
            }
            return (calculatedPayment.toFixed(2), "payment")
        }

        // Calculating numOfYears
        if (self.numOfYears == nil) {
            var calculatedNumOfYears: Double = 0.0
            if let mortgageAmount = self.mortgageAmount, let payment = self.payment, let interest = self.interest {
                let i = (interest / 100) / 12
                let calculatedNumOfMonths = log((payment / i) / ((payment / i) - mortgageAmount)) / log(1 + i)
                calculatedNumOfYears = calculatedNumOfMonths / 12
            }
            return (calculatedNumOfYears.toFixed(2), "numOfYears")
        }
        return (0.0, "nil")
    }
    
    func saveDataToStorage() {
        let defaults = UserDefaults.standard

        defaults.set(self.mortgageAmount, forKey: "Mortgage-mortgageAmount")
        defaults.set(self.interest, forKey: "Mortgage-interest")
        defaults.set(self.payment, forKey: "Mortgage-payment")
        defaults.set(self.numOfYears, forKey: "Mortgage-numOfYears")
    }

    func loadDataFromStorage() {
        let defaults = UserDefaults.standard
        
        self.mortgageAmount = defaults.object(forKey: "Mortgage-mortgageAmount") as? Double ?? Double()
        self.interest = defaults.object(forKey: "Mortgage-interest") as? Double ?? Double()
        self.payment = defaults.object(forKey: "Mortgage-payment") as? Double ?? Double()
        self.numOfYears = defaults.object(forKey: "Mortgage-numOfYears") as? Double ?? Double()
    }
}
