//
//  InfoTableViewController.swift
//  3DTableView
//
//  Created by Wu KD on 2017/1/22.
//  Copyright © 2017年 Kuangder. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class InfoTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var indexString: String = ""
    var restaurants: [RestaurantMO] = []
    
    var fetchedResultController: NSFetchedResultsController<RestaurantMO>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        
        var _critia : Int16
        
        switch indexString {
        case "Brunch": _critia = Int16(0)
        case "Coffee": _critia = Int16(1)
        case "Desert": _critia = Int16(2)
        default: _critia = Int16(3)

        }
        
        let predicate = NSPredicate(format: "type == %@", String(_critia))
        
        
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key:"name", ascending:true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultController.delegate = self
            
            do {
                try fetchedResultController.performFetch()
                if let fetchedObjects = fetchedResultController.fetchedObjects {
                    restaurants = fetchedObjects
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        

    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InfoTableViewCell

        // Configure the cell...
        
        let _restaurant = restaurants[indexPath.row]
        
        cell.nameField.text = _restaurant.name
        cell.locationField.text = _restaurant.location
        cell.phoneField.text = _restaurant.phone
        cell.webField.text = _restaurant.website
        
        cell.thumbImageView.image = UIImage(data: _restaurant.image as! Data)
        cell.thumbImageView.layer.cornerRadius = 40.0
        cell.thumbImageView.clipsToBounds = true
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var urlString: String
        
        let _restautant = restaurants[indexPath.row]
        
        if _restautant.website != "" {
            if !(_restautant.website?.hasPrefix("http"))! {
                urlString = "https://"+_restautant.website!
            } else {
                urlString = _restautant.website!
            }
            
            let url = URL(string: urlString)
            let safariController = SFSafariViewController(url: url!)
            present(safariController, animated: true, completion: nil)
        } else {
            urlString = "https://www.google.com.tw"
            let url = URL(string: urlString)
            let safariController = SFSafariViewController(url: url!)
            present(safariController, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return false
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

}
