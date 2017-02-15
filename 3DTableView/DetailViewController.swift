//
//  DetailViewController.swift
//  3DTableView
//
//  Created by Wu KD on 2017/1/23.
//  Copyright © 2017年 Kuangder. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class DetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate  {

    var restaurant: RestaurantMO!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonInfo: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: for retrieve
    
    var fetchedResultController: NSFetchedResultsController<RestaurantMO>!
    var restaurants: [RestaurantMO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(data: restaurant.image as! Data)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = UIColor(red: 10.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        //    tableView.tableFooterView = UIView(frame: CGRect.zero) // mark for map
        tableView.separatorColor = UIColor(red: 10.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        title = restaurant.name
        
        navigationController?.hidesBarsOnSwipe = false
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
     
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location!, completionHandler: {
            
            placemarks, error in
            
            if error != nil {
                print(error!)
                return
            }
            
            if let placemarks = placemarks {
                //get the first placemark
                let _placemark = placemarks[0]
                
                // insert the annotation
                let annotation = MKPointAnnotation()
                
                if let location = _placemark.location{
                    
                    // prepare the info for annotation and add to mapView
                    
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    // set the display range
                    
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        })
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailTableViewCell
        
        switch indexPath.row {
            
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "Type"
            switch restaurant.type {
            case Int16(0): cell.valueLabel.text = "Brunch"
            case Int16(1): cell.valueLabel.text = "Coffee"
            case Int16(2): cell.valueLabel.text = "Desert"
            default: cell.valueLabel.text = "Others"
            }
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurant.phone
        case 4:
            cell.fieldLabel.text = "Website"
            cell.valueLabel.text = restaurant.website
        case 5:
            cell.fieldLabel.text = "Been Here?"
            cell.valueLabel.text = restaurant.isVisited ? "Yes":"No"
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        return cell
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showReview" {
            let destinationViewController = segue.destination as! ReviewViewController
            destinationViewController.restaurant = restaurant
        } else if segue.identifier == "showMap" {
            let destinationViewController = segue.destination as! MapViewController
            destinationViewController.restaurant = restaurant
        }
        
        
    }
    
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func ratingButtonTapped(segue: UIStoryboardSegue){
        
      
        
        if let rating = segue.identifier {
            
            
      
            let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
            let predicate = NSPredicate(format: "name == %@", restaurant.name!)
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
                        print("fetchrequest number = \(restaurants.count)")
                        
                        for item in restaurants {
                            
                            item.isVisited = true
                         
                            switch rating {
                                case "😍":  restaurants[0].rating = " I love it 😍"
                                case "😐":  restaurants[0].rating = " So so ~ 😐"
                                case "😤":  restaurants[0].rating = " Never visit again 😤"
                                default: break
                            }
                            appDelegate.saveContext()
                            
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        tableView.reloadData()
    }
    

    
    func showMap() {
        performSegue(withIdentifier: "showMap", sender: self)
    }

}
