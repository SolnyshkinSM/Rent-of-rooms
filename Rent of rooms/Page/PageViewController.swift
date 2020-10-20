//
//  PageViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 14.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    let contentArray = [NSLocalizedString("Efficient automation of all accounting processes for leases, contracts and payments", comment: ""),
                        NSLocalizedString("Simple and easy interface: Fast staff training, Simple implementation, Suitable for various types of rental business", comment: ""),
                        NSLocalizedString("Will help increase the income of your business", comment: ""),
                        NSLocalizedString("The system allows you to automate work, from entering customer data, to generating documents and sending notifications", comment: "")]
    
    let imageArray = ["MainPage", "CatalogPage", "ClientPage", "PaymentPage"]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Methods
    
    func configureView() {
        
        dataSource = self

        if let contentVC = distlayViewController(atIndex: 0) {
            setViewControllers([contentVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func distlayViewController(atIndex index: Int) -> ContentViewController? {
        
        guard index >= 0 else { return nil }
        guard index < contentArray.count else { return nil }
        guard let contentVC = storyboard?.instantiateViewController(identifier: "contentViewController") as? ContentViewController else { return nil}
        contentVC.text = contentArray[index]
        contentVC.imageNamed = imageArray[index]
        contentVC.numberOfPages = contentArray.count
        contentVC.index = index
        
        return contentVC
    }
    
    func nextVC(atIndexPath index: Int) {
        
        if let contentVC = distlayViewController(atIndex: index + 1) {
            setViewControllers([contentVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ContentViewController).index
        index -= 1
        
        return distlayViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ContentViewController).index
        index += 1
        
        return distlayViewController(atIndex: index)
    }
}
