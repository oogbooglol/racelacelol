//
//  SignUpViewController.swift
//  racelace
//
//  Created by Michael Peng on 6/30/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var errorField: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    var ref: DatabaseReference!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
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
//        let playerDB = Database.database().reference().child("Players")
//        let playerDictionary = ["Name" : Auth.auth().currentUser?.email!, "Score" : 28] as! [String: Any]
//        playerDB.childByAutoId().setValue(playerDictionary) {
//            (error, reference) in
//            if error != nil{
//                print("ooooooooooga\(error)")
//            }
//            else {
//                print("Message Saved")
//            }
//        }
        
        
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if error != nil {
                self.errorField.isHidden = false
                SVProgressHUD.dismiss()
                print("the error is: \(error)")
            }
            else {
                self.ref.child("Players").child(Auth.auth().currentUser!.uid).setValue(["Currency": 0, "Lobby" : 0])
                self.performSegue(withIdentifier: "regToMain", sender: self)
                SVProgressHUD.dismiss()
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
