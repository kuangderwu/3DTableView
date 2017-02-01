//
//  AddRestaurantTableViewController.swift
//  3DTableView
//
//  Created by Wu KD on 2017/1/28.
//  Copyright © 2017年 Kuangder. All rights reserved.
//

import UIKit
import CoreData

class AddRestaurantTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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

    @IBAction func save(_ sender: Any) {
        if nameTextField.text == "" || locationTextField.text == "" {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
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
        }
        
        dismiss(animated: true, completion: nil)
        
    }
 
    
    @IBAction func typeSegmentControl(_ sender: UISegmentedControl) {
        
//        print("\(typeSegmentControl.selectedSegmentIndex)")

    }

}
