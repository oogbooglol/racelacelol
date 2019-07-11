//
//  readyScreen.swift
//  FirebaseAuth
//
//  Created by Ricky Wang on 7/10/19.
//

import UIKit
import Firebase

class readyScreen: UIViewController {
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func readyPressed(_ sender: Any) {
    self.ref.child("queuedPlayers").child(Auth.auth().currentUser!.uid).updateChildValues(["Ready": true])
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
