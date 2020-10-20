//
//  ContractTableViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 07.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import CoreData

class ContractTableViewController: TemplateCoreDataTVC {
     
    var delegateVC: UIViewController?
    var predicate: NSPredicate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        if delegateVC == nil {
            animateTableInWidth(tableView)
        }
    }
    
    // MARK: - Methods
    
    func configureView() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc
    func insertNewObject(_ sender: Any) {
        guard let contactAddVC = storyboard?.instantiateViewController(identifier: "ContactAddTableViewController") else { return }
        contactAddVC.modalPresentationStyle = .fullScreen
        present(contactAddVC, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContractTableViewCell
        let contract = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withObject: contract)
        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let delegateVC = delegateVC as? PaymentAddTableViewController {
            delegateVC.selectedValueDelegate(fetchedResultsController.object(at: indexPath))
            dismiss(animated: true, completion: nil)
        }
        
        if let contractAddVC = storyboard?.instantiateViewController(identifier: "ContactAddTableViewController") as? ContactAddTableViewController {
            contractAddVC.modalPresentationStyle = .fullScreen
            contractAddVC.contract = fetchedResultsController.object(at: indexPath)
            present(contractAddVC, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    override func configureCell(_ cell: UITableViewCell, withObject object: AnyObject) {
        guard let cell = cell as? ContractTableViewCell else { return }
        guard let object = object as? Contract else { return }
        cell.numberLabel?.text = object.number
        cell.dateLabel.text = getDateFormatter().string(from: object.date!)
        cell.clientLabel?.text = object.client?.name
        cell.roomLabel.text = object.room?.name
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Contract> {
        
        if _fetchedResultsController != nil { return _fetchedResultsController! }
        
        let fetchRequest: NSFetchRequest<Contract> = Contract.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        fetchRequest.predicate = predicate != nil ? predicate : nil
        
        let sortDescriptor = NSSortDescriptor(key: "number", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController<Contract>? = nil
    
}
