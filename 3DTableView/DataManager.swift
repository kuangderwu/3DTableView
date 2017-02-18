//
//  DataManager.swift
//  3DTableView
//
//  Created by Wu KD on 2017/2/17.
//  Copyright © 2017年 Kuangder. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    class func fetchObj() -> [RestaurantMO] {
        
        var _restaurants = [RestaurantMO]()
        
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for item in fetchResult {
                _restaurants.append(item)
            }
        } catch {
            print("Fetch Error", error.localizedDescription)
        }
        
        return _restaurants
    }
    
    class func fetchObjWithConditions(condition1: String, condition2: String) -> [RestaurantMO] {
        
        var _restaurants = [RestaurantMO]()
        
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let predicate = NSPredicate(format: condition1, condition2)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for item in fetchResult{
                print("\(item.website)")
                _restaurants.append(item)
            }
        } catch {
            print("Fetch Condition Error", error.localizedDescription)
        }
        
        return _restaurants
        
    }
    
}
