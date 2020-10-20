//
//  ViewController.swift
//  Vade
//
//  Created by Egor on 03.10.2020.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signInGoogleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        // Do any additional setup after loading the view.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                            accessToken: authentication.accessToken)
            print("User prepeared")
            print("User ID: \(user.userID)")
            print("Name: \(user.profile.name)")
            print("Email: \(user.profile.email)")
            
            Auth.auth().signIn(with: credential) { (result, error) in
                if error != nil{
                    return
                }
                else{
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(result!.user.uid).setData([
                        "name": user.profile.name,
                        "email": user.profile.email,
                        "last_visit": Utilities.getCurrentDateAndTime()
                    ])
                    
                    print("Successfully authentification!")
                    self.transitionToHome()
                }
            }
    }
    
    @IBAction func signInGoogleTapped(_ sender: Any) {
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // some actions
    }
        
    func transitionToHome()
    {
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    override func viewDidLayoutSubviews() {
        setUpElements()
    }
    
    func setUpElements()
    {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleFilledButton(signInGoogleButton)
        Utilities.styleHollowButton(loginButton)
    }
}

