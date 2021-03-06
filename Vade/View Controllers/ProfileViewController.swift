//
//  ProfileViewController.swift
//  Vade
//
//  Created by Egor on 17.11.2020.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    var personalDataLabels = ["Name", "Email", "Firestore ID"]
    var healthDataLabels = ["Sex", "Birthday", "Weight", "Growth"]
    
    var personalDataValues: [String?] = []
    var healthDataValues: [String?] = []
    var cells: [UITableViewCell] = []
    
    @IBOutlet weak var personalDataTableView: UITableView!
    @IBOutlet weak var healthDataTableView: UITableView!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTablesValues()
        personalDataTableView.delegate = self
        personalDataTableView.dataSource = self
        personalDataTableView.tag = 1
        personalDataTableView.separatorInset = UIEdgeInsets.zero
        
        healthDataTableView.delegate = self
        healthDataTableView.dataSource = self
        healthDataTableView.tag = 2
        healthDataTableView.separatorInset = UIEdgeInsets.zero
    }
    
    func initTablesValues() {
        
        healthDataValues.append(VadeUser.shared.sex)
        healthDataValues.append(VadeUser.shared.birthday)
        healthDataValues.append(VadeUser.shared.weight)
        healthDataValues.append(VadeUser.shared.growth)
        
        personalDataValues.append(VadeUser.shared.name)
        personalDataValues.append(VadeUser.shared.email)
        personalDataValues.append(VadeUser.shared.firestoreID)
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            Transitor.transitionToAuthNavigationVC(view: self.view, storyboard: self.storyboard)
        } catch let signOutError as NSError {
            print("ERROR: \(signOutError)")
        }
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
            cells.append(cell)
            return cell
        default:
            var cell = UITableViewCell(style: .value1, reuseIdentifier: "idHealth")
            cell.textLabel?.text = healthDataLabels[indexPath.item]
            cell.detailTextLabel?.text = healthDataValues[indexPath.item]
            cells.append(cell)
            return cell
        }
    }
    
    
}
