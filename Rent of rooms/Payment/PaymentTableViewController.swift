//
//  PaymentTableViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 08.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import CoreData

class PaymentTableViewController: TemplateCoreDataTVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateTableInWidth(tableView)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PaymentTableViewCell
        let payment = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withObject: payment)
        return cell
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
        guard let cell = cell as? PaymentTableViewCell else { return }
        guard let object = object as? Payment else { return }
        cell.clientLabel?.text = object.client?.name
        cell.contractLabel.text = (object.contract?.number)! + NSLocalizedString(" from ", comment: "") + getDateFormatter().string(from: (object.contract?.date!)!)
        cell.dateLabel.text = getDateFormatter().string(from: object.date!)
        cell.sumLabel?.text = getNumberFormatter().string(from: object.sum as NSNumber)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paymentDetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! PaymentAddTableViewController
                dvc.payment = fetchedResultsController.object(at: indexPath)
            }
        }
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Payment> {
        
        if _fetchedResultsController != nil { return _fetchedResultsController! }
        
        let fetchRequest: NSFetchRequest<Payment> = Payment.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptorClient = NSSortDescriptor(key: "client.name", ascending: true)
        let sortDescriptorDate = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorClient, sortDescriptorDate]
        
                
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "client.name", cacheName: nil)
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
    
    var _fetchedResultsController: NSFetchedResultsController<Payment>? = nil
    
    // MARK: - Actions
    
    @IBAction func predicateSegmentedAction(_ sender: UISegmentedControl) {
                
        switch sender.selectedSegmentIndex {
        case 0:
            fetchedResultsController.fetchRequest.predicate = nil
        default:
            let predicate = NSPredicate(format: "contract.endDate >= %@", Date() as CVarArg)
            fetchedResultsController.fetchRequest.predicate = predicate
        }
                
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
                
        tableView.reloadData()
    }
}
