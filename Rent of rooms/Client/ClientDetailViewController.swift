//
//  ClientDetailViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 05.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import CoreData

class ClientDetailViewController: UIViewController {
    
    var client: Client!
    var attributeTitles: [String] {
        return client.entity.attributesByName.enumerated().map { $0.element.key }
    }

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var ratingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        configureView()
    }
        
    // MARK: - Methods
    
    func configureView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        
        switch client.rating {
        case 0: ratingButton.setImage(UIImage(named: "Good"), for: .normal)
        case 1: ratingButton.setImage(UIImage(named: "Bad"), for: .normal)
        default: break
        }
        
        imageView.image = UIImage(data: client.image!)
        
        title = client.name        
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mapClientSegue" {
            let dvc = segue.destination as! ClientMapViewController
            dvc.client = client
        } else if segue.identifier == "rateClientSegue" {
            let dvc = segue.destination as! ClientRateViewController
            dvc.client = client
        }
    }
    
    @IBAction func unwindToCansel(_ unwindSegue: UIStoryboardSegue) {
        configureView()
    }    
}

extension ClientDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributeTitles.count - 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ClientDetailTableViewCell
        switch indexPath.row {
        case 0:
            cell.keyLabel.text = NSLocalizedString("Name", comment: "")
            cell.valueLabel.text = client.name            
        case 1:
            cell.keyLabel.text = NSLocalizedString("Adress", comment: "")
            cell.valueLabel.text = client.adress
        case 2:
            cell.keyLabel.text = NSLocalizedString("Phone", comment: "")
            cell.valueLabel.text = client.phone
        case 3:
            cell.keyLabel.text = NSLocalizedString("Mail", comment: "")
            cell.valueLabel.text = client.mail
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
