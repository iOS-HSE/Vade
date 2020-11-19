//
//  CustomDetailCell.swift
//  Vade
//
//  Created by Egor on 15.11.2020.
//

import UIKit
import Foundation

protocol CustomDetailCellProtocol {
    func setTitle(title: String)
    func setDetailText(detail: String)
    func initCell()
}

// base class for table view cell with details
class CustomDetailCell: UITableViewCell, CustomDetailCellProtocol, SimplyInitializable {
    required init() {
        super.init(style: .value1, reuseIdentifier: "idCustomcell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title: String) {
        self.textLabel?.text = title
    }
    
    func setDetailText(detail: String) {
        self.detailTextLabel?.text = detail
    }
    
    // this method must be overriden in inherited class
    func initCell() {
        
    }
}
