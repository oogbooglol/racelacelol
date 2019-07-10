//
//  viewpew.swift
//  racelace
//
//  Created by Ricky Wang on 7/2/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class viewpew: UIViewController {

    
    var ref: DatabaseReference!
    var points : Int = 0
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var scoreText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenus()
        ref = Database.database().reference()
        retrieveData()
        print(points)
        self.scoreText.text = "Currency:\(points)"
        // Do any additional setup after loading the view.
    }
    func sideMenus() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func getInQ(_ sender: Any) {
        ref.child("queuedPlayers").child(Auth.auth().currentUser!.uid).setValue(Auth.auth().currentUser!.uid)
    }
    @IBAction func activate(_ sender: Any) {
    }

    @IBAction func signOut(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }//411837
    @IBAction func biggerTheScore(_ sender: Any) {
        retrieveData()
        print(points)
        ref.child("Players").child(Auth.auth().currentUser!.uid).updateChildValues(["Currency":points+1])
        self.scoreText.text = "Currency:\(points)"
    }
    func retrieveData() {
        let userID = (Auth.auth().currentUser?.uid)!
        ref.child("Players").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!")
                return
            }
            self.points = value["Currency"] as! Int
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
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
