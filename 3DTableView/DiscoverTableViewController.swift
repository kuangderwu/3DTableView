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
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   //     let spinner: UIActivityIndicatorView = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .gray
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinner.startAnimating()
        
        // MARK: Refresh Control init
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: UIControlEvents.valueChanged)
        

        fetchRecordsFromCloud()

    }


    func fetchRecordsFromCloud() {
        let cloudContainer = CKContainer(identifier: "iCloud.com.kdwu.SampleTable")
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        
        query.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name","image"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = { (record) -> Void in
            self.restaurants.append(record)
        }
        
        queryOperation.queryCompletionBlock = { (cursor, error) -> Void in
            if let error = error {
                print("Failed to get data from iCloud - \(error.localizedDescription)")
                //        self.spinner.stopAnimating()
                return
            }
            
            print("Job done --> Operation mode")
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
        
        
        publicDatabase.perform(query, inZoneWith: nil, completionHandler:{ results, error in
            
            if error != nil {
                print("\(error?.localizedDescription)")
                return
            }
            
            if let results = results {
                print("Download completed")
                self.restaurants = results
                OperationQueue.main.addOperation {
                    // MARK: CloudKit 操作型
                    self.spinner.stopAnimating()
                    self.tableView.reloadData()
                    
                    // MARK: Refresh Control endRefreshing()
                    
                    if let refreshControl = self.refreshControl {
                        if refreshControl.isRefreshing {
                            refreshControl.endRefreshing()
                        }
                    }
                }
                
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
                cell.thumbImageView.layer.cornerRadius = 40.0
                cell.thumbImageView.clipsToBounds = true
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
