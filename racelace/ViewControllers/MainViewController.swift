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
    
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var countDownLabel: UILabel!
    var cdTime = 5
    let locationManager = CLLocationManager()
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var progressBar: GTProgressBar!
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
                let distance = startLocation.distance(from: lastLocation)
                if distance > 4 {
                    startLocation = lastLocation
                }
                traveledDistance += distance
                print(traveledDistance)
                //progressBar.progress = CGFloat(traveledDistance / desiredDist)
                distanceLabel.text = String(traveledDistance)
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
        progressBar.progress = 0
        progressBar.isHidden = true
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
            countDownLabel.isHidden = true
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
    
}
