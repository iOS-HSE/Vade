//
//  OnboardingViewController.swift
//  Vade
//
//  Created by Daria Tokareva on 13.11.2020.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet var holderView: UIView!
    
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        configurescrollView()
        super.viewDidLayoutSubviews()
        if !OnboardingManager.shared.isNewUser(){
            let viewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
            
            view.window?.rootViewController = viewController
            view.window?.makeKeyAndVisible()
        }
    }
    
    private func configurescrollView() {
         // set up scrollview
        scrollView.frame = holderView.bounds
        holderView.addSubview(scrollView)
        
        let titles = ["Welcome", "Set your route", "Train with your friends", "Choose your workout"]
        for x in 0..<4 {
            let pageView = UIView(frame: CGRect(x:CGFloat(x) * (holderView.frame.size.width), y:0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            scrollView.addSubview(pageView)
            
            // titile, image and button
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.frame.size.width-20, height: 120))
            let imageView = UIImageView(frame: CGRect(x: 10, y: 10+120+10, width: pageView.frame.size.width-20, height: pageView.frame.size.height - 60 - 130 - 15))
            let button = UIButton(frame: CGRect(x: 10, y: pageView.frame.size.height-60, width:pageView.frame.size.width-20, height: 50))
            
            label.textAlignment = .center
            label.font = UIFont(name: "Helvetica-Bold", size: 32)
            pageView.addSubview(label)
            label.text = titles[x]
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "onboarding_\(x+1)")
            pageView.addSubview(imageView)
            
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
            button.layer.cornerRadius = 25.0
            button.setTitle("Continue", for: .normal)
            if x == 3 {
                button.setTitle("Get Started", for: .normal)
            }
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = x+1
            pageView.addSubview(button)
        }
        
        scrollView.contentSize = CGSize(width: holderView.frame.size.width*3, height: 0)
        scrollView.isPagingEnabled = true
    }
    
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < 4 else {
            // dismiss
            OnboardingManager.shared.setIsNotNewUser()
            dismiss(animated: true, completion: nil)
            let viewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
            
            view.window?.rootViewController = viewController
            view.window?.makeKeyAndVisible()
            return
        }
        // scroll to next page
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
        }

}
class OnboardingManager {
    
    static let shared = OnboardingManager()
    
    private init() {}
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
