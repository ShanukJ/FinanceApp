//
//  LoansViewController.swift
//  FinanceApp
//
//  Created by Jayamal shanuka Hettiarachchi on 2022-03-28.
//

import UIKit

enum LoanEntities: Int {
    case loanAmount, interest, payment, numOfPayments
}

class LoansViewController: UIViewController, KeyboardDelegate, UITextFieldDelegate, TextFieldsWithPrefix {
    
    @IBOutlet var textfields: [UITextField]!
    @IBOutlet weak var loanAmountTextField: UITextField!
    @IBOutlet weak var interestTextField: UITextField!
    @IBOutlet weak var paymentTextField: UITextField!
    @IBOutlet weak var numOfPaymentsTextField: UITextField!
    
    var activeTextField : UITextField? = nil
    
    var loanData : Loan = Loan()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        self.loadTextFieldData()
        
        let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 270))
        keyboardView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoansViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoansViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.addPrefix(textfileds: [loanAmountTextField, paymentTextField], type: .currency)
        self.addPrefix(textfileds: [interestTextField], type: .percentage)
        self.addPrefix(textfileds: [numOfPaymentsTextField], type: .number)
        
        textfields.forEach { textfield in
            textfield.inputView = keyboardView
            textfield.delegate = self
            textfield.layer.borderWidth = 1
            textfield.layer.borderColor = UIColor.systemGray.cgColor;
            
            //Remove 0.0 from the selected textfield
            if (textfield.text == "0.0"){
                textfield.text?.removeAll()
                loanData.saveDataToStorage()
            }
        }
    }
    
    func loadTextFieldData() {
        // Getting data
        loanData.loadDataFromStorage()
        
        // setting the data
        if let loanAmount = loanData.loanAmount, let interest = loanData.interest, let payment = loanData.payment, let numOfPayments = loanData.numOfPayments {
            loanAmountTextField.text = String(loanAmount)
            paymentTextField.text = String(payment)
            interestTextField.text = String(interest)
            numOfPaymentsTextField.text = String(numOfPayments)
        }
    }
    
    func assignDelegates() {
        loanAmountTextField.delegate = self
        interestTextField.delegate = self
        paymentTextField.delegate = self
        numOfPaymentsTextField.delegate = self
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
    
    @IBAction func onTfValueChange(_ sender: UITextField) {
        var doubleTextFieldValue : Double?
        
        if let textFieldValue = sender.text {
            doubleTextFieldValue = Double(textFieldValue)
        } else {
            doubleTextFieldValue = nil
        }
        
        switch LoanEntities(rawValue: sender.tag)! {
            case .loanAmount:
                loanData.loanAmount = doubleTextFieldValue
            case .interest:
                loanData.interest = doubleTextFieldValue
            case .payment:
                loanData.payment = doubleTextFieldValue
            case .numOfPayments:
                loanData.numOfPayments = doubleTextFieldValue
        }
    }
    
    @IBAction func onCalculatePressed(_ sender: Any) {
        
        if (loanData.canCalculate()) {
            let valueCalculated = loanData.calculateMissingValue().0
            let valueCalculatedType = loanData.calculateMissingValue().1
 
            switch valueCalculatedType {
                case "loanAmount":
                    loanAmountTextField.text = String(valueCalculated)
                    loanData.loanAmount = valueCalculated
                case "interest":
                    interestTextField.text = String(valueCalculated)
                    loanData.interest = valueCalculated
                case "payment":
                    paymentTextField.text = String(valueCalculated)
                    loanData.payment = valueCalculated
                case "numOfPayments":
                    numOfPaymentsTextField.text = String(valueCalculated)
                    loanData.numOfPayments = valueCalculated
                default:
                    print("Default")
            }
            
            // Saving data
            loanData.saveDataToStorage()
            
        } else {
            let alert = UIAlertController(title: "Invalid Calculation", message: "You have to leave only one field empty!", preferredStyle: .alert)
            let done = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(done)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func autoCalculate() {
        if (loanData.canCalculate()) {
            let valueCalculated = loanData.calculateMissingValue().0
            let valueCalculatedType = loanData.calculateMissingValue().1
 
            switch valueCalculatedType {
                case "loanAmount":
                    loanAmountTextField.text = String(valueCalculated)
                    loanData.loanAmount = valueCalculated
                case "interest":
                    interestTextField.text = String(valueCalculated)
                    loanData.interest = valueCalculated
                case "payment":
                    paymentTextField.text = String(valueCalculated)
                    loanData.payment = valueCalculated
                case "numOfPayments":
                    numOfPaymentsTextField.text = String(valueCalculated)
                    loanData.numOfPayments = valueCalculated
                default:
                    print("Default")
            }
            
            // Saving data
            loanData.saveDataToStorage()
            
        } else {
            print("Autocalculate can not proceed")
        }
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        loanAmountTextField.text?.removeAll()
        interestTextField.text?.removeAll()
        paymentTextField.text?.removeAll()
        numOfPaymentsTextField.text?.removeAll()
        
        loanData.saveDataToStorage()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // set the activeTextField to the selected textfield
        self.activeTextField = textField
        // Set active textfield border color
        activeTextField?.layer.borderColor = UIColor.systemBlue.cgColor;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Save user data
        loanData.saveDataToStorage()
        self.activeTextField = nil
        //Set default textfield border color
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray.cgColor;
    }
    

}
