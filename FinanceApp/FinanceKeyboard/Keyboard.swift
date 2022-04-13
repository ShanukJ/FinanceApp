//
//  Keyboard.swift
//  FinanceApp
//
//  Created by Jayamal shanuka Hettiarachchi on 2022-04-02.
//

import UIKit

protocol KeyboardDelegate: AnyObject {
    func keyWasTapped(character: String)
    func didPressDelete()
    func didPressDone()
    func didPressDecimal()
    func didPressMinus()
    func didPressAllClear()
}

class Keyboard: UIView {

    weak var delegate: KeyboardDelegate?
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            initializeSubviews()
        }
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            initializeSubviews()
        }
    
    func initializeSubviews() {
            let xibFileName = "Keyboard" // xib extention not included
            let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
            self.addSubview(view)
            view.frame = self.bounds
        }
    
    @IBAction func keyTapped(sender: UIButton) {
            // When a button is tapped, send that information to the
            // delegate (ie, the view controller)
        self.delegate?.keyWasTapped(character: sender.titleLabel!.text!)        
        }
    
    @IBAction func doneKeyTapped(sender: UIButton) {
            // When a button is tapped, send that information to the
            // delegate (ie, the view controller)
        self.delegate?.didPressDone()
        }
    
    @IBAction func deleteKeyTapped(sender: UIButton) {
            // When a button is tapped, send that information to the
            // delegate (ie, the view controller)
        self.delegate?.didPressDelete()
        }
    
    @IBAction func minusKeyTapped(sender: UIButton) {
            // When a button is tapped, send that information to the
            // delegate (ie, the view controller)
        self.delegate?.didPressMinus()
        }
    
    @IBAction func decimalKeyTapped(sender: UIButton) {
            // When a button is tapped, send that information to the
            // delegate (ie, the view controller)
        self.delegate?.didPressDecimal()
        }
    
    @IBAction func allClearKeyTapped(sender: UIButton) {
            // When a button is tapped, send that information to the
            // delegate (ie, the view controller)
        self.delegate?.didPressAllClear()
        }

}
