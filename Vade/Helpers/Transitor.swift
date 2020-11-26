//
//  Transitor.swift
//  Vade
//
//  Created by Egor on 17.11.2020.
//

import UIKit
import Foundation

// for transitions between view controllers
class Transitor {

    static func transitionToHealthDataVC(view: UIView, storyboard: UIStoryboard?, uid: String) {
        let healthDataVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.Storyboard.healthDataVC) as HealthDataViewController
        healthDataVC.userID = uid
        
        // for animated transition
        let transition = CATransition()
        transition.type = .moveIn
        transition.duration = 0.5
        view.window?.layer.add(transition, forKey: kCATransition)
        
        view.window?.rootViewController = healthDataVC
        view.window?.makeKeyAndVisible()
    }
    
    static func transitionToTabBarVC(view: UIView, storyboard: UIStoryboard?) {
        let tabBarVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarVC) as? MainTabBarViewController
        
        // for animated transition
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 1
        view.window?.layer.add(transition, forKey: kCATransition)
        
        view.window?.rootViewController = tabBarVC
        view.window?.makeKeyAndVisible()
    }
    
    static func transitionToAuthNavigationVC(view: UIView, storyboard: UIStoryboard?) {
        let authNavigationVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.authNavigationVC) as? UINavigationController
        
        // for animated transition
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 1
        view.window?.layer.add(transition, forKey: kCATransition)
        
        view.window?.rootViewController = authNavigationVC
        view.window?.makeKeyAndVisible()
    }
}
