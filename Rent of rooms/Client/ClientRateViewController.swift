//
//  ClientRateViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 06.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import CoreData

class ClientRateViewController: UIViewController {
    
    var client: Client!
    
    @IBOutlet var rateCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Methods
    
    func configureView() {
        
        for button in rateCollection {
            button.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.bounds
        visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.insertSubview(visualEffectView, at: 1)
        
        title = client.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for (index, button) in rateCollection.enumerated() {
            let delay = Double(index) * 0.2
            UIView.animate(withDuration: 0.6, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                button.transform = CGAffineTransform(translationX: 1.0, y: 1.0)
            }, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func rateClientActions(_ sender: UIButton) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            client.rating = Int16(sender.tag)
            appDelegate.saveContext()
        }
        performSegue(withIdentifier: "unwindToCanselClientSegue", sender: self)
    }    
}
