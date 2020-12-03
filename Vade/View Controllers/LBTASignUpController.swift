//
//  LBTASignUpController.swift
//  Vade
//
//  Created by Egor on 22.11.2020.
//

import LBTATools
import Firebase
import FirebaseFirestore
import FirebaseAuth

class LBTASignUpController: LBTAFormController {
    
    let signUpButton = UIButton(title: "Sign Up", titleColor: .white, target: self, action: #selector(handleCancel))
    let firstNameTextField = UITextField(placeholder: "First Name")
    let lastNameTextField = UITextField(placeholder: "Last Name")
    let emailTextField = UITextField(placeholder: "Email")
    let passwordTextField = UITextField(placeholder: "Password")
    let passRequirementsLabel = UILabel(text: "At least 8 characters, numbers, uppercase and lowercase letters", textColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), numberOfLines: 0)
    let passwordStackView = UIStackView()
    
    override func viewDidLoad() {
        // configure view
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // configure formContainerStackView
        formContainerStackView.axis = .vertical
        formContainerStackView.spacing = 25
        formContainerStackView.layoutMargins = .init(top: 40, left: 40, bottom: 0, right: 40)
        
        // configure password field, requirements label and their stackView
        passwordStackView.axis = .vertical
        passwordTextField.setBottomBorder()
        passwordTextField.constrainHeight(50)
        passwordStackView.addArrangedSubview(passwordTextField)
        passRequirementsLabel.constrainHeight(50)
        passwordStackView.addArrangedSubview(passRequirementsLabel)
        
        // add text fields to formContainerStackView
        for textField in [firstNameTextField, lastNameTextField, emailTextField] {
            textField.constrainHeight(50)
            textField.setBottomBorder()
            formContainerStackView.addArrangedSubview(textField)
        }
        
        // add password stack view to formContainerStackView
        formContainerStackView.addArrangedSubview(passwordStackView)
        
        // add sign up button to formContainerStackView
        signUpButton.constrainHeight(50)
        Utilities.styleFilledButton(signUpButton)
        formContainerStackView.addArrangedSubview(signUpButton)
        
        firstNameTextField.autocorrectionType = .no
        lastNameTextField.autocorrectionType = .no
        emailTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
    }
    
    @objc fileprivate func handleCancel() {
        let error = validateFields()
        
        if error != nil {
            self.showAlert(title: "Sign Up failed", message: error!)
        }
        else {
            // clean all fields from tabs or spaces
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // create user with email and password
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    self.showAlert(title: "Sign Up failed", message: err!.localizedDescription)
                }
                else {
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(result!.user.uid).setData([
                        "name": firstName + " " + lastName,
                        "email": email,
                        "last_visit": Utilities.getCurrentDateAndTime()
                    ])
                    
                    // set data for app vade user
                    VadeUser.shared.setName(name: firstName + " " + lastName)
                    VadeUser.shared.setEmail(email: email)
                    VadeUser.shared.setFirestoreID(id: result!.user.uid)
                    
                    Transitor.transitionToHealthDataVC(view: self.view, storyboard: self.storyboard, uid: result!.user.uid)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func validateFields() -> String?
    {
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please, fill in all fields!"
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !Utilities.isPasswordValid(cleanedPassword) {
            return "Please make sure your password at least 8 chars, contains a number, upper and lowercase symbols"
        }
        
        return nil
    }
}
