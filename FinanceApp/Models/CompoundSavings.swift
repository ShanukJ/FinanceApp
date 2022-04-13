//
//  CompoundSavings.swift
//  FinanceApp
//
//  Created by Jayamal shanuka Hettiarachchi on 2022-04-10.
//


import Foundation

class CompoundSavings {
    var presentValue, interest, numberOfCompoundsPerYear, futureValue, numOfYears : Double?
    
    init() {
        presentValue = nil
        interest = nil
        numberOfCompoundsPerYear = 12
        futureValue = nil
        numOfYears = nil
    }
    
    func canCalculate() -> Bool {
        var nonNilCount = 0
        if (self.presentValue != nil) { nonNilCount += 1 }
        if (self.interest != nil) { nonNilCount += 1 }
        if (self.futureValue != nil) { nonNilCount += 1 }
        if (self.numOfYears != nil) { nonNilCount += 1 }

        return nonNilCount == 3;
    }
    
    func calculateMissingValue() -> (Double, String) {
        
        // Calculating Present Value
        if (self.presentValue == nil) {
            var calculatedPresentValue: Double = 0.0
            
            if let interest = self.interest, let numberOfCompoundsPerYear = self.numberOfCompoundsPerYear, let futureValue = self.futureValue, let numOfYears = self.numOfYears {
                let i = interest/100
                calculatedPresentValue = futureValue / pow((1 + (i / numberOfCompoundsPerYear)), numberOfCompoundsPerYear * numOfYears)
            }
            return (calculatedPresentValue.toFixed(2), "presentValue")
        }
        
        // Calculating interest
        if (self.interest == nil) {
            var calculatedInterest: Double = 0.0
            
            if let presentValue = self.presentValue, let numberOfCompoundsPerYear = self.numberOfCompoundsPerYear, let futureValue = self.futureValue, let numOfYears = self.numOfYears {
                calculatedInterest = numberOfCompoundsPerYear * (pow((futureValue / presentValue), (1 / (numberOfCompoundsPerYear * numOfYears))) - 1)
                calculatedInterest = calculatedInterest * 100
            }
            return (calculatedInterest.toFixed(2), "interest")
        }
        
        // Calculating futureValue
        if (self.futureValue == nil) {
            var calculatedFutureValue: Double = 0.0
            
            if let presentValue = self.presentValue, let interest = self.interest, let numberOfCompoundsPerYear = self.numberOfCompoundsPerYear, let numOfYears = self.numOfYears {
                let i = interest/100
                calculatedFutureValue = presentValue * pow((1 + i / numberOfCompoundsPerYear), numberOfCompoundsPerYear * numOfYears)
            }
            return (calculatedFutureValue.toFixed(2), "futureValue")
        }
        
        // Calculating numOfYears
        if (self.numOfYears == nil) {
            var calculatedNumOfYears: Double = 0.0
            
            if let presentValue = self.presentValue, let interest = self.interest, let numberOfCompoundsPerYear = self.numberOfCompoundsPerYear, let futureValue = self.futureValue {
                let i = interest/100
                calculatedNumOfYears = log(futureValue/presentValue) / (numberOfCompoundsPerYear *  log(1 + (i / numberOfCompoundsPerYear)))
            }
            return (calculatedNumOfYears.toFixed(2), "numOfYears")
        }
        
        return (0.0, "nil")
    }
    
    func saveDataToStorage() {
        let defaults = UserDefaults.standard
        
        defaults.set(self.presentValue, forKey: "CompoundSavings-presentValue")
        defaults.set(self.interest, forKey: "CompoundSavings-interest")
        defaults.set(self.futureValue, forKey: "CompoundSavings-futureValue")
        defaults.set(self.numOfYears, forKey: "CompoundSavings-numOfYears")
    }

    func loadDataFromStorage() {
        let defaults = UserDefaults.standard
        
        self.presentValue = defaults.object(forKey: "CompoundSavings-presentValue") as? Double ?? Double()
        self.interest = defaults.object(forKey: "CompoundSavings-interest") as? Double ?? Double()
        self.futureValue = defaults.object(forKey: "CompoundSavings-futureValue") as? Double ?? Double()
        self.numOfYears = defaults.object(forKey: "CompoundSavings-numOfYears") as? Double ?? Double()
    }
}

