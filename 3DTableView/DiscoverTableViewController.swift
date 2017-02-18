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
import SystemConfiguration
import CoreData

protocol Utilities {
}

extension NSObject:Utilities {
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
}

class DiscoverTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var indexString: String = ""
    var restaurants:[CKRecord] = []
    var imageCache = NSCache<CKRecordID, NSURL>()
    var restaurantsCD: [RestaurantMO] = []
    var fetchedResultController: NSFetchedResultsController<RestaurantMO>!
    var isFirsrLoaded = true
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.activityIndicatorViewStyle = .gray
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinner.startAnimating()
        saveBtn.isEnabled = false
        
        
        // Cell size autolayout
        tableView.estimatedRowHeight = 150.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // MARK: Refresh Control init
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: UIControlEvents.valueChanged)

        // MARK: Check network accessability
        
        if currentReachabilityStatus != .notReachable {
            fetchRecordsFromCloud()
        } else {
            //建立UIAlertController
            let alertcontroller = UIAlertController(title: "Unable to reach iCloud!!", message: "Please check your network connection", preferredStyle: .alert);
            //新增選項
            let alertaction = UIAlertAction(title: "Please Return and Choose others", style: .default , handler:nil);
            // action style .default .cancel .destructive
            alertcontroller.addAction(alertaction);
            self.present(alertcontroller, animated: true, completion: nil);
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if isFirsrLoaded {
            let indexSet = NSIndexSet(index: 0)
            tableView.reloadSections(indexSet as IndexSet, with: .none)
            isFirsrLoaded = false
        }
    }

    func fetchRecordsFromCloud() {
        
        restaurants.removeAll()
        tableView.reloadData()
        let cloudContainer = CKContainer(identifier: "iCloud.com.kdwu.SampleTable")
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        
        query.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = { (record) -> Void in
            self.restaurants.append(record)
        }
        
        queryOperation.queryCompletionBlock = { (cursor, error) -> Void in
            if let error = error {
                print("Failed to get data from iCloud - \(error.localizedDescription)")
                return
            }
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
                self.restaurants = results
                OperationQueue.main.addOperation {
                    // MARK: CloudKit 操作型
                    self.spinner.stopAnimating()
                    self.tableView.reloadData()
                    self.saveBtn.isEnabled = true
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

        let restaurant = restaurants[indexPath.row]
        var locString = "🏠: "
        var phoneString = "☎️: "
        var  webString = "💻: "
        
        cell.nameField.text = restaurant.object(forKey: "name") as? String
        
        if let temploc = restaurant.object(forKey: "location") as? String {
            locString += temploc
        }
        if let tempphone = restaurant.object(forKey: "phone") as? String {
            phoneString += tempphone
        }
        if let tempweb = restaurant.object(forKey: "web") as? String {
            webString += tempweb
        }
        cell.locationField.text = locString
        cell.phoneField.text = phoneString
        cell.webField.text = webString
        cell.thumbImageView.image = UIImage(named: "photoalbum")
        
        
        if let imageFileURL = imageCache.object(forKey: restaurant.recordID) {
            // Mark: get image from cache
            if let imageData = try? Data.init(contentsOf: imageFileURL as URL) {
                cell.thumbImageView?.image = UIImage(data: imageData)
            }
        } else {
            let publicDatabase = CKContainer(identifier: "iCloud.com.kdwu.SampleTable").publicCloudDatabase
            let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
            fetchRecordsImageOperation.desiredKeys = ["image"]
            fetchRecordsImageOperation.queuePriority = .veryHigh
        
            fetchRecordsImageOperation.perRecordCompletionBlock = {
                (record, recordID, error) -> Void in
            
                if let error = error {
                    print("Failed to get restruant image :\(error.localizedDescription)")
                    return
                }
                if let restaurantRecord = record {
                    OperationQueue.main.addOperation() {
                        if let image = restaurantRecord.object(forKey: "image") {
                            let imageAsset = image as! CKAsset
                        
                            if let imageData = try? Data.init(contentsOf: imageAsset.fileURL) {
                                cell.thumbImageView.image = UIImage(data: imageData)
                                cell.thumbImageView.layer.cornerRadius = 10.0
                                cell.thumbImageView.clipsToBounds = true
                            }
                            self.imageCache.setObject(imageAsset.fileURL as NSURL, forKey: restaurant.recordID)
                        }
                    }
                }
            }
            publicDatabase.add(fetchRecordsImageOperation)
        }
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let _restaurant = restaurants[indexPath.row]
        var urlStringtemp : String
        if let urlString = _restaurant.object(forKey: "web") as? String {
            if urlString != "" {
                if !(urlString.hasPrefix("http")) {
                    urlStringtemp = "https://" + urlString
                } else {
                    urlStringtemp = urlString
                }
               let url = URL(string: urlStringtemp)
               let safariController = SFSafariViewController(url: url!)
               present(safariController, animated: true, completion: nil)
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    
    @IBAction func saveToLocal(_ sender: UIBarButtonItem) {
        
        var _restaurant:RestaurantMO
        let nilString = ""
        var nameString:String
        var phoneString: String
        var locationString:String
        var webString:String
        var typeString:String
        for item in restaurants {
            nameString =  item.object(forKey: "name") as! String!

            
            if (isDataExit(name: nameString) == false) {
                phoneString = item.object(forKey: "phone") as! String! ?? nilString
                locationString = item.object(forKey: "location") as! String! ?? nilString
                webString = item.object(forKey: "web") as! String! ?? nilString
                typeString = item.object(forKey: "type") as! String! ?? nilString
                

                
                print("\(nameString),  \(typeString), \(phoneString)")
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    _restaurant = RestaurantMO(context: appDelegate.persistentContainer.viewContext)
                    _restaurant.name = nameString
                    _restaurant.location = locationString
                    _restaurant.phone = phoneString
                    _restaurant.website = webString
                    switch typeString {
                    case "Coffee": _restaurant.type = Int16(1)
                    case "Desert": _restaurant.type = Int16(2)
                    case "Brunch": _restaurant.type = Int16(0)
                    default: _restaurant.type = Int16(3)
                    }
                    
                    if let image = item.object(forKey: "image") {
                        let imageAsset = image as! CKAsset
                        
                        if let imageData = try? Data.init(contentsOf: imageAsset.fileURL) {
                            _restaurant.image = NSData(data: imageData)
                        }
                    }
                    

                    appDelegate.saveContext()
                }
            }
            
        }
        
            

            let alertcontroller = UIAlertController(title: "💾...", message: "iCloud Record saved to yours iPhone", preferredStyle: .alert);

            let alertaction = UIAlertAction(title: "✌️", style: .default , handler:nil);
        
            alertcontroller.addAction(alertaction);
            self.present(alertcontroller, animated: true, completion: nil);
            
        
        
        
        
        
    }
    
    func isDataExit(name:String) -> Bool {
        
        var _result: Bool = false
        var _restaurants = [RestaurantMO]()

        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", name)
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
                    _restaurants = fetchedObjects
                    if _restaurants.count == 0 {
                        _result = false
                    } else {
                        _result = true
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return _result
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    
}
