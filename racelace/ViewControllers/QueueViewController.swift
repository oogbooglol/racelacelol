//
//  QueueViewController.swift
//  racelace
//
//  Created by Michael Peng on 7/10/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class CustomTableViewCell: UITableViewCell {
    
    var points = 0
    var ref: DatabaseReference!
    var lobbyNum: Int = 0
    @IBOutlet weak var Label: UILabel!
}

class QueueViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var bef: DatabaseReference!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bef = Database.database().reference()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "cell", bundle: nil) , forCellReuseIdentifier: "custom")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell : CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "custom") as! CustomTableViewCell
        print("ooga")
        bef.child("queuedPlayers").child(Auth.auth().currentUser!.uid).updateChildValues(["Lobby": indexPath.row+1])
        print("GOOOOOGOGOGOOGGOGOGOGOGOGGOGOGOGGOGOGG")
        self.performSegue(withIdentifier: "toReadyScreen", sender: self)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "custom") as! CustomTableViewCell
        cell.lobbyNum = indexPath.row+1
        cell.Label.text = "Lobby \(cell.lobbyNum)"
        cell.ref = bef
        return cell
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
