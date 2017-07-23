//
//  ViewController.swift
//  Places
//
//  Created by Fernando Ortiz Rico Celio on 18/07/17.
//  Copyright © 2017 Fernando Ortiz Rico Celio. All rights reserved.
//

import UIKit
import MapKit


//Colors
let mainColor = UIColor(red:0.000000, green:0.796078, blue:0.756863, alpha:1.0)
let secondColor = UIColor(red:0.043137, green:0.701961, blue:0.886275, alpha:1.0)


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    func checkConnection() {
        if Reachability.isInternetAvailable() != true {
            let alertController = UIAlertController (title: "Turn Off Airplane Mode or Use Wi-Fi to Access Data", message: nil, preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        // Nothing here
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    let manager = CLLocationManager()
    @IBOutlet weak var mainMap: MKMapView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var catalogButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var gradLayer: UIView!
    
    var userLat = 0.0
    var userLon = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
        checkPast()
        checkConnection()
        
        //Tap on label
        let tapLocationName = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.changeLocTitle(gestureRecognizer:)))
        tapLocationName.minimumPressDuration = 1
        settingsButton.addGestureRecognizer(tapLocationName)
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        locateUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        mainMap.layer.cornerRadius = 12
        mainMap.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
        mainMap.layer.cornerRadius = 12
        mainMap.layer.masksToBounds = true
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
        saveButton.layer.backgroundColor = mainColor.cgColor
        saveButton.layer.shouldRasterize = false
        
        mainMap.layer.cornerRadius = 12
        mainMap.layer.masksToBounds = true
        
        settingsButton.layer.shadowColor = UIColor.black.cgColor
        settingsButton.layer.shadowOffset = CGSize.zero
        settingsButton.layer.shadowOpacity = 0.6
        settingsButton.layer.shadowRadius = 2
        
        locationLabel.layer.shadowColor = UIColor.black.cgColor
        locationLabel.layer.shadowOffset = CGSize.zero
        locationLabel.layer.shadowOpacity = 0.6
        locationLabel.layer.shadowRadius = 2
        
        locationButton.layer.shadowColor = UIColor.black.cgColor
        locationButton.layer.shadowOffset = CGSize.zero
        locationButton.layer.shadowOpacity = 0.6
        locationButton.layer.shadowRadius = 2
        
        catalogButton.layer.shadowColor = UIColor.black.cgColor
        catalogButton.layer.cornerRadius = 8
        catalogButton.layer.shadowOffset = CGSize.zero
        catalogButton.layer.shadowOpacity = 0.15
        catalogButton.layer.shadowRadius = 10
        catalogButton.layer.backgroundColor = secondColor.cgColor
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
        
        let place = locations[0]
        //it could be locations.last as well
        
        let mylocation = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: mylocation, span: span)
        
        userLat = mylocation.latitude
        userLon = mylocation.longitude
        
        self.mainMap.isZoomEnabled = true
//        self.mainMap.setCenter(location, animated: true)
        
        self.mainMap.setRegion(region, animated: true)
        
        
        // Address finder
        CLGeocoder().reverseGeocodeLocation(place) { (placemarks, error) in
            if error != nil {
                print(error as Any)
            } else {
                if let placemark = placemarks?[0] {
                    var address = ""
                    
                    if placemark.subAdministrativeArea != nil {
                        address = placemark.subAdministrativeArea!
                    }
                    if placemark.administrativeArea != nil {
                        address += ", " + placemark.administrativeArea!
                    }
                    
                    self.locationLabel.text = address
                }
            }// Info gotten from reverseGeoLocation
        }// CLGeocoder ended
        
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
            UserDefaults.standard.set(1, forKey: "locationStatus")
            locationButton.setImage(#imageLiteral(resourceName: "locationOn"), for: .normal)
        }
    }
    
    
    // Location button's been tapped
    @IBAction func locationTapped() {
        if let status : Int = UserDefaults.standard.object(forKey: "locationStatus") as? Int {
            if status == 1 {
                UserDefaults.standard.set(0, forKey: "locationStatus")
                locationButton.setImage(#imageLiteral(resourceName: "locationOff"), for: .normal)
                self.manager.stopUpdatingLocation()
            } else {
                UserDefaults.standard.set(1, forKey: "locationStatus")
                locationButton.setImage(#imageLiteral(resourceName: "locationOn"), for: .normal)
                locateUser()
            }
        } else {
            UserDefaults.standard.set(1, forKey: "locationStatus")
            locationButton.setImage(#imageLiteral(resourceName: "locationOn"), for: .normal)
            locateUser()
        }
    }
    
    
    // Gets user's location and shows on map
    func locateUser() {
        manager.startUpdatingLocation()
        
    }
    
    
    // Information alert
    func infoAlert(title : String) {
        let infoBoom = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        infoBoom.addAction(okAction)
        self.present(infoBoom, animated: true, completion: nil)
    }
    
    
    func changeLocTitle(gestureRecognizer : UITapGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            let alerta = UIAlertController(title: "HOLA", message: "presionaste sobre el location label", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alerta.addAction(okAction)
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func saveButtonPushed(_ sender: Any) {
        screenMode = 1
        print(screenMode)
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        let today = "\(String(describing: month)) \(String(describing: day)), \(String(describing: year))"
        
        myPlaces.append(["name":"Unknown name", "lat":"\(userLat)", "lon":"\(userLon)", "date":"\(today)"])
        activePlace = myPlaces.count - 1
    }
    
    
    
    
    
}
