//
//  ItemCell.swift
//  Homepwner
//
//  Created by nozomi morel on 18/02/16.
//  Copyright © 2016 Jero. All rights reserved.
//

import UIKit


class ItemCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    
    func updateLabels(valueInDollars: Int) {
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        nameLabel.font = bodyFont
        valueLabel.font = bodyFont
        
        let caption1Font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        serialNumberLabel.font = caption1Font
        
        
        
        if valueInDollars < 50 {
            let color = UIColor.greenColor()
            valueLabel.textColor = color
        } else {
             let color = UIColor.redColor()
            valueLabel.textColor = color
        }
}

}