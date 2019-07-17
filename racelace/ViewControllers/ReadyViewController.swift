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
    var ready = 0
    var currLobby = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func readyPressed(_ sender: Any) {
        ref.child("queuedPlayers").child((Auth.auth().currentUser?.uid)!).updateChildValues(["Ready": true])
        
        var timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(ReadyViewController.check), userInfo: nil, repeats: true)
    }
    
    @objc func check(){
        ready = 0
        fetchPlayers()
    }
    
    
    func fetchPlayers(){
        ref.child("queuedPlayers").observeSingleEvent(of: .value) { snapshot in
            print(snapshot.childrenCount)
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = rest.value as? NSDictionary else {
                    print("No Data!!!")
                    return
                }
                let lobbyNum = value["Lobby"] as! Int
                let isReady = value["Ready"] as! Bool
                if lobbyNum == self.currLobby && isReady {
                    self.ready=self.ready+1
                    print("yes")
                }
                print(self.ready)
                
                if self.ready >= 2 {
                    self.performSegue(withIdentifier: "start", sender: self)
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
}
