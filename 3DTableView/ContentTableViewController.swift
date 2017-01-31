//
//  ContentTableViewController.swift
//  3DTableView
//
//  Created by Wu KD on 2017/1/22.
//  Copyright © 2017年 Kuangder. All rights reserved.
//

import UIKit
import CoreData

class ContentTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var indexString: String = ""
    
    var restaurants: [RestaurantMO] = []
    
    var fetchedResultController: NSFetchedResultsController<RestaurantMO>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: 19.8 Core Data fetch
        
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
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

    // MARK 19.8 Core Data Fetch NSFetchedResultsControllerDelegate methods! 
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            restaurants = fetchedObjects as! [RestaurantMO]
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContentTableViewCell

        // Configure the cell...
        
        let _restruant = restaurants[indexPath.row]
        
        cell.nameLabel.text = _restruant.name
        cell.thumbnailImageView.image = UIImage(data: _restruant.image as! Data)
        cell.locationLabel.text = _restruant.location
        
        switch _restruant.type {
        case Int16(0): cell.typeLabel.text = "Brunch"
        case Int16(1): cell.typeLabel.text = "Coffee"
        case Int16(2): cell.typeLabel.text = "Desert"
        default: cell.typeLabel.text = "Others"
        }
        
        cell.accessoryType = _restruant.isVisited ? .checkmark : .none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        tableView.deselectRow(at: indexPath, animated: false)
    }


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }


    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let shareAction = UITableViewRowAction(style: .default, title: "Share", handler: {
        
        (action, indexPath) -> Void in
            
            let defaultText = "Just visit this place " + self.restaurants[indexPath.row].name!
            if let shareImage =  UIImage(data: self.restaurants[indexPath.row].image as! Data) {
            
                let activityController = UIActivityViewController(activityItems: [defaultText, shareImage], applicationActivities: nil)
                 self.present(activityController, animated: true, completion: nil)
            }
        })
        
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {
         (action, indexPath) -> Void in
            
        //    self.restaurants.remove(at: indexPath.row)
        //    tableView.deleteRows(at: [indexPath], with: .fade)
        //    tableView.reloadData()
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                
                let context = appDelegate.persistentContainer.viewContext
                let restaurantToDelete = self.fetchedResultController.object(at: indexPath)
                context.delete(restaurantToDelete)
                appDelegate.saveContext()
            }
        })
        
        
        var _title = "Visited!"
        var _checkflag: Bool = false
        
        if restaurants[indexPath.row].isVisited {
            _title = "Not Visited!"
            _checkflag = true
        }
        
        let checkAction = UITableViewRowAction(style: .default, title: _title, handler: {
            
            (action, indexPath) -> Void in
            
            
            let  cell = tableView.cellForRow(at: indexPath)
            if self.restaurants[indexPath.row].isVisited {
                cell?.accessoryType = .none
                _checkflag = false
            } else {
                cell?.accessoryType = .checkmark
                _checkflag = true
            }
            
            self.restaurants[indexPath.row].isVisited = _checkflag
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.saveContext()
            }
            
            tableView.reloadData()
            
        })
        
        
        shareAction.backgroundColor = UIColor(red: 50.0/255.0, green: 170.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 203.0/255.0, blue: 202.0/255.0, alpha: 0.8)
        checkAction.backgroundColor = UIColor(red: 100.0/255.0, green: 60.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        
    //    shareAction.backgroundColor = UIColor.blue
    //    checkAction.backgroundColor = UIColor.orange
        return [deleteAction, shareAction, checkAction]
        
        
    }
    

    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            
             let indexPath = tableView.indexPathForSelectedRow
             let destinationViewController = segue.destination as! DetailViewController
             destinationViewController.restaurant = restaurants[indexPath!.row]
            
        }
        
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        

    }

}
