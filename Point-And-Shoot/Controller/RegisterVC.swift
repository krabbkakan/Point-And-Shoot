//
//  RegisterVC.swift
//  Point-And-Shoot
//
//  Created by Erik Hede on 04/01/2019.
//  Copyright © 2019 Erik Hede. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterVC: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
    }
    @IBAction func registerPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error  != nil {
                print(error!)
            } else {
                SVProgressHUD.dismiss()
                print("Registration sucsessful")
                self.performSegue(withIdentifier: goToGallery, sender: self)
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
    }
    
}
