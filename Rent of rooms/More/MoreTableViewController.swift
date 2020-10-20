//
//  MoreTableViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 13.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class MoreTableViewController: UITableViewController {
    
    var spinner: NVActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - Methods
    
    func configureView() {
        
        spinner = NVActivityIndicatorView.init(frame: self.view.bounds)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.backgroundColor = .white
        spinner.color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        self.view.addSubview(spinner)
        spinner.startAnimating()
        
        if let spinner = spinner {
            spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        }
        
        self.view.isUserInteractionEnabled = false
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            self.spinner.stopAnimating()
            self.spinner.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
            self.navigationController?.tabBarItem.badgeValue = nil
        }        
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.reuseIdentifier == "Manual" {
            
            let webView = WKWebView(frame: self.view.frame)
            guard let filePath = Bundle.main.path(forResource: "Manual.pdf", ofType: nil) else { return }
            let url = URL(fileURLWithPath: filePath)
            let request = URLRequest(url: url)
            webView.load(request)
            
            let view = UIView()
            view.backgroundColor = .white
            view.addSubview(webView)
            
            let viewController = UIViewController()
            viewController.navigationItem.title = NSLocalizedString("Manual", comment: "")
            viewController.hidesBottomBarWhenPushed = true
            viewController.view = view
            
            show(viewController, sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }    
}
