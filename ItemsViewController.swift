//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Jero Brokaar on 17/02/16.
//  Copyright © 2016 Jero. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    @IBAction func addNewItem(sender: AnyObject) {
        // Create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        // Figure out where that item is in the array
        if let index = itemStore.allItems.indexOf(newItem){
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            // Insert this new row into the table
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    
    override func tableView(tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return itemStore.allItems.count
        } else {
            return 1
        }

    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // get a new or recycled cell
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        let message:String = "No more Items"
        
       
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell will appear in on the table view
        if indexPath.section == 0 {
            let item = itemStore.allItems[indexPath.row]
            
            cell.nameLabel.text? = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"

            //update the labels for the new preferred text size
            cell.updateLabels(item.valueInDollars)
           
        }
        else {
            
            cell.detailTextLabel?.text = ""
            cell.textLabel!.text = message
            cell.nameLabel.text = ""
            cell.serialNumberLabel.text = ""
            cell.valueLabel.text = ""
    }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Remove"
        
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 1{
            return .None
        } else {
            
         return .Delete
    }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // If the table view is asking to commit a delete command
        if editingStyle == .Delete {
            
            let item = itemStore.allItems[indexPath.row]
            
            
            let title = "Remove \(item.name)?"
            let message = "Are you sure want to remove this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Remove", style: .Destructive, handler: { (action) -> Void in
            
            //Remove the item from the store
            self.itemStore.removeItem(item)
            
                //remove the item's image from the image store 
                self.imageStore.deleteImageForKey(item.itemKey)
            
            // Also remove that row from the table view with an animation
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
            })
            ac.addAction(deleteAction)
        
            // Present the alert controller
            presentViewController(ac, animated: true, completion: nil)
            
    }
    }
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        // Update the model
        itemStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    override func tableView(tableView: UITableView,
        targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath,
        toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
            print("Proposed index path row: \(proposedDestinationIndexPath.row), section: \(proposedDestinationIndexPath.section)")
            print("Count of items : \(itemStore.allItems.count)")
            
            if proposedDestinationIndexPath.section == 0 && sourceIndexPath.section != 1 {
                return proposedDestinationIndexPath
            } else {
                // return NSIndexPath(forRow: proposedDestinationIndexPath.row - 1, inSection: 0)
                return sourceIndexPath
            }

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // If the triggered segue is the "ShowItem" segue
        if segue.identifier == "ShowItem" {
            
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                
                // Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destinationViewController as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
        required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem()
    
    
    }
}
