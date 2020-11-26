//
//  HealthDataViewController.swift
//  Vade
//
//  Created by Egor on 03.10.2020.
//

import UIKit
import FirebaseFirestore

class HealthDataViewController: UIViewController {
    
    // userID in firestore to add healthdata to document in firestore + table and continue button outlets
    var userID = "default"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set VC as table view delegate and dataSource, it's required for tableView work
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    // action for continue button
    @IBAction func continueTapped(_ sender: Any) {
        print("CONTINUE TAPPED")
        let db = Firestore.firestore()
        
        // get info from table to add to user
        let birthday = tableView.cellForRow(at: [0, 0])?.detailTextLabel?.text ?? "Default birthday"
        let sex = tableView.cellForRow(at: [0, 1])?.detailTextLabel?.text ?? "Default sex"
        let weight = tableView.cellForRow(at: [0, 2])?.detailTextLabel?.text ?? "Default weight"
        let growth = tableView.cellForRow(at: [0, 3])?.detailTextLabel?.text ?? "Default growth"
        
        // add new health info for user
        db.collection("users").document(userID).updateData([
            "birthday": birthday,
            "sex": sex,
            "weight": weight,
            "growth": growth
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        VadeUser.shared.setBirthday(date: birthday)
        VadeUser.shared.setSex(sex: sex)
        VadeUser.shared.setWeight(weight: weight)
        VadeUser.shared.setGrowth(growth: growth)
        
        // got to tab bar vc
        Transitor.transitionToTabBarVC(view: self.view, storyboard: self.storyboard)
    }
}

extension HealthDataViewController: UITableViewDataSource, UITableViewDelegate {
    // next methods only from UITableViewDelegate
    
    // set number of rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    // init table with different type of cells
    // CellBuildersManager build different cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            return CellBuildersManager.buildDatePickerTableCellBirthday()
        case 1:
            return CellBuildersManager.buildPickerTableCellGender()
        case 2:
            return CellBuildersManager.buildPickerTableCellWeight()
        case 3:
            return CellBuildersManager.buildPickerTableCellGrowth()
        default:
            return UITableViewCell()
        }
    }
    
    // method handles table row selecting
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.becomeFirstResponder()
    }
}
