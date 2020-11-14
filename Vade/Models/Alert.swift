//
//  Alert.swift
//  Vade
//
//  Created by Egor on 09.11.2020.
//

import Foundation
import UIKit

class Alert {
    private var title: String?
    private var message: String?
    private var alert: UIAlertController
    
    static let shared = Alert()
    
    private init() {
        alert = UIAlertController(title: "Default title", message: "Default message", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             print("Ok button tapped")
          })
        alert.addAction(ok)
    }

    func setTitle(title: String) {
        alert.title = title
    }
    
    func setMessage(message: String) {
        alert.message = message
    }
    
    func setTitleAndMessage(title: String, message: String) {
        setTitle(title: title)
        setMessage(message: message)
    }
    
    func getAlert() -> UIAlertController {
        return alert
    }
}
