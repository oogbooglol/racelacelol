//
//  LobbyOneViewController.swift
//  racelace
//
//  Created by Michael Peng on 7/9/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class LobbyOneViewController: UIViewController {
    var ref : DatabaseReference!

    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func testButton(_ sender: Any) {
        fetchPlayers()
    }
    
    func fetchPlayers(){
        ref.child("Players").observeSingleEvent(of: .value) { snapshot in
            print(snapshot.childrenCount)
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                var points = -1
                guard let value = rest.value as? NSDictionary else {
                    print("No Data!!!")
                    return
                }
                points = value["Currency"] as! Int
                print(points)
                
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
