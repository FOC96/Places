//
//  placeDetails.swift
//  Places
//
//  Created by Fernando Ortiz Rico Celio on 20/07/17.
//  Copyright © 2017 Fernando Ortiz Rico Celio. All rights reserved.
//

import UIKit
import MapKit

var screenMode = 0
// 0 = existent place
// 1 = new place

class placeDetails: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var detailMap: MKMapView!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UITextView!
    @IBOutlet weak var notesLabel: UITextView!
    @IBOutlet weak var editPlaceButton: UIButton!
    @IBOutlet weak var deletePlaceButton: UIButton!
    @IBOutlet weak var scrollContainer: UIScrollView!
    @IBOutlet weak var nameContainer: UIVisualEffectView!
    
    var editValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(screenMode)
        if screenMode == 0 {
            editPlaceButton.setTitle("Edit Place", for: .normal)
            deletePlaceButton.setTitle("Delete Place", for: .normal)
            editValue = 0
        } else  {
            editPlaceButton.setTitle("Save", for: .normal)
            deletePlaceButton.setTitle("Cancel", for: .normal)
            editValue = 0
            changeDetails()
        }
        showDetails()
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
            titleLabel.placeholder = "Unknown title"
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
                                    }
                                    if placemark.thoroughfare != nil {
                                        address += " " + placemark.thoroughfare!
                                    }
                                    if placemark.locality != nil {
                                        address += "\n" + placemark.locality!
                                    }
                                    if placemark.postalCode != nil {
                                        address += ", " + placemark.postalCode!
                                    }
                                    if placemark.subAdministrativeArea != nil {
                                        address += "\n" + placemark.subAdministrativeArea!
                                    }
                                    if placemark.administrativeArea != nil {
                                        address += ", " + placemark.administrativeArea!
                                    }
                                    if placemark.country != nil {
                                        address += ", " + placemark.country!
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
    } // func ended
    
    
    @IBAction func bluePushed(_ sender: Any) {
        if screenMode == 0 {
            changeDetails()
        } else {
            savePlace()
        }
    }

    @IBAction func redPushed(_ sender: Any) {
        if screenMode == 0 {
            deletePlace()
        } else {
            cancelSave()
        }
    }
    
    
    func changeDetails() {
        if editValue == 0 {
            self.notesLabel.isUserInteractionEnabled = true
            self.titleLabel.isUserInteractionEnabled = true
            self.titleLabel.becomeFirstResponder()
            self.editPlaceButton.setTitle("Save changes", for: UIControlState.normal)
            editValue = 1
        } else {
            self.notesLabel.isUserInteractionEnabled = false
            self.titleLabel.isUserInteractionEnabled = false
            self.editPlaceButton.setTitle("Edit Place", for: UIControlState.normal)
            editValue = 0
        }
    }
    
    func deletePlace() {
        let deleteAlert = UIAlertController(title: "Delete Place", message: "Are you sure you want to proceed?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            //DELETE PLACE
            //            myPlaces.remove(at: activePlace)
            _ = self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //CANCEL
        }
        deleteAlert.addAction(okAction)
        deleteAlert.addAction(cancelAction)
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    
    func savePlace() {
        var thisPlace = myPlaces.last
        thisPlace?["name"] = titleLabel.text
        thisPlace?["notes"] = notesLabel.text
        myPlaces.remove(at: myPlaces.count-1)
        myPlaces.append(thisPlace!)
        UserDefaults.standard.set(myPlaces, forKey: "myPlaces")
        _ = self.navigationController?.popViewController(animated: true)
        let infoAlert = UIAlertController(title: "Saved!", message: "New place added successfully!", preferredStyle: .alert)
        infoAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(infoAlert, animated: true, completion: nil)
    }
    
    func cancelSave() {
        let cancelAlert = UIAlertController(title: "Cancel", message: "Are you sure you want to proceed?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Continue", style: .destructive) { (action) in
            //CANCEL SAVING
            _ = self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //STAY HERE
        }
        cancelAlert.addAction(okAction)
        cancelAlert.addAction(cancelAction)
        self.present(cancelAlert, animated: true, completion: nil)
        
    }
    
    

}
