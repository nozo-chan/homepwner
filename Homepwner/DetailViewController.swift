//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Jero Brokaar on 19/02/16.
//  Copyright © 2016 Jero. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate {
    func detailViewController(controller: DetailViewController, didCreateItem item: Item)
}

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    var imageStore: ImageStore!
    
 
    
    
    var delegate: DetailViewControllerDelegate?
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
//    @IBOutlet weak var changeDate: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    
    @IBAction func takePicture(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        //if the device has a camera, take picture; otherwise, 
        // just pick from photo library 
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
            
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        
//        let overlayView = UIView(frame: CGRectMake(0, self.view.frame.width, self.view.frame.width, self.view.frame.height-self.view.frame.width))
//        overlayView.backgroundColor = UIColor.blackColor()
//        overlayView.alpha = 0.5
//        print(overlayView)
        
        let crosshair = "bullseye.png"
        
        let crosshairImage = UIImage(named: crosshair)
        
        let crosshairView = UIImageView(image: crosshairImage)
        imagePicker.cameraOverlayView = crosshairView
        crosshairView.frame.size.height = 150
        crosshairView.frame.size.width = 150
        crosshairView.center = self.view.center
        
        
        imagePicker.delegate = self
        //place image picker on the screen
        presentViewController(imagePicker, animated: true, completion: nil)
        
        imagePicker.allowsEditing = true
//        imagePicker.showsCameraControls = false
       
    }

    @IBAction func trash(sender: UIBarButtonItem) {
        imageView.image = nil
        imageStore.deleteImageForKey(item.itemKey)
    }
    

    
  
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var image: UIImage?
        
        if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = possibleImage
        } else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = possibleImage
        } else {
            fatalError("The photo controller is broken and did not produce an image.")
        }
        
        
        //get picked image from dictionary 
        if let image = image {
        //store the image in the ImageStore for the items"s key
        imageStore.setImage(image, forKey:item.itemKey)
        }
        
        //put that image on the screen in the image view 
        imageView.image = image
        //take image picker off the screen -
        //you must call this dismiss method
        dismissViewControllerAnimated(true, completion: nil)
        
      
        

    }
    
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    let numberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        return formatter
    }()
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
        override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        if nameField.text != "" {
        
            nameField.text = item.name
            serialNumberField.text = item.serialNumber
            valueField.text = numberFormatter.stringFromNumber(item.valueInDollars)
            dateLabel.text = dateFormatter.stringFromDate(item.dateCreated)
            
            //get the item key 
            let key = item.itemKey
            
            //if there is an associated image with the item 
            //display it on the image view 
            let imageToDisplay = imageStore.imageForKey(key)
            imageView.image = imageToDisplay
            
           
        }
    
    
    
    override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    //clear first responder
    view.endEditing(true)
    
    // "save" changes to item
    item.name = nameField.text ?? ""
    item.serialNumber = serialNumberField.text
    
    if let valueText = valueField.text,
        value = numberFormatter.numberFromString(valueText) {
            item.valueInDollars = value.integerValue
    }
    else{
        item.valueInDollars = 0
        }
    }
}







