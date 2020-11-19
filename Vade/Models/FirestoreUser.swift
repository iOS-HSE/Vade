//
//  FirestoreUser.swift
//  Vade
//
//  Created by Egor on 09.11.2020.
//

import Foundation
import GoogleSignIn

class FirestoreUser {
    private var name: String?
    private var email: String?
    private var lastVisitTime: String?
    
    init(user: GIDGoogleUser!) {
        name = user.profile.name
        email = user.profile.email
        lastVisitTime = Utilities.getCurrentDateAndTime()
    }
    
    func getName() -> String? {
        return name
    }
    
    func getEmail() -> String? {
        return email
    }
    
    func getLastVisitTime() -> String? {
        return lastVisitTime
    }
    
    static func namePropTitle() -> String {
        return "name"
    }
    
    static func emailPropTitle() -> String {
        return "email"
    }
    
    static func lastVisitTimePropTitle() -> String {
        return "lastVisitTime"
    }
}
