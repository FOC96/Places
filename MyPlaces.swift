//
//  MyPlaces.swift
//  Places
//
//  Created by Fernando Ortiz Rico Celio on 18/07/17.
//  Copyright © 2017 Fernando Ortiz Rico Celio. All rights reserved.
//

import UIKit

var myPlaces = [Dictionary<String, String>()]
var activePlace = -1


class MyPlaces: UITableViewController {

    @IBOutlet var placesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        design()
        
        //checkCapabilities()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        design()
    }

    override func viewDidAppear(_ animated: Bool) {
        design()
        
        if let tempPlaces = UserDefaults.standard.object(forKey: "myPlaces") as? [Dictionary<String, String>] {
            myPlaces = tempPlaces
        }
        
        if myPlaces.count == 1 && myPlaces[0].count == 0 {
            myPlaces.remove(at: 0)
            myPlaces.append(["name":"Best city ever", "lat":"20.9144", "lon":"-100.7438"])
            UserDefaults.standard.set(myPlaces, forKey: "myPlaces")
        }
        
        activePlace = -1
        placesTable.reloadData()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        design()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myPlaces.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        if myPlaces[indexPath.row]["name"] != nil {
            cell.textLabel?.text = myPlaces[indexPath.row]["name"]
        }
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activePlace = indexPath.row
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func design() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = secondColor
    }
    
    //Not working, probably because this is a UITableViewController subclass. I think a subclass of UIViewController is required.
//    func checkCapabilities() {
//        //3D Touch
//        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
//            registerForPreviewing(with: self, sourceView: view)
//            print("3D Touch available")
//        } else {
//            print("3D Touch unavailable")
//        }
//    }

}

extension ViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let peekView = storyboard?.instantiateViewController(withIdentifier: "detailsViewController")
        return peekView
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        let popView = storyboard?.instantiateViewController(withIdentifier: "detailsViewController")
        show(popView!, sender: self)
    }
    
}
