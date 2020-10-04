//
//  Utilities.swift
//  Vade
//
//  Created by Egordash on 30/09/2020.
//  Copyright © 2020 DevSquad. All rights reserved.
//

import Foundation
import UIKit

class Utilities
{
    static func styleTextField(_ textField: UITextField)
    {
        // create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)
        textField.layer.masksToBounds = true
        bottomLine.backgroundColor = UIColor.systemOrange.cgColor
        
        // remove border on text field
        textField.borderStyle = .none
        
        // add the line to the text field
        textField.layer.addSublayer(bottomLine)
    }
    
    static func styleFilledButton(_ button: UIButton)
    {
        // filled rounded corner style
        button.backgroundColor = UIColor.systemOrange
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button: UIButton)
    {
        // hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemOrange.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password: String) -> Bool
    {
        let passText = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        
        return passText.evaluate(with: password)
    }
}
