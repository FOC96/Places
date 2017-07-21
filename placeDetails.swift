//
//  placeDetails.swift
//  Places
//
//  Created by Fernando Ortiz Rico Celio on 20/07/17.
//  Copyright © 2017 Fernando Ortiz Rico Celio. All rights reserved.
//

import UIKit
import MapKit

class placeDetails: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var detailMap: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDetails()
        design()
}
    
    func design() {
        detailMap.layer.cornerRadius = 8
        detailMap.layer.masksToBounds = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showDetails() {
        //Labels
        if let name = myPlaces[activePlace]["name"] {
            titleLabel.text = name
            titleLabel.textColor = UIColor.black
        } else {
            titleLabel.text = "Unknown title"
            titleLabel.textColor = UIColor.lightGray
        }
        
        if let date = myPlaces[activePlace]["date"] {
            dateLabel.text = date
            dateLabel.textColor = UIColor.gray
        } else {
            dateLabel.text = "Unknown date"
            dateLabel.textColor = UIColor.lightGray
        }
        
        if let notes = myPlaces[activePlace]["notes"] {
            notesLabel.text = notes
            notesLabel.textColor = UIColor.black
        } else {
            notesLabel.text = "There are currently no notes for this place."
            notesLabel.textColor = UIColor.lightGray
        }
        
        
        if let latitude = myPlaces[activePlace]["lat"] {
            if let longitude = myPlaces[activePlace]["lon"] {
                if let lat = Double(latitude) {
                    if let lon = Double(longitude) {
                        let location = CLLocationCoordinate2DMake(lat, lon)
                        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
                        let region = MKCoordinateRegion(center: location, span: span)
                        
                        self.detailMap.setRegion(region, animated: true)
                        self.detailMap.setCenter(location, animated: true)
                        
                        
                        let loc = CLLocation(latitude: lat, longitude: lon)
                        // Address finder
                        CLGeocoder().reverseGeocodeLocation(loc) { (placemarks, error) in
                            if error != nil {
                                print(error as Any)
                            } else {
                                if let placemark = placemarks?[0] {
                                    var address = ""
                                    
                                    if placemark.subThoroughfare != nil {
                                        address = placemark.subThoroughfare!
                                        print(placemark.subThoroughfare!)
                                    }
                                    if placemark.thoroughfare != nil {
                                        address += " " + placemark.thoroughfare!
                                        print(placemark.thoroughfare!)
                                    }
                                    if placemark.locality != nil {
                                        address += "\n" + placemark.locality!
                                        print(placemark.locality!)
                                    }
                                    if placemark.postalCode != nil {
                                        address += ", " + placemark.postalCode!
                                        print(placemark.postalCode!)
                                    }
                                    if placemark.subAdministrativeArea != nil {
                                        address += "\n" + placemark.subAdministrativeArea!
                                        print(placemark.subAdministrativeArea!)
                                    }
                                    if placemark.administrativeArea != nil {
                                        address += ", " + placemark.administrativeArea!
                                        print(placemark.administrativeArea!)
                                    }
                                    if placemark.country != nil {
                                        address += ", " + placemark.country!
                                        print(placemark.country!)
                                    }
                                    
                                    self.addressLabel.text = address
                                    self.addressLabel.textColor = UIColor.black
                                } else {
                                    self.addressLabel.text = "No address information available"
                                    self.addressLabel.textColor = UIColor.lightGray
                                }
                            }// Info gotten from reverseGeoLocation
                        }// CLGeocoder ended

                        
                    }
                }
            }
        }

    }

}
