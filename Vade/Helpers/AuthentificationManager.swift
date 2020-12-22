//
//  AuthentificationManager.swift
//  Vade
//
//  Created by Egor on 03.12.2020.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn
import FacebookCore
import FacebookLogin

enum FirebaseAuthResult {
    case loggedIn
    case registered(String)
    case failure(String?)
}

class AuthentificationManager {
    
    func setVadeUserData(userDocument: DocumentReference, result: AuthDataResult, callback: @escaping (FirebaseAuthResult) -> ()) {
        
        var name, email, birthday, sex, weight, growth: String?
        
        var signResult: FirebaseAuthResult = .loggedIn
        
        userDocument.getDocument { (document, error) in
            if let document = document, document.exists {
                name = document.get("name") as? String
                email = document.get("email") as? String
                birthday = document.get("birthday") as? String
                sex = document.get("sex") as? String
                weight = document.get("weight") as? String
                growth = document.get("growth") as? String
                
                userDocument.setData(["last_visit": Utilities.getCurrentDateAndTime()], merge: true)
                
            }
            else {
                signResult = .registered(result.user.uid)
                
                userDocument.setData([
                    "name": result.user.displayName!,
                    "email": result.user.email!,
                    "last_visit": Utilities.getCurrentDateAndTime()
                ])
            }
            
            switch signResult {
                case .loggedIn:
                    VadeUser.shared.name = name
                    VadeUser.shared.email = email
                    VadeUser.shared.firestoreID = result.user.uid
                    VadeUser.shared.birthday = birthday
                    VadeUser.shared.sex = sex
                    VadeUser.shared.weight = weight
                    VadeUser.shared.growth = growth
                    print("IN LOGGED IN SWITCH: \(Thread.current)")
                case .registered(let uid):
                    VadeUser.shared.name = result.user.displayName!
                    VadeUser.shared.email = result.user.email!
                    VadeUser.shared.firestoreID = uid
                    print("IN REGISTERED IN SWITCH: \(Thread.current)")
                default:
                    callback(.failure("Some error"))
            }
            
            callback(signResult)
        }
        
        return
    }
    
    func signInWithGoogle(user: GIDGoogleUser!, callback: @escaping (FirebaseAuthResult) -> ()) {
        guard let authentication = user.authentication else {
            callback(.failure("Server error, try again"))
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        
        // sign in with given credentials
        Auth.auth().signIn(with: credential) { (result, err) in
            if err != nil {
                callback(.failure(err?.localizedDescription))
                return
            }
            else {
                let db = Firestore.firestore().collection("users")
                let userDocument = db.document(result!.user.uid)
                self.setVadeUserData(userDocument: userDocument, result: result!, callback: callback)
            }
        }
    }
}
