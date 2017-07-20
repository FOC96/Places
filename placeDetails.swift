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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = myPlaces[activePlace]["name"] {
            titleLabel.text = name
            if let latitude = myPlaces[activePlace]["lat"] {
                if let longitude = myPlaces[activePlace]["lon"] {
                    if let lat = Double(latitude) {
                        if let lon = Double(longitude) {
                            let location = CLLocationCoordinate2DMake(lat, lon)
                            let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
                            let region = MKCoordinateRegion(center: location, span: span)
                            
                            self.detailMap.setRegion(region, animated: true)
                            self.detailMap.setCenter(location, animated: true)
                        }
                    }
                }
            }
        }
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

}
