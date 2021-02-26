//
//  DataViewController.swift
//  Vade
//
//  Created by Daria Tokareva on 26.02.2021.
//

import UIKit

class DataViewController: UIViewController {

    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentButton: UIButton!
    @IBAction func buttonTapped(_ sender: Any) {
        OnboardingManager.shared.setIsNotNewUser()
        dismiss(animated: true, completion: nil)
        Transitor.transitionToAuthNavigationVC(view: self.view, storyboard: self.storyboard)
        return
    }
    
    var displayText: String?
    var index: Int?
    var buttonName: String = "" {
        didSet {
            if let button = contentButton {
                button.setTitle(buttonName, for: .normal)
            
            }
        }
    }
    var imageName: String = "" {
        didSet {
            if let imageView = contentImageView {
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLabel.text = displayText
        contentImageView.image = UIImage(named: imageName)
        contentButton.setTitle(buttonName, for: .normal)
        contentButton.setTitleColor(.white, for: .normal)
        contentButton.backgroundColor = .black
        contentButton.layer.cornerRadius = 25.0
        
    }

}
