//
//  CatalogTableViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 02.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import CoreData

class CatalogTableViewController: UITableViewController, ManagedObjectContext {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        configureView()
    }
    
    // MARK: - Methods
    
    func configureView() {
        tableView.tableFooterView = UIView(frame: .zero)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        guard let identifier = cell.reuseIdentifier else { return }
        
        var message = ""
        switch identifier {
        case "Clients":
            message = NSLocalizedString("The reference book is designed to store information about partners.", comment: "")
        case "Rooms":
            message = NSLocalizedString("The reference book is intended to store information about the premises being leased.", comment: "")
        case "Contracts":
            message = NSLocalizedString("The reference book is intended for storing information on lease agreements for premises.", comment: "")
        default:
            break
        }
        
        present(getAlertController(title: identifier, message: message), animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClientSegue" {
            let dvc = segue.destination as? ClientTableViewController
            dvc?.managedObjectContext = managedObjectContext
            dvc?.hidesBottomBarWhenPushed = true
        } else if segue.identifier == "RoomSegue" {
            let dvc = segue.destination as? RoomTableViewController
            dvc?.managedObjectContext = managedObjectContext
        } else if segue.identifier == "ContractSegue" {
            let dvc = segue.destination as? ContractTableViewController
            dvc?.managedObjectContext = managedObjectContext
        }
    }
    
}
