//
//  LaunchScreenController.swift
//  Smile!
//
//  Created by Виктор on 23.04.2023.
//

import UIKit

class LaunchScreenController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
    }
    
    func setBackgroundColor() {
        let topColor = UIColor(red:176.0/255, green:170.0/255, blue:217.0/255, alpha: 1).cgColor
        let middleColor = UIColor(red:214.0/255, green:92.0/255, blue:151.0/255, alpha: 0.8).cgColor
        let bottomColor = UIColor(red:157.0/255, green:46.0/255, blue:151.0/255, alpha: 1).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor, middleColor, bottomColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
