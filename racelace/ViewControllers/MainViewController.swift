//
//  ViewController.swift
//  racelace
//
//  Created by Michael Peng on 6/30/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import TextFieldEffects
import GTProgressBar


class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    var ref: DatabaseReference!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var countDownLabel: UILabel!
    var cdTime = 5
    let locationManager = CLLocationManager()
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var progressBar: GTProgressBar!
    @IBOutlet weak var progressBar2: GTProgressBar!
    @IBOutlet weak var progressBar3: GTProgressBar!
    @IBOutlet weak var progressBar4: GTProgressBar!
    @IBOutlet weak var textField: UITextField!
    var desiredDist: Double = 0
    var startLocation:CLLocation!
    var traveledDistance:Double = 0
    var lastLocation: CLLocation!
    override func viewDidLoad() {
        super.viewDidLoad()
        countDownLabel.isHidden = true
        timerLabel.isHidden = true
        self.textField.delegate = self
        endButton.isHidden = true
        locationManager.delegate = self
        if NSString(string:UIDevice.current.systemVersion).doubleValue > 8 {
            locationManager.requestAlwaysAuthorization()
        }
        print("ooooooooooooga")
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        print("managing")
        progressBar.progress = 0
        progressBar.isHidden = true
        progressBar2.isHidden = true
        progressBar3.isHidden = true
        progressBar4.isHidden = true
        ref = Database.database().reference()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Location managing functions[=---------p
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if (location.horizontalAccuracy > 0) {
            var speed: CLLocationSpeed = CLLocationSpeed()
            speed = locationManager.location!.speed
            print("ooga")
            speedLabel.text = "Speed(m/s): \(speed)"
            print("speed displayed")
            if startLocation == nil {
                startLocation = locations.first
            } else {
                let lastLocation = locations.last as! CLLocation
                distanceLabel.text = String(traveledDistance) 
                if (startLocation.distance(from: lastLocation) > 4) {
                    updateAllProgress()
                    let distance = startLocation.distance(from: lastLocation)
                    startLocation = lastLocation
                    traveledDistance += distance
                }
                print(traveledDistance)
                //progressBar.progress = CGFloat(traveledDistance / desiredDist)
            }
            if (progressBar.isHidden == false) {
                progressBar.progress = CGFloat(traveledDistance / desiredDist)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.denied{
            print("hi")
            
        }
    }
    
    //Timer
    
    var timer = Timer()
    var cdTimer = Timer()
    
    var firstTwo = 0
    var secTwo = 0
    var thirdTwo = 0
    
    @IBAction func startButton(_ sender: Any) {
        cdTime = 5
        locationManager.startUpdatingLocation()
        countDownLabel.isHidden = false
        startButton.isHidden = true
        endButton.isHidden = false
        cdTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.countDown), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func endPressed(_ sender: Any) {
        thirdTwo = 0
        secTwo = 0
        firstTwo = 0
        timerLabel.isHidden = true
        timer.invalidate()
        endButton.isHidden = true
        startButton.isHidden = false
        progressBar.isHidden = true
        progressBar2.isHidden = true
        progressBar3.isHidden = true
        progressBar4.isHidden = true
        progressBar.progress = 0
        traveledDistance = 0
        locationManager.stopUpdatingLocation()
    }
    func startEverything() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.change), userInfo: nil, repeats: true)
        desiredDist = Double(Int(textField.text!)!)
    }
    @objc func countDown() {
        if (cdTime < 0){
            cdTime = 5
            progressBar.isHidden = false
            progressBar2.isHidden = false
            progressBar3.isHidden = false
            progressBar4.isHidden = false
            countDownLabel.isHidden = false
            cdTimer.invalidate()
            startEverything()
            timerLabel.isHidden = false
            traveledDistance = 0
        }
        
        countDownLabel.text = "Starting in .... \(cdTime)"
        cdTime = cdTime - 1
        
    }
    
    
    @objc func change() {
        firstTwo += 1
        if (firstTwo >= 100) {
            secTwo += 1
            firstTwo = 0
            if (secTwo >= 60) {
                thirdTwo += 1
                secTwo = 0
            }
        }
        timerLabel.text = "\(thirdTwo) : \(secTwo) : \(firstTwo)"
    }
    func updateAllProgress(){
        var counter = 1
        ref.child("queuedPlayers").child(Auth.auth().currentUser!.uid).updateChildValues(["Dist" : traveledDistance])
        ref.child("queuedPlayers").observeSingleEvent(of: .value) { snapshot in
            print(snapshot.childrenCount)
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                var points = -1
                guard let value = rest.value as? NSDictionary else {
                    print("No Data!!!")
                    return
                }
                var distance: Double = value["Dist"] as! Double
                if (rest.key != Auth.auth().currentUser!.uid) {
                if (counter == 1) {
                    self.progressBar2.progress = CGFloat(distance / self.desiredDist)
                }
                else if (counter == 2) {
                    self.progressBar3.progress = CGFloat(distance / self.desiredDist)
                }
                else if (counter == 3) {
                    self.progressBar4.progress = CGFloat(distance / self.desiredDist)
                }
                    counter = counter + 1
            }
            }
            
        }
    }
}
