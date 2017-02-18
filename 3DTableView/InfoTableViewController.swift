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
    var restaurants: [RestaurantMO]!
    
    var _results = [RestaurantMO]()
    var fetchedResultController: NSFetchedResultsController<RestaurantMO>!
    var isSearched: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        var _critia : Int16
        
        switch indexString {
        case "Brunch": _critia = Int16(0)
        case "Coffee": _critia = Int16(1)
        case "Desert": _critia = Int16(2)
        default: _critia = Int16(3)

        }

        print("cirtia: \(_critia)")
        restaurants = DataManager.fetchObj()
        
        for item in restaurants {
            if item.type ==  _critia {
                _results.append(item)
            }
        }
        print(_results.count)
  
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return _results.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InfoTableViewCell

        // Configure the cell...
        
        let _restaurant = _results[indexPath.row]
        
        if _restaurant.rating == nil {
            _restaurant.rating = "   "
        }
        
        
        cell.nameField.text = _restaurant.name! + "     " +  _restaurant.rating!
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
        
        let _restautant = _results[indexPath.row]
        
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
    
    


}
