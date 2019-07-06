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
        
        self.textField.delegate = self
        
        locationManager.delegate = self
        if NSString(string:UIDevice.current.systemVersion).doubleValue > 8 {
            locationManager.requestAlwaysAuthorization()
        }
        print("ooooooooooooga")
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        print("managing")
        progressBar.progress = 0
        progressBar.displayLabel = true
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
                startLocation = lastLocation
                traveledDistance += distance
                print(traveledDistance)
                progressBar.progress = CGFloat(traveledDistance / desiredDist)
                distanceLabel.text = String(traveledDistance)
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
    
    var firstTwo = 0
    var secTwo = 0
    var thirdTwo = 0
    
    @IBAction func startButton(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.change), userInfo: nil, repeats: true)
        desiredDist = Double(Int(textField.text!)!)
        locationManager.startUpdatingLocation()
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
