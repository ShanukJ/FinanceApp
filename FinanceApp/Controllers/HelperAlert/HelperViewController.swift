//
//  HelperViewController.swift
//  FinanceApp
//
//  Created by Jayamal shanuka Hettiarachchi on 2022-03-26.
//

import UIKit

class HelperViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavItems()
    }
    
    private func configureNavItems(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapClose(_:)))
    }
    
    @objc func didTapClose(_ sender: Any) {
           dismiss(animated: true, completion: nil)
       }
    
}
