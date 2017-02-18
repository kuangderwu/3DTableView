//
//  CoverTableViewController.swift
//  3DTableView
//
//  Created by Wu KD on 2017/1/22.
//  Copyright © 2017年 Kuangder. All rights reserved.
//

import UIKit

class CoverTableViewController: UITableViewController {
    
    var myDictionary = [
        ["name":"Explore", "image":"1","item":"Keep in memory"],
        ["name":"Discover", "image":"2", "item":"Shared by Cloud"],
        ["name":"Coffee", "image":"3", "item":"Place to read & think"],
        ["name":"Desert", "image":"4", "item":"Joy time"],
        ["name":"Brunch", "image":"5", "item":"Health & Energy"]
    ]


    
    override func viewDidLoad() {
        super.viewDidLoad()

        let iconImageView = UIImageView(image: UIImage(named: "burger"))
        self.navigationItem.titleView = iconImageView
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDictionary.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CoverTableViewCell

        // Configure the cell...
        
        let dictionary = myDictionary[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.backgroundImage.image = UIImage(named: dictionary["image"]!)
        cell.NameLabel.text = dictionary["name"]
        cell.itemLabel.text = dictionary["item"]

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var segueID : String = ""
        let index = myDictionary[indexPath.row]["image"]
        if index! == "1" {
            segueID = "contentSegue"
        } else if index! == "2" {
            segueID = "discoverSegue"
        } else {
            segueID = "infoSegue"
        }
        performSegue(withIdentifier: segueID, sender: myDictionary[indexPath.row]["name"])
        tableView.deselectRow(at: indexPath, animated: false)
    }
    

    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let sendString = sender as! String
        print("\(sendString)")
        switch sendString {
            case "Explore":
                let contentview = segue.destination as! ContentTableViewController
                contentview.indexString = sendString
            case "Discover":
                let contentview = segue.destination as! DiscoverTableViewController
                contentview.indexString = sendString
            default:
                let contentview = segue.destination as! InfoTableViewController
                contentview.indexString = sendString

        }


    }


}
