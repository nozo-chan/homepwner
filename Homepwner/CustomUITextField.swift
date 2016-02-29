//
//  CustomUITextField.swift
//  Homepwner
//
//  Created by nozomi morel on 19/02/16.
//  Copyright © 2016 Jero. All rights reserved.
//

import UIKit

class CustomUITextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        borderStyle = .Line
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        borderStyle = .RoundedRect
        return true
    }
    
    func viewDidLoad() {
        viewDidLoad()
    }

    
    
}
