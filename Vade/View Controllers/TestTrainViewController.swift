//
//  TestTrainViewController.swift
//  Vade
//
//  Created by Egor on 02.02.2021.
//

import UIKit

class TestTrainViewController: UIViewController {

    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        loadButton.roundSpecificCorners(corners: [.topLeft, .bottomLeft], value: Int(loadButton.frame.height * 0.3))
        startButton.roundSpecificCorners(corners: [.topRight, .bottomRight], value: Int(startButton.frame.height * 0.3))
        settingsButton.layer.cornerRadius = settingsButton.frame.width / 2
    }
}
