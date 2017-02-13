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
    
    func rotateCameraImageToProperOrientation(imageSource : UIImage, maxResolution : CGFloat) -> UIImage {
        let imgRef = imageSource.cgImage
        
        let width = CGFloat(imgRef!.width)
        let height = CGFloat(imgRef!.height)
        
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        var scaleRatio : CGFloat = 1
        if width > maxResolution || height > maxResolution {
            
            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }
        
        var transform = CGAffineTransform.identity
        let orient = imageSource.imageOrientation
        let imageSize = CGSize(width: imgRef!.width, height: imgRef!.height)
        
        switch imageSource.imageOrientation {
        case .up :
            transform = CGAffineTransform.identity
            
        case .upMirrored :
            transform = CGAffineTransform(translationX: imageSize.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .down :
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height)
            transform = transform.rotated(by: CGFloat.pi)
            
        case .downMirrored :
            transform = CGAffineTransform(translationX: 0, y: imageSize.height)
            transform = transform.scaledBy(x: 1, y: -1)
            
        case .left :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: 0, y: imageSize.width)
            transform = transform.rotated(by: 3.0 * CGFloat.pi / 2.0)
            
        case .leftMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width)
            transform = transform.scaledBy(x: -1, y: 1)
            transform = transform.rotated(by: 3.0 * CGFloat.pi / 2.0)
            
        case .right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            
        case .rightMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(scaleX: -1, y: 1)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()
        
        if orient == .right || orient == .left {
            
            context!.scaleBy(x: -scaleRatio, y: scaleRatio)
            context!.translateBy(x: -height, y: 0)
        } else {
            context!.scaleBy(x: scaleRatio, y: -scaleRatio)
            context!.translateBy(x: 0, y: -height)
        }
        
        context!.concatenate(transform)
        context!.draw(imgRef!, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageCopy!
    }
    
    
    
    
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
            
            
            let _selectedImage = rotateCameraImageToProperOrientation(imageSource : selectedImage, maxResolution : 1024.0)
            
            photoImageView.image = _selectedImage
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
        var _result: Bool
        
        if restaurant.name == "" || restaurant.location == "" || restaurant.website == "" || restaurant.image == nil {
             _result = false
        } else {
            _result = true
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
