//
//  ViewController.swift
//  LoyaltyCard(Simple)
//
//  Created by Mitchell Phillips on 4/3/16.
//  Copyright © 2016 Wasted Potential LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func editTapped(_ sender: UIButton) {
        showAlert()
        checkForRedeemable()
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        latteButtonTapped(sender)
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
        saveDefaults()
        doneOutlet.isHidden = true
        editOutlet.isHidden = false
        isAuthorized = false
        updateUI()
    }
    
    @IBAction func redeemTapped(_ sender: UIButton) {
        if isAuthorized == true {
        latteStamps = 0
        redeemOutlet.isHidden = true
        updateUI()
        }
    }
    
    
    @IBOutlet weak var doneOutlet: UIButton!
    @IBOutlet weak var editOutlet: UIButton!
    @IBOutlet weak var redeemOutlet: UIButton!
    @IBOutlet var latteButtonCollection: Array<UIButton>?
    
    var verificationCode = "4444"
    var latteStamps = 0
    var coffeeStamps = 0
    var isAuthorized: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDefaults()
        checkForRedeemable()
        updateUI()
        
    }

    //MARK: - Button functions
    
    func latteButtonTapped(_ sender:UIButton) {
        if isAuthorized == true {
            if sender.isSelected == true {
                latteStamps = latteStamps - 1
                sender.isSelected = false
            } else {
                latteStamps = latteStamps + 1
                sender.isSelected = true
            }
        }
        
        checkForRedeemable()
        
        print("stamps equals \(latteStamps)")
        
    }
    
    //MARK: - Alert set up
    
    func showAlert() {
        
        let alertController = UIAlertController(title: "Edit", message: "Enter code", preferredStyle: .alert)
        
        let verifyAction = UIAlertAction(title: "Edit", style: .default) {
            (verifyAction) -> Void in
            
            let textField = alertController.textFields?.first
            // test for verification
            if textField!.text == self.verificationCode {
                print("approved")
                self.latteStamps = 0
                self.coffeeStamps = 0
                self.loadDefaults()
                self.updateUI()
                self.doneOutlet.isHidden = false
                self.editOutlet.isHidden = true
                self.isAuthorized = true
                
            } else {
                // fails authorization
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (alertAction) -> Void in
            
        }
        alertController.addTextField { (textField) -> Void in
            
        }
        alertController.addAction(verifyAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    //MARK: - UI interaction functions
    func checkForRedeemable() {
        
        if self.latteStamps == 10 {
            self.redeemOutlet.isHidden = false
        } else {
            self.redeemOutlet.isHidden = true
        }
    }

    
    func updateUI() {
        
        for button in latteButtonCollection! {
            button.isSelected = false
            
            if button.tag <= latteStamps {
                button.isSelected = true
            }
            
        }
        
    }
    
    //MARK: - NSUserDefaults functions
    func saveDefaults() {
        print("saved")
        let defaults = UserDefaults.standard
        let numberOfLattes = NSNumber(value: self.latteStamps)
        let numberOfCoffees = NSNumber(value: self.coffeeStamps)
        defaults.setValue(numberOfLattes, forKey: "stampsNumber")
        defaults.setValue(numberOfCoffees, forKey: "coffeeStamps")
        defaults.synchronize()
        
    }
    
    func loadDefaults() {
        let defaults = UserDefaults.standard
        if let value = defaults.value(forKey: "stampsNumber") as? NSNumber {
            self.latteStamps = value.intValue
        }
        if let coffeeValue = defaults.value(forKey: "coffeeStamps") as? NSNumber {
            self.coffeeStamps = coffeeValue.intValue
        }
        print("loaded stamps \(latteStamps)")
        
    }
}
