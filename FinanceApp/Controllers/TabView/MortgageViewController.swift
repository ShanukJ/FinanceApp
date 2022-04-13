//
//  MortgageViewController.swift
//  FinanceApp
//
//  Created by Jayamal shanuka Hettiarachchi on 2022-04-11.
//

import UIKit

enum MortgageEntities: Int {
    case mortgageAmount, interest, payment, numOfYears
}

class MortgageViewController: UIViewController, KeyboardDelegate, UITextFieldDelegate, TextFieldsWithPrefix  {
    
    @IBOutlet var textfields: [UITextField]!
    @IBOutlet weak var mortgageAmountTextField: UITextField!
    @IBOutlet weak var interestTextField: UITextField!
    @IBOutlet weak var paymentTextField: UITextField!
    @IBOutlet weak var numOfYearsTextField: UITextField!
    
    var mortgageData : Mortgage = Mortgage()
    
    var activeTextField : UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        self.loadTextFieldData()
        
        let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 270))
        keyboardView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(MortgageViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MortgageViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        self.addPrefix(textfileds: [mortgageAmountTextField, paymentTextField], type: .currency)
        self.addPrefix(textfileds: [interestTextField], type: .percentage)
        self.addPrefix(textfileds: [numOfYearsTextField], type: .number)
        
        textfields.forEach { textfield in
            textfield.inputView = keyboardView
            textfield.delegate = self
            textfield.layer.borderWidth = 1
            textfield.layer.borderColor = UIColor.systemGray.cgColor;
            
            //Remove 0.0 from the selected textfield
            if (textfield.text == "0.0"){
                textfield.text?.removeAll()
                mortgageData.saveDataToStorage()
            }
        }
    }
    
    func loadTextFieldData() {
        // Getting data
        mortgageData.loadDataFromStorage()
        
        // setting the data
        if let mortgageAmount = mortgageData.mortgageAmount, let interest = mortgageData.interest, let payment = mortgageData.payment, let numOfYears = mortgageData.numOfYears {
            mortgageAmountTextField.text = String(mortgageAmount)
            paymentTextField.text = String(payment)
            interestTextField.text = String(interest)
            numOfYearsTextField.text = String(numOfYears)
            
        }
    }
    
    func assignDelegates() {
        mortgageAmountTextField.delegate = self
        interestTextField.delegate = self
        paymentTextField.delegate = self
        numOfYearsTextField.delegate = self
    }
    
    @IBAction func onTfValueChange(_ sender: UITextField) {
        var doubleTextFieldValue : Double?
        
        if let textFieldValue = sender.text {
            doubleTextFieldValue = Double(textFieldValue)
        } else {
            doubleTextFieldValue = nil
        }
        
        switch MortgageEntities(rawValue: sender.tag)! {
            case .mortgageAmount:
                mortgageData.mortgageAmount = doubleTextFieldValue
            case .interest:
                mortgageData.interest = doubleTextFieldValue
            case .payment:
                mortgageData.payment = doubleTextFieldValue
            case .numOfYears:
                mortgageData.numOfYears = doubleTextFieldValue
        }
    }
    
    @IBAction func showMonths(_ sender: UIButton) {
        
        
        let text: String = numOfYearsTextField.text!
        var multipliedNum: Int = 0
        
        let intValue = (text as NSString).integerValue
        
        if ((numOfYearsTextField.text) != nil) {
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
    
    @IBAction func clearAll(_ sender: UIButton) {
        mortgageAmountTextField.text?.removeAll()
        interestTextField.text?.removeAll()
        paymentTextField.text?.removeAll()
        numOfYearsTextField.text?.removeAll()
        
        mortgageData.saveDataToStorage()
    }
    
    @IBAction func onCalculatePressed(_ sender: Any) {
        
        if (mortgageData.canCalculate()) {
            let valueCalculated = mortgageData.calculateMissingValue().0
            let valueCalculatedType = mortgageData.calculateMissingValue().1
 
            switch valueCalculatedType {
                case "mortgageAmount":
                    mortgageAmountTextField.text = String(valueCalculated)
                    mortgageData.mortgageAmount = valueCalculated
                case "interest":
                    interestTextField.text = String(valueCalculated)
                    mortgageData.interest = valueCalculated
                case "payment":
                    paymentTextField.text = String(valueCalculated)
                    mortgageData.payment = valueCalculated
                case "numOfYears":
                    numOfYearsTextField.text = String(valueCalculated)
                    mortgageData.numOfYears = valueCalculated
                default:
                    print("Default")
            }
            
            // Saving data
            mortgageData.saveDataToStorage()
            
        } else {
            let alert = UIAlertController(title: "Invalid Calculation", message: "You have to leave only one field empty!", preferredStyle: .alert)
            let done = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(done)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func autoCalculate() {
        if (mortgageData.canCalculate()) {
            let valueCalculated = mortgageData.calculateMissingValue().0
            let valueCalculatedType = mortgageData.calculateMissingValue().1
 
            switch valueCalculatedType {
                case "mortgageAmount":
                    mortgageAmountTextField.text = String(valueCalculated)
                    mortgageData.mortgageAmount = valueCalculated
                case "interest":
                    interestTextField.text = String(valueCalculated)
                    mortgageData.interest = valueCalculated
                case "payment":
                    paymentTextField.text = String(valueCalculated)
                    mortgageData.payment = valueCalculated
                case "numOfYears":
                    numOfYearsTextField.text = String(valueCalculated)
                    mortgageData.numOfYears = valueCalculated
                default:
                    print("Default")
            }
            
            // Saving data
            mortgageData.saveDataToStorage()
            
        } else {
            print("Auto calculation can not proceed!")
        }
    }
    
    func keyWasTapped(character: String) {
        let textfield = textfields.filter {tf in
            return tf.isFirstResponder
        }.first
                
        if let _ = textfield {
            textfield?.insertText(character)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // set the activeTextField to the selected textfield
        self.activeTextField = textField
        // Set active textfield border color
        activeTextField?.layer.borderColor = UIColor.systemBlue.cgColor;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Save user data
        //compoundSavingsData.saveDataToStorage()
        self.activeTextField = nil
        //Set default textfield border color
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray.cgColor;
    }

}
