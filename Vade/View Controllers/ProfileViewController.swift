//
//  ProfileViewController.swift
//  Vade
//
//  Created by Egor on 17.11.2020.
//

import UIKit

class ProfileViewController: UIViewController {

    var personalDataLabels = ["Name", "Email", "Firestore ID"]
    var healthDataLabels = ["Sex", "Birthday", "Weight", "Growth"]
    
    var personalDataValues: [String] = []
    var healthDataValues: [String] = []
    
    @IBOutlet weak var personalDataTableView: UITableView!
    @IBOutlet weak var healthDataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTablesValues()
        personalDataTableView.delegate = self
        personalDataTableView.dataSource = self
        personalDataTableView.tag = 1
        
        healthDataTableView.delegate = self
        healthDataTableView.dataSource = self
        healthDataTableView.tag = 2
    }
    
    func initTablesValues() {
        
        healthDataValues.append(VadeUser.shared.getSex())
        healthDataValues.append(VadeUser.shared.getBirthday())
        healthDataValues.append(VadeUser.shared.getWeight())
        healthDataValues.append(VadeUser.shared.getGrowth())
        
        personalDataValues.append(VadeUser.shared.getName())
        personalDataValues.append(VadeUser.shared.getEmail())
        personalDataValues.append(VadeUser.shared.getFirestoreID())
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 1:
            return 3
        case 2:
            return 4
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 1:
            var cell = UITableViewCell(style: .value1, reuseIdentifier: "idPersonal")
            cell.textLabel?.text = personalDataLabels[indexPath.item]
            cell.detailTextLabel?.text = personalDataValues[indexPath.item]
            return cell
        default:
            var cell = UITableViewCell(style: .value1, reuseIdentifier: "idHealth")
            cell.textLabel?.text = healthDataLabels[indexPath.item]
            cell.detailTextLabel?.text = healthDataValues[indexPath.item]
            return cell
        }
    }
    
    
}
