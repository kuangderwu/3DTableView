//
//  AddRestaurantTableViewController.swift
//  3DTableView
//
//  Created by Wu KD on 2017/1/28.
//  Copyright © 2017年 Kuangder. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class AddRestaurantTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var webTextField: UITextField!
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var restaurant : RestaurantMO!
    
    var typeIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.locationTextField.delegate = self
        self.webTextField.delegate = self
        self.phoneTextField.delegate = self

    }
    
    // MARK: Make keyboard disappear 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        
        // MARK: 18.5
        
        let leadingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        
        let topConstraint = NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        
        let bottomConstraint = NSLayoutConstraint(item: photoImageView, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func isContentCompleted (restaurant: RestaurantMO) -> Bool {
        var _result = true
        
        if restaurant.name == nil || restaurant.location == nil || restaurant.website == nil || restaurant.image == nil {
             _result = false
        }
        return _result
        
    }
    
    func saveRecordToCloud(restaurant: RestaurantMO) -> Void {
        
        
        let record = CKRecord(recordType: "Restaurant")
        record.setValue(restaurant.name, forKey: "name")
        var _type = ""
        switch restaurant.type {
        case Int16(0): _type = "Brunch"
        case Int16(1): _type = "Coffee"
        case Int16(2): _type = "Desert"
        case Int16(3): _type = "Others"
        default: _type = "Others"
        }
        record.setValue(_type, forKey: "type")
        record.setValue(restaurant.location, forKey: "location")
        record.setValue(restaurant.phone, forKey: "phone")
        record.setValue(restaurant.website, forKey: "web")
        let imageData = restaurant.image as! Data
        
        let originalImage = UIImage(data: imageData)!
        let scalingFactor = (originalImage.size.width > 1024) ? 1024/originalImage.size.width: 1.0
        let scaledImage = UIImage(data: imageData, scale: scalingFactor)!
        
        let imageFilePath = NSTemporaryDirectory() + restaurant.name!
        let imageFileURL = URL(fileURLWithPath: imageFilePath)
        try? UIImageJPEGRepresentation(scaledImage, 0.8)?.write(to: imageFileURL)
        
        let imageAsset = CKAsset(fileURL: imageFileURL)
        record.setValue(imageAsset, forKey: "image")
 
        
        let publicDatabase = CKContainer(identifier: "iCloud.com.kdwu.SampleTable").publicCloudDatabase
        publicDatabase.save(record, completionHandler: {
            (record, error) -> Void in
            try? FileManager.default.removeItem(at: imageFileURL)
        })
        
    }

    @IBAction func save(_ sender: Any) {
        if nameTextField.text == "" || locationTextField.text == "" {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        
    //    print(restaurant)
        
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            restaurant = RestaurantMO(context: appDelegate.persistentContainer.viewContext)
            restaurant.name = nameTextField.text
            switch typeSegmentControl.selectedSegmentIndex {
            case 0: restaurant?.type = Int16(0)
            case 1: restaurant?.type = Int16(1)
            case 2: restaurant?.type = Int16(2)
            case 3: restaurant?.type = Int16(3)
            default: break
            }
            restaurant.location = locationTextField.text!
            restaurant.website = webTextField.text!
            restaurant.phone = phoneTextField.text!
            
        
            if let restaurantImage = photoImageView.image {
                if let imageData = UIImagePNGRepresentation(restaurantImage) {
                    
                    restaurant.image = NSData(data: imageData)
                }
            }
        
            appDelegate.saveContext()
            if isContentCompleted(restaurant: restaurant) {
              saveRecordToCloud(restaurant: restaurant)
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
 
    
    @IBAction func typeSegmentControl(_ sender: UISegmentedControl) {
        
//        print("\(typeSegmentControl.selectedSegmentIndex)")

    }

}
