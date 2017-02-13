//
//  ContentTableViewController.swift
//  3DTableView
//
//  Created by Wu KD on 2017/1/22.
//  Copyright © 2017年 Kuangder. All rights reserved.
//

import UIKit
import CoreData

class ContentTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UIViewControllerPreviewingDelegate {
    
    var indexString: String = ""
    
    var restaurants: [RestaurantMO] = []
    
    var fetchedResultController: NSFetchedResultsController<RestaurantMO>!

    var searchController : UISearchController!
    var searchResults: [RestaurantMO] = []
    var isSearching: Bool = false
    
    let searchBar : UISearchBar? = nil
    
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
        
        
        // MARK: 20.4 Update Search Controller
        setupSearchBar()
        
        
        // MARK: 3D Touch Peek & Pop
        
        
        if (traitCollection.forceTouchCapability == .available) {
            registerForPreviewing(with: self as UIViewControllerPreviewingDelegate, sourceView: view)
        }
        
    }
    
    func setupSearchBar() {
        
        let searchBar = UISearchBar(frame: CGRect(x:0,y:0,width:(UIScreen.main.bounds.width),height:60))
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search restaurants by name"
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor(red: 218.0/255.0, green: 100.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar?.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
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

        if isSearching {
            return searchResults.count
        } else {
            return restaurants.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContentTableViewCell

        // Configure the cell...
        
        let _restruant = (isSearching) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        
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


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isSearching {
            return false
        } else {
            return true
        }
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
        
   /*
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
     */
        
        shareAction.backgroundColor = UIColor(red: 50.0/255.0, green: 170.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 203.0/255.0, blue: 202.0/255.0, alpha: 0.8)
   //     checkAction.backgroundColor = UIColor(red: 100.0/255.0, green: 60.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        
    //    shareAction.backgroundColor = UIColor.blue
    //    checkAction.backgroundColor = UIColor.orange
        return [deleteAction, shareAction]
        
        
    }
    

    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            
             let indexPath = tableView.indexPathForSelectedRow
             let destinationViewController = segue.destination as! DetailViewController
             destinationViewController.restaurant = (isSearching) ? searchResults[indexPath!.row] : restaurants[indexPath!.row]
        }
        
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        

    }

    // MARK: 20.3 Search filter
    
    func filterContent(for searchText: String) {
        
        searchResults = restaurants.filter({ (restaurant) -> Bool in
                return (restaurant.name?.localizedCaseInsensitiveContains(searchText))!
        })
        self.tableView.reloadData()
    
    }
    
    // MARK: 20.4 Update Search Result
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            self.tableView.reloadData()
        } else {
            filterTableView(text: searchText)
        }
        
    }
    
    
    func filterTableView(text: String) {
        isSearching = true
        searchResults = restaurants.filter({ (restruant) -> Bool in
                return (restruant.name?.localizedCaseInsensitiveContains(text))!
        })
        self.tableView.reloadData()
    }

    
    // MARK: 3D Touch Peek & Pop , Preview
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return nil
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return nil
        }
        
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as?
            DetailViewController else {
            return nil
        }
        
        let selectedRestaurant = restaurants[indexPath.row]
        detailViewController.restaurant = selectedRestaurant
        detailViewController.preferredContentSize = CGSize(width: 0.0, height: 450.0)
        previewingContext.sourceRect = cell.frame
        
        return detailViewController
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    
}
