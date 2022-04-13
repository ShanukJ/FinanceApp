//
//  HomeViewController.swift
//  FinanceApp
//
//  Created by Jayamal shanuka Hettiarachchi on 2022-03-22.
//

import UIKit


class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewWillAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.navigationBar.prefersLargeTitles = false

            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .tertiarySystemFill
            appearance.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]

            navigationController?.navigationBar.tintColor = .systemBlue
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    @IBAction func showHelper(_ sender: Any) {
        
        let helperView = storyboard?.instantiateViewController(withIdentifier: "helperView") as! UINavigationController
        helperView.modalPresentationStyle = .pageSheet
        helperView.modalTransitionStyle = .coverVertical
        present(helperView, animated: true, completion: nil)
    }
    
    
    @IBAction func didTapSavings(_ sender: UIButton) {
        let tbc = self.storyboard?.instantiateViewController(withIdentifier:"MainTabBar") as! UITabBarController
           tbc.selectedIndex = 1
        self.show(tbc, sender: self)
    }
    
    @IBAction func didtapLoans(_ sender: UIButton) {
        let tbc = self.storyboard?.instantiateViewController(withIdentifier:"MainTabBar") as! UITabBarController
           tbc.selectedIndex = 2
        self.show(tbc, sender: self)
    }
    
    @IBAction func didtapMortgages(_ sender: UIButton) {
        let tbc = self.storyboard?.instantiateViewController(withIdentifier:"MainTabBar") as! UITabBarController
           tbc.selectedIndex = 3
        self.show(tbc, sender: self)
    }
    
}
