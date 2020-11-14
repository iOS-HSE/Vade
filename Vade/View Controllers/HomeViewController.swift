//
//  HomeViewController.swift
//  Vade
//
//  Created by Egor on 03.10.2020.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        transitionToTabBarVC()
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let cell = DatePickerTableViewCell(style: .value1, reuseIdentifier: "idCell")
            cell.textLabel?.text = "Select birth day"
            cell.detailTextLabel?.text = "..."
            return cell
        case 1:
            let sexes = ["Male", "Female"]
            let cell = PickerTableViewCell(style: .value1, pickerData: sexes, reuseIdentifier: "idCell")
            cell.textLabel?.text = "Sex"
            cell.detailTextLabel?.text = "..."
            return cell
        case 2:
            let dataInt = [Int](30...200)
            let dataString = dataInt.map { String($0) }
            let cell = PickerTableViewCell(style: .value1, pickerData: dataString, reuseIdentifier: "idCell")
            cell.textLabel?.text = "Weight"
            cell.detailTextLabel?.text = "..."
            return cell
        case 3:
            let dataInt = [Int](50...250)
            let dataString = dataInt.map { String($0) }
            let cell = PickerTableViewCell(style: .value1, pickerData: dataString, reuseIdentifier: "idCell")
            cell.textLabel?.text = "Growth"
            cell.detailTextLabel?.text = "..."
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.becomeFirstResponder()
    }
    
    func transitionToTabBarVC() {
        let tabBarViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarViewController)
        
        let transition = CATransition()
         
        transition.type = .fade
         
        transition.duration = 1
         
        view.window?.layer.add(transition, forKey: kCATransition)
        
        view.window?.rootViewController = tabBarViewController
        view.window?.makeKeyAndVisible()
    }
}
