//
//  VadeUser.swift
//  Vade
//
//  Created by Egor on 17.11.2020.
//

import Foundation

class VadeUser {
    
    typealias Listener = (String?) -> ()
    
    private var listeners: [Listener] = []
    
    func bind(l: @escaping Listener) {
        listeners.append(l)
        
    }
    // properties
    var name: String? {
        didSet {
            print("name: \(name ?? "name not set")")
            }
    }
    
    var email: String?  {
        didSet {
            print("email: \(email ?? "email not set")")
            }
    }
    
    var firestoreID: String?  {
        didSet {
            print("firestoreID: \(firestoreID ?? "firestoreID not set")")
            }
    }
    
    var sex: String?  {
        didSet {
            print("sex: \(name ?? "sex not set")")
            }
    }
    
    var birthday: String?  {
        didSet {
            print("birthday: \(birthday ?? "birthday not set")")
            }
    }
    
    var weight: String?  {
        didSet {
            print("weight: \(weight ?? "weight not set")")
            }
    }
    
    var growth: String?  {
        didSet {
            print("growth: \(growth ?? "growth not set")")
            }
    }
    
    static var shared = VadeUser()
    
    private init() { }
}
