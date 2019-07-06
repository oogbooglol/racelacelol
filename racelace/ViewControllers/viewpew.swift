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

    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenus()
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
    @IBAction func Activate(_ sender: Any) {
        let playerDB = Database.database().reference().child("Players")
        
        
        
        let playerDictionary = ["Name" : Auth.auth().currentUser?.email!, "Score" : 28] as! [String: Any]
        playerDB.childByAutoId().setValue(playerDictionary) {
            (error, reference) in
            if error != nil{
                print("ooooooooooga\(error)")
            }
            else {
                print("Message Saved")
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
