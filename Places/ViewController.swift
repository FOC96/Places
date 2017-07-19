//
//  ViewController.swift
//  Places
//
//  Created by Fernando Ortiz Rico Celio on 18/07/17.
//  Copyright © 2017 Fernando Ortiz Rico Celio. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    
    let manager = CLLocationManager()
    @IBOutlet weak var mainMap: MKMapView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var catalogButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var gradLayer: UIView!
    
    
    //Colors
    let mainColor = UIColor(red:0.000000, green:0.796078, blue:0.756863, alpha:1.0).cgColor
    let secondColor = UIColor(red:0.043137, green:0.701961, blue:0.886275, alpha:1.0).cgColor
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
        checkPast()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    func design() {
        self.navigationController?.navigationBar.isHidden = true
        
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.cornerRadius = 8
        saveButton.layer.shadowOffset = CGSize.zero
        saveButton.layer.shadowOpacity = 0.15
        saveButton.layer.shadowRadius = 10
        saveButton.layer.backgroundColor = mainColor
        saveButton.layer.shouldRasterize = false
        
        mainMap.layer.cornerRadius = 12
        mainMap.layer.masksToBounds = true
        
        settingsButton.layer.shadowColor = UIColor.black.cgColor
        settingsButton.layer.shadowOffset = CGSize.zero
        settingsButton.layer.shadowOpacity = 0.6
        settingsButton.layer.shadowRadius = 2
        
        locationButton.layer.shadowColor = UIColor.black.cgColor
        locationButton.layer.shadowOffset = CGSize.zero
        locationButton.layer.shadowOpacity = 0.6
        locationButton.layer.shadowRadius = 2
        
        locationLabel.layer.shadowColor = UIColor.black.cgColor
        locationLabel.layer.shadowOffset = CGSize.zero
        locationLabel.layer.shadowOpacity = 0.9
        locationLabel.layer.shadowRadius = 6
        
        catalogButton.layer.shadowColor = UIColor.black.cgColor
        catalogButton.layer.cornerRadius = 8
        catalogButton.layer.shadowOffset = CGSize.zero
        catalogButton.layer.shadowOpacity = 0.15
        catalogButton.layer.shadowRadius = 10
        catalogButton.layer.backgroundColor = secondColor
        catalogButton.layer.shouldRasterize = false
        
        let gradient = CAGradientLayer()
        let color1 = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3).cgColor
        let color2 = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0).cgColor
        gradient.colors = [color1, color2]
        gradient.frame = gradLayer.bounds
        view.layer.addSublayer(gradient)
    }
    
    
    // User location (system func)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.mainMap.isZoomEnabled = true
//        self.mainMap.setCenter(location, animated: true)
        
        self.mainMap.setRegion(region, animated: true)
    }
    
    
    
    // Checks past setups by user
    func checkPast() {
        // Location setup
        if let status : Int = UserDefaults.standard.object(forKey: "locationStatus") as? Int {
            if status == 1 {
                locationButton.setImage(#imageLiteral(resourceName: "locationOn"), for: .normal)
                self.locateUser()
            } else {
                locationButton.setImage(#imageLiteral(resourceName: "locationOff"), for: .normal)
            }
        } else {
            UserDefaults.standard.set(0, forKey: "locationStatus")
            locationButton.setImage(#imageLiteral(resourceName: "locationOff"), for: .normal)
        }
    }
    
    
    // Location button's been tapped
    @IBAction func locationTapped() {
        if let status : Int = UserDefaults.standard.object(forKey: "locationStatus") as? Int {
            if status == 1 {
                print("LOCATION OFF")
                UserDefaults.standard.set(0, forKey: "locationStatus")
                locationButton.setImage(#imageLiteral(resourceName: "locationOff"), for: .normal)
                self.manager.stopUpdatingLocation()
            } else {
                print("Location ON")
                UserDefaults.standard.set(1, forKey: "locationStatus")
                locationButton.setImage(#imageLiteral(resourceName: "locationOn"), for: .normal)
                locateUser()
            }
        } else {
            UserDefaults.standard.set(1, forKey: "locationStatus")
            locationButton.setImage(#imageLiteral(resourceName: "locationOn"), for: .normal)
            locateUser()
            print("variable created: on")
        }
    }
    
    
    // Gets user's location and shows on map
    func locateUser() {
        print("USER LOCATED")
        manager.startUpdatingLocation()
        
    }
    
    
    // Information alert
    func infoAlert(title : String) {
        let infoBoom = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("OK")
        }
        infoBoom.addAction(okAction)
        self.present(infoBoom, animated: true, completion: nil)
    }
    
    
    @IBAction func showTaa() {
//        performSegue(withIdentifier: "Hola", sender: nil)
    }
    
    
    
    
}

