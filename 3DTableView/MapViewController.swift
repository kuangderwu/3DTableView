//
//  MapViewController.swift
//  3DTableView
//
//  Created by Wu KD on 2017/1/25.
//  Copyright © 2017年 Kuangder. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
 
    var restaurant : Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.delegate = self
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location, completionHandler: {
            
            placemarks, error in
            
            if error != nil {
                print(error!)
                return
            }
            
            if let _placemarks = placemarks {
                
                let _placemark = _placemarks[0]
                
                let annotation = MKPointAnnotation()
                var _subtitle = ""
                annotation.title = self.restaurant.name
                switch self.restaurant.type {
                case .brunch: _subtitle = "Brunch"
                case .coffee: _subtitle = "Coffee"
                case .desert: _subtitle = "Desert"
                default: _subtitle = "Others"
                }
                
                annotation.subtitle = _subtitle
                
                if let _location = _placemark.location {
                    
                    annotation.coordinate = _location.coordinate
                    
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
                
            }
            
        })
        
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    // MARK: MapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "FoodPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView : MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect.init(x:0, y:0, width:53, height:53))
   //     leftIconView.image = UIImage(data: _restaurant!.image as! Data)
        leftIconView.image = UIImage(named: restaurant.image)
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        annotationView?.pinTintColor = UIColor.green
        
        return annotationView
        
    }


}
