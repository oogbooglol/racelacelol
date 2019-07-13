//
//  ReadyViewController.swift
//  racelace
//
//  Created by Michael Peng on 7/12/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class ReadyViewController: UIViewController {
    var ref : DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func readyPressed(_ sender: Any) {
        ref.child("queuedPlayers").child((Auth.auth().currentUser?.uid)!).updateChildValues(["Ready": true])
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
