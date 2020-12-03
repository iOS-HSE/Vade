//
//  ViewController.swift
//  Vade
//
//  Created by Egor on 03.10.2020.
//

import UIKit
import Firebase
import GoogleSignIn
import FacebookCore
import FacebookLogin

class AuthMethodsViewController: UIViewController{
    
    // outlets for buttons on view
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signInGoogleButton: UIButton!
    @IBOutlet weak var signInFacebookButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // set VC as GIDSignIn singleton delegate, it's required
        GIDSignIn.sharedInstance().delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        navigationController?.pushViewController(LBTASignUpController(), animated: true)
    }
    
    
    // action for signInGoogleButton
    @IBAction func signInGoogleTapped(_ sender: Any) {
        // call google sign in form
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    // action for signInFacebookButton
    @IBAction func signInFacebookTapped(_ sender: Any) {
        
        let loginManager = LoginManager()
        
        // try to sign in with facebook
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
                case .success(granted: _, declined: _, token: _):
                    self.signIntoFirebaseWithFacebook()
                case .failed(let err):
                    print(err)
                case .cancelled:
                    print("canceled")
            }
        }
    }
    
    func signIntoFirebaseWithFacebook() {
        // get credential
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        // try to auth with this credential
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                // print error message
                print(error?.localizedDescription as Any)
                return
            }
            else {
                // create user or update his last visit time
                let db = Firestore.firestore().collection("users")
                let userDocument = db.document(authResult!.user.uid)
        
                self.setVadeUserData(userDocument: userDocument, result: authResult!)
                
                print("Successfully authentification!")
                // go to next view controller
            }
        }
    }
    
    func setVadeUserData(userDocument: DocumentReference, result: AuthDataResult) {
        userDocument.getDocument { (document, error) in
            if let document = document, document.exists {
                let name = document.get("name") as! String
                let email = document.get("email") as! String
                let birthday = document.get("birthday") as! String
                let sex = document.get("sex") as! String
                let weight = document.get("weight") as! String
                let growth = document.get("growth") as! String
                
                VadeUser.shared.setName(name: name)
                VadeUser.shared.setEmail(email: email)
                VadeUser.shared.setFirestoreID(id: result.user.uid)
                VadeUser.shared.setBirthday(date: birthday)
                VadeUser.shared.setSex(sex: sex)
                VadeUser.shared.setWeight(weight: weight)
                VadeUser.shared.setGrowth(growth: growth)
                
                userDocument.setData(["last_visit": Utilities.getCurrentDateAndTime()], merge: true)
                
                Transitor.transitionToTabBarVC(view: self.view, storyboard: self.storyboard)
            }
            else {
                VadeUser.shared.setName(name: result.user.displayName!)
                VadeUser.shared.setEmail(email: result.user.email!)
                VadeUser.shared.setFirestoreID(id: result.user.uid)
                
                userDocument.setData([
                    "name": result.user.displayName!,
                    "email": result.user.email!,
                    "last_visit": Utilities.getCurrentDateAndTime()
                ])
                
                Transitor.transitionToHealthDataVC(view: self.view, storyboard: self.storyboard, uid: result.user.uid)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        setUpElements()
    }
    
    func setUpElements() {
        // style buttons
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleFilledButton(signInGoogleButton)
        Utilities.styleFilledButton(signInFacebookButton)
        Utilities.styleHollowButton(loginButton)
    }
    
    @IBAction func resetUser(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
        defaults.removeObject(forKey: key)
        }
    }
}


extension AuthMethodsViewController: GIDSignInDelegate {
    
    // sign func for google sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        signIntoFirebaseWithGoogle(didSignInFor: user)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // some actions when google signed in user disconnected
    }
    
    func signIntoFirebaseWithGoogle(didSignInFor user: GIDGoogleUser!) {
        // get credentials
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        
        // sign in with given credentials
        Auth.auth().signIn(with: credential) { (result, err) in
            if err != nil {
                print("Error: \(err?.localizedDescription)")
                return
            }
            else {
                // create user or update his last visit time
                let db = Firestore.firestore().collection("users")
                let userDocument = db.document(result!.user.uid)
        
                self.setVadeUserData(userDocument: userDocument, result: result!)
                
                print("Successfully authentification!")
                // go to next view controller
            }
        }
    }
}

