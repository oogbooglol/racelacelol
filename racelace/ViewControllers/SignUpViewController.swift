//
//  SignUpViewController.swift
//  racelace
//
//  Created by Michael Peng on 6/30/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var errorField: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailField.delegate = self
        self.passwordField.delegate = self
        errorField.text = "Invalid Email or Password"
        errorField.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func signUp(_ sender: Any) {
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if error != nil {
                self.errorField.isHidden = false
                SVProgressHUD.dismiss()
                print("the error is: \(error)")
            }
            else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "regToMain", sender: self)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
