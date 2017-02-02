//
//  DiscoverTableViewController.swift
//  3DTableView
//
//  Created by Wu KD on 2017/2/2.
//  Copyright © 2017年 Kuangder. All rights reserved.
//

import UIKit
import CloudKit
import SafariServices

class DiscoverTableViewController: UITableViewController {

    
    var indexString: String = ""
    var restaurants:[CKRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchRecordsFromCloud()

    }


    func fetchRecordsFromCloud() {
        let cloudContainer = CKContainer(identifier: "iCloud.com.kdwu.SampleTable")
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        publicDatabase.perform(query, inZoneWith: nil, completionHandler: {
            (results, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            if let _results = results {
                self.restaurants = _results
                print(self.restaurants.count)
                self.tableView.reloadData()
            }
        })
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DiscoverTableViewCell

        let _restaurant = restaurants[indexPath.row]
        
        var locString = "🏠: "
        var phoneString = "☎️: "
        var  webString = "💻: "
        
        
        cell.nameField.text = _restaurant.object(forKey: "name") as? String
        
        locString += (_restaurant.object(forKey: "location") as? String)!
        phoneString += (_restaurant.object(forKey: "phone") as? String)!
        webString += (_restaurant.object(forKey: "web") as? String )!
        cell.locationField.text = locString
        cell.phoneField.text = phoneString
        cell.webField.text = webString
       
        
        if let image = _restaurant.object(forKey: "image") {
            let imageAsset = image as! CKAsset
        
            if let imageData = try? Data.init(contentsOf: imageAsset.fileURL) {
                cell.thumbImageView.image = UIImage(data: imageData)
            }
        }
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
 
        let _restaurant = restaurants[indexPath.row]

        let urlString = _restaurant.object(forKey: "web") as? String
        let url = URL(string: urlString!)
        let safariController = SFSafariViewController(url: url!)
        present(safariController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
