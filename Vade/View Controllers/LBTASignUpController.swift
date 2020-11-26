//
//  LBTASignUpController.swift
//  Vade
//
//  Created by Egor on 22.11.2020.
//

import LBTATools

class LBTASignUpController: LBTAFormController {
    
    let signUpButton = UIButton(title: "Sign Up", titleColor: .white, target: self, action: #selector(handleCancel))
    let firstNameTextField = UITextField(placeholder: "First Name")
    let lastNameTextField = UITextField(placeholder: "Last Name")
    let emailTextField = UITextField(placeholder: "Email")
    let passwordTextField = UITextField(placeholder: "Password")
    let passRequirementsLabel = UILabel(text: "At least 8 characters, numbers, uppercase and lowercase letters", textColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), numberOfLines: 0)
    let passwordStackView = UIStackView()
    
    @objc fileprivate func handleCancel() {
        if let err = validateFields() {
            self.showAlert(title: "Error", message: err)
        }
        else {
            Transitor.transitionToHealthDataVC(view: view, storyboard: storyboard, uid: "123")
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
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor

        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.systemOrange.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
  }
}
