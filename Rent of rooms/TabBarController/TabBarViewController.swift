//
//  TabBarViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 14.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "showContent") == false {
            if let pageViewController = storyboard?.instantiateViewController(identifier: "pageViewController") as? PageViewController {
                pageViewController.modalPresentationStyle = .fullScreen
                present(pageViewController, animated: true, completion: nil)
            }
        }
    }
}
