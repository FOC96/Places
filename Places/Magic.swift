//
//  Magic.swift
//  Places
//
//  Created by Fernando Ortiz Rico Celio on 20/07/17.
//  Copyright © 2017 Fernando Ortiz Rico Celio. All rights reserved.
//

import Foundation
import SystemConfiguration

public class Reachability {
    
    class func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }

    
}


//@IBAction func blueButtonPushed(_ sender: Any) {
//    if screenMode == 0 {
//        //            changeDetails()
//        print("changeDetails()")
//    } else {
//        //            savePlace()
//        print("savePlace()")
//    }
//}
//
//@IBAction func redButtonPushed(_ sender: Any) {
//    if screenMode == 0 {
//        //            deletePlace()
//        print("deletePlace()")
//    } else {
//        //            cancelSave()
//        print("cancelSave()")
//    }
//}
//
//
//
//
//func changeDetails() {
//    if editValue == 0 {
//        editValue = 1
//        self.notesLabel.isUserInteractionEnabled = true
//        self.titleLabel.isUserInteractionEnabled = true
//        self.titleLabel.becomeFirstResponder()
//        self.editPlaceButton.setTitle("Save changes", for: UIControlState.normal)
//    } else {
//        editValue = 0
//        self.notesLabel.isUserInteractionEnabled = false
//        self.titleLabel.isUserInteractionEnabled = false
//        self.editPlaceButton.setTitle("Edit Place", for: UIControlState.normal)
//    }
//}
//
//func deletePlace() {
//    let deleteAlert = UIAlertController(title: "Delete Place", message: "Are you sure you want to proceed?", preferredStyle: .alert)
//    let okAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
//        //DELETE PLACE
//        //            myPlaces.remove(at: activePlace)
//        _ = self.navigationController?.popViewController(animated: true)
//    }
//    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//        //CANCEL
//    }
//    deleteAlert.addAction(okAction)
//    deleteAlert.addAction(cancelAction)
//    self.present(deleteAlert, animated: true, completion: nil)
//}
//
//
//func savePlace() {
//    //        UserDefaults.standard.set(myPlaces, forKey: "myPlaces")
//    _ = self.navigationController?.popViewController(animated: true)
//    let infoAlert = UIAlertController(title: "Saved!", message: "New place added successfully!", preferredStyle: .alert)
//    infoAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//    self.present(infoAlert, animated: true, completion: nil)
//}
//
//func cancelSave() {
//    let cancelAlert = UIAlertController(title: "Cancel", message: "Are you sure you want to proceed?", preferredStyle: .alert)
//    let okAction = UIAlertAction(title: "Continue", style: .destructive) { (action) in
//        //CANCEL SAVING
//        _ = self.navigationController?.popViewController(animated: true)
//    }
//    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//        //STAY HERE
//    }
//    cancelAlert.addAction(okAction)
//    cancelAlert.addAction(cancelAction)
//    self.present(cancelAlert, animated: true, completion: nil)
//    
//}
