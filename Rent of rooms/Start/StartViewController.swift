//
//  StartViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 02.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet var nameImageView: UIImageView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Methods
    
    func configureView() {
        
        let viewRect = self.view.bounds;
        let maxX = viewRect.maxX;
        let maxY = viewRect.maxY;
        let midX = viewRect.midX;
        let midY = viewRect.midY;
                
        logoImageView.center = CGPoint(x: maxX + logoImageView.bounds.width, y: midY);
        nameImageView.center = CGPoint(x: viewRect.minX - nameImageView.bounds.width, y: midY / 2);
        emailLabel.center = CGPoint(x: midX, y: midY)
        
        logoImageView.transform = CGAffineTransform(rotationAngle: 30)
        
        UIView.animate(withDuration: 2) {
            self.logoImageView.center = CGPoint(x: midX, y: midY);
            self.nameImageView.center = CGPoint(x: midX, y: midY / 2);
            self.emailLabel.center = CGPoint(x: midX, y: maxY - self.emailLabel.bounds.height * 2);
            
            self.logoImageView.transform = CGAffineTransform(rotationAngle: 0).concatenating(CGAffineTransform(scaleX: 2, y: 2))
        }
               
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            self.view.window?.rootViewController = getCurrentTabBarController()
        }
    }
}
