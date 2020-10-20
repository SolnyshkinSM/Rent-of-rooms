//
//  ContentViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 14.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    var text: String!
    var imageNamed: String!
    var numberOfPages: Int!
    var index = 0
    
    @IBOutlet var pageButton: UIButton!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Methods
    
    func configureView() {
        
        textLabel.text = text
        imageView.image = UIImage(named: imageNamed)
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = index
        
        //Button
        pageButton.layer.cornerRadius = pageButton.bounds.size.height / 2
        pageButton.clipsToBounds = true
        pageButton.layer.borderWidth = 2
        pageButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        pageButton.layer.borderColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        
        if index == numberOfPages - 1 {
            pageButton.setTitle(NSLocalizedString("Close", comment: ""), for: .normal)
        } else {
            pageButton.setTitle(NSLocalizedString("Next", comment: ""), for: .normal)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func pageButtonPressed(_ sender: UIButton) {
        
        if index == numberOfPages - 1 {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "showContent")
            userDefaults.synchronize()
            dismiss(animated: true, completion: nil)
        } else {
            let parentVC = parent as! PageViewController
            parentVC.nextVC(atIndexPath: index)
        }
    }
}
