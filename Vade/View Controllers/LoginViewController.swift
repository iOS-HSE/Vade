//
//  LoginViewController.swift
//  Vade
//
//  Created by Egor on 03.10.2020.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // outlets for elements on view
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        setUpElements()
    }
    
    // for hide heyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func setUpElements() {
        //tilities.styleTextField(emailTextField)
        //Utilities.styleTextField(passwordTextField)
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        Utilities.styleFilledButton(loginButton)
    }
    
    func setVadeUserData(userDocument: DocumentReference, id: String) {
        print("Print VadeUser in setVadeUserData")
        userDocument.getDocument { (document, error) in
            if let document = document, document.exists {
                let name = document.get("name") as! String
                let email = document.get("email") as! String
                let birthday = document.get("birthday") as! String
                let sex = document.get("sex") as! String
                let weight = document.get("weight") as! String
                let growth = document.get("growth") as! String

                VadeUser.shared.setName(name: name)
                UserDefaults.standard.setValue(name, forKey: "userName")
                VadeUser.shared.setEmail(email: email)
                VadeUser.shared.setFirestoreID(id: id)
                UserDefaults.standard.setValue(name, forKey: "userID")
                VadeUser.shared.setBirthday(date: birthday)
                UserDefaults.standard.setValue(birthday, forKey: "userBirthday")
                VadeUser.shared.setSex(sex: sex)
                UserDefaults.standard.setValue(sex, forKey: "userSex")
                VadeUser.shared.setWeight(weight: weight)
                UserDefaults.standard.setValue(weight, forKey: "userWeight")
                VadeUser.shared.setGrowth(growth: growth)
                UserDefaults.standard.setValue(growth, forKey: "userGrowth")
                
                Transitor.transitionToTabBarVC(view: self.view, storyboard: self.storyboard)

            }
            else {
                print("Document does not exist")
            }
        }
    }
    
    // action for loginButton
    @IBAction func loginTapped(_ sender: Any) {
        
        // get clean fields without spaces
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // sign in wth email and password
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if err != nil {
                self.showAlert(title: "Login failed", message: err!.localizedDescription)
            }
            else {
                let db = Firestore.firestore().collection("users")
                let userDocument = db.document(result!.user.uid)
                // update user last visit time
                userDocument.setData(["last_visit": Utilities.getCurrentDateAndTime()], merge: true)
                UserDefaults.standard.setValue(email, forKey: "userEmail")
                UserDefaults.standard.setValue(password, forKey: "userPassword")
                UserDefaults.standard.setValue(true, forKey: "isUserLoggedIn")
                
                self.setVadeUserData(userDocument: userDocument, id: result!.user.uid)
            }
        }
    }
}

