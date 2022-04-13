//
//  SavingsViewController.swift
//  FinanceApp
//
//  Created by Jayamal shanuka Hettiarachchi on 2022-03-28.
//

import UIKit

enum SavingsEntities: Int {
    case presentValue, interest, paymentValue, futureValue, numOfYears
}

class SavingsViewController: UIViewController, KeyboardDelegate, UITextFieldDelegate, TextFieldsWithPrefix {
    
    @IBOutlet var textfields: [UITextField]!
    @IBOutlet weak var presentValueTextField: UITextField!
    @IBOutlet weak var interestTextField: UITextField!
    @IBOutlet weak var numberOfCompoundsPerYearTextField: UITextField!
    @IBOutlet weak var isBeginningSwitch: UISwitch!
//    @IBOutlet weak var isYearsEnabled: UISwitch!
    @IBOutlet weak var paymentValueTextField: UITextField!
    @IBOutlet weak var futureValueTextField: UITextField!
    @IBOutlet weak var numberOfYearsTextField: UITextField!
    
    var savingsData : Savings = Savings()
    
    var activeTextField : UITextField? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 270))
        keyboardView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(SavingsViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SavingsViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.loadTextFieldData()
        
        self.addPrefix(textfileds: [presentValueTextField, futureValueTextField, paymentValueTextField], type: .currency)
        self.addPrefix(textfileds: [interestTextField], type: .percentage)
        self.addPrefix(textfileds: [numberOfCompoundsPerYearTextField, numberOfYearsTextField], type: .number)
        
        textfields.forEach { textfield in
            textfield.inputView = keyboardView
            textfield.delegate = self
            textfield.layer.borderWidth = 1
            textfield.layer.borderColor = UIColor.systemGray.cgColor;
            
            //Remove 0.0 from the selected textfield
            if (textfield.text == "0.0"){
                textfield.text?.removeAll()
                savingsData.saveDataToStorage()
            }
        }
        
    }
    
    func assignDelegates() {
        presentValueTextField.delegate = self
        interestTextField.delegate = self
        paymentValueTextField.delegate = self
        futureValueTextField.delegate = self
        presentValueTextField.delegate = self
        numberOfYearsTextField.delegate = self
    }
    
    func loadTextFieldData() {
        // Getting data
        savingsData.loadDataFromStorage()

        // setting the data
        if let presentValue = savingsData.presentValue, let interest = savingsData.interest, let numberOfCompoundsPerYear = savingsData.numberOfCompoundsPerYear, let paymentValue = savingsData.paymentValue, let futureValue = savingsData.futureValue, let numOfYears = savingsData.numOfYears {

            presentValueTextField.text = String(presentValue)
            interestTextField.text = String(interest)
            isBeginningSwitch.isOn = savingsData.isBeginning
            paymentValueTextField.text = String(paymentValue)
            numberOfCompoundsPerYearTextField.text = String(numberOfCompoundsPerYear)
            futureValueTextField.text = String(futureValue)
            numberOfYearsTextField.text = String(numOfYears)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

        // if keyboard size is not available for some reason, dont do anything
        return
      }

      // if active text field is not nil
      if let activeTextField = activeTextField {

        let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
        
        let topOfKeyboard = self.view.frame.height - keyboardSize.height

        // if the bottom of Textfield is below the top of keyboard, move up
        if bottomOfTextField > topOfKeyboard {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
      }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }
    
    func keyWasTapped(character: String) {
        let textfield = textfields.filter {tf in
            return tf.isFirstResponder
        }.first
                
        if let _ = textfield {
            textfield?.insertText(character)
        }
    }
    
    @IBAction func onTfValueChange(_ sender: UITextField) {
        var doubleTextFieldValue : Double?
        
        if let textFieldValue = sender.text {
            doubleTextFieldValue = Double(textFieldValue)
        } else {
            doubleTextFieldValue = nil
        }
        
        switch SavingsEntities(rawValue: sender.tag)! {
            case .presentValue:
                savingsData.presentValue = doubleTextFieldValue
            case .interest:
                savingsData.interest = doubleTextFieldValue
            case .paymentValue:
                savingsData.paymentValue = doubleTextFieldValue
            case .futureValue:
                savingsData.futureValue = doubleTextFieldValue
            case .numOfYears:
                savingsData.numOfYears = doubleTextFieldValue
        }
    }
    
    @IBAction func onSwitchValueChange(_ sender: UISwitch) {
        savingsData.isBeginning = sender.isOn
    }
    
    @IBAction func onCalculatePressed(_ sender: Any) {
        
        if (savingsData.canCalculate()) {
            let valueCalculated = savingsData.calculateMissingValue().0
            let valueCalculatedType = savingsData.calculateMissingValue().1
 
            switch valueCalculatedType {
                case "presentValue":
                    presentValueTextField.text = String(valueCalculated)
                    savingsData.presentValue = valueCalculated
                case "interest":
                    let alert = UIAlertController(title: "Not Supported!", message: "Interest calculation is not supported yet!", preferredStyle: .alert)
                    let done = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(done)
                    present(alert, animated: true, completion: nil)
                case "paymentValue":
                    paymentValueTextField.text = String(valueCalculated)
                    savingsData.paymentValue = valueCalculated
                case "futureValue":
                    futureValueTextField.text = String(valueCalculated)
                    savingsData.futureValue = valueCalculated
                case "numOfYears":
                    numberOfYearsTextField.text = String(valueCalculated)
                    savingsData.numOfYears = valueCalculated
                default:
                    print("Default")
            }
            
            // Saving data
            savingsData.saveDataToStorage()
            
        } else {
            let alert = UIAlertController(title: "Invalid Calculation", message: "You have to leave only one field empty!", preferredStyle: .alert)
            let done = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(done)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func autoCalculate() {
        if (savingsData.canCalculate()) {
            let valueCalculated = savingsData.calculateMissingValue().0
            let valueCalculatedType = savingsData.calculateMissingValue().1
 
            switch valueCalculatedType {
                case "presentValue":
                    presentValueTextField.text = String(valueCalculated)
                    savingsData.presentValue = valueCalculated
                case "interest":
                    let alert = UIAlertController(title: "Not Supported!", message: "Interest calculation is not supported yet!", preferredStyle: .alert)
                    let done = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(done)
                    present(alert, animated: true, completion: nil)
                case "paymentValue":
                    paymentValueTextField.text = String(valueCalculated)
                    savingsData.paymentValue = valueCalculated
                case "futureValue":
                    futureValueTextField.text = String(valueCalculated)
                    savingsData.futureValue = valueCalculated
                case "numOfYears":
                    numberOfYearsTextField.text = String(valueCalculated)
                    savingsData.numOfYears = valueCalculated
                default:
                    print("Default")
            }
            
            // Saving data
            savingsData.saveDataToStorage()
            
        } else {
            print("Auto calculation not possible")
        }
    }

    
    func didPressDelete() {
        let textfield = textfields.filter {tf in
            return tf.isFirstResponder
        }.first
        
        
        if let tf = textfield {
            if (tf.text?.count ?? 0 ) > 0{
                _ = tf.text!.removeLast()
//                changeWeight(textfield: tf)
            }
        }
    }

    func didPressDone() {
        let textfield = textfields.filter {tf in
            return tf.isFirstResponder
        }.first
        
        if let _ = textfield {
            textfield!.resignFirstResponder()
        }
        
        autoCalculate()
    }
    
    func didPressAllClear() {
        let textfield = textfields.filter {tf in
            return tf.isFirstResponder
        }.first
        
        if let _ = textfield {
            textfield?.text?.removeAll()
        }
    }
    
    func didPressDecimal() {
        let textfield = textfields.filter {tf in
            return tf.isFirstResponder
        }.first
        
        if let tf = textfield {
            let text: String = tf.text!
            let decimal = "."
            if (tf.text?.count ?? 0 ) > 0 && (text.contains(decimal) == false){
                tf.text! += "."
            }
        }
    }
    
    func didPressMinus() {
        let textfield = textfields.filter {tf in
            return tf.isFirstResponder
        }.first
        
        if let tf = textfield {
            let text: String = tf.text!
            let minus = "-"
            if (tf.text?.count ?? 0 ) == 0 && (text.contains(minus) == false){
                tf.text! += "-"
            }
        }
    }
    
    
    @IBAction func clearAll(_ sender: UIButton) {
        presentValueTextField.text?.removeAll()
        interestTextField.text?.removeAll()
        paymentValueTextField.text?.removeAll()
        futureValueTextField.text?.removeAll()
        presentValueTextField.text?.removeAll()
        numberOfYearsTextField.text?.removeAll()
        
        savingsData.saveDataToStorage()
    }
    
    @IBAction func showMonths(_ sender: UIButton) {
        
        
        let text: String = numberOfYearsTextField.text!
        var multipliedNum: Int = 0
        
        let intValue = (text as NSString).integerValue
        
        if ((numberOfYearsTextField.text) != nil) {
            multipliedNum = intValue * 12
            
            let alert = UIAlertController(title: "Total number of months", message: "\(multipliedNum)", preferredStyle: .alert)
            let done = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(done)
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Total number of months", message: "No data found", preferredStyle: .alert)
            let done = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(done)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // set the activeTextField to the selected textfield
        self.activeTextField = textField
        // Set active textfield border color
        activeTextField?.layer.borderColor = UIColor.systemBlue.cgColor;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Save user data
        savingsData.saveDataToStorage()
        self.activeTextField = nil
        //Set default textfield border color
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray.cgColor;
    }

}
