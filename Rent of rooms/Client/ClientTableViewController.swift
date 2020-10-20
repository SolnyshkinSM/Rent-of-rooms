//
//  ClientTableViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 02.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class ClientTableViewController: TemplateCoreDataTVC {
    
    var delegateVC: UIViewController?
    var searchController: UISearchController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if delegateVC == nil {
            animateTableInHeight(tableView)
        }
    }
    
    // MARK: - Methods
    
    func configureView() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        tableView.rowHeight = UITableView.automaticDimension
        
        definesPresentationContext = true
    }
    
    func prepareAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let cansel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cansel)
        
        return alertController
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ClientTableViewCell
        let client = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withObject: client)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let delegateVC = delegateVC as? DelegateViewController {
            delegateVC.selectedValueDelegate(fetchedResultsController.object(at: indexPath))
            dismiss(animated: true, completion: nil)
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
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let client = fetchedResultsController.object(at: indexPath)
        
        let action = UIContextualAction(style: .normal, title: NSLocalizedString("⏰ Action", comment: "")) { (action, view, completionHandler) in
            
            let alertController = self.prepareAlert(title: nil, message: NSLocalizedString("Choose action", comment: ""), preferredStyle: .actionSheet)
            let call = UIAlertAction(title: NSLocalizedString("Call", comment: "") + ": \(client.phone ?? "")", style: .default) { (_) in
                let url = NSURL(string: "tel://\(client.phone!)")! as URL
                if UIApplication.shared.canOpenURL(url)  {
                    UIApplication.shared.open(url)
                } else {
                    let alertControllerFail = self.prepareAlert(title: NSLocalizedString("Fail", comment: ""), message: NSLocalizedString("Function not available", comment: ""), preferredStyle: .alert)
                    self.present(alertControllerFail, animated: true, completion: nil)
                }
            }
            alertController.addAction(call)
            
            let send = UIAlertAction(title: NSLocalizedString("Send", comment: "") + ": \(client.mail ?? "")", style: .default) { (_) in
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([client.mail!])
                    mail.setSubject(NSLocalizedString("Pay the debt", comment: ""))
                    mail.setMessageBody("<p>"+NSLocalizedString("Please pay the debt!", comment: "") + "</p>", isHTML: true)
                    self.present(mail, animated: true)
                } else {
                    let alertControllerFail = self.prepareAlert(title: NSLocalizedString("Fail", comment: ""), message: NSLocalizedString("Function not available", comment: ""), preferredStyle: .alert)
                    self.present(alertControllerFail, animated: true, completion: nil)
                }
            }
            alertController.addAction(send)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let client = fetchedResultsController.object(at: indexPath)
        
        let share = UIContextualAction(style: .normal, title: NSLocalizedString("📧 Share", comment: "")) { (action, view, completionHandler) in
            let defaulText = NSLocalizedString("My client: ", comment: "") + client.name!
            if let image = UIImage(data: client.image! as Data) {
                let activityVC = UIActivityViewController(activityItems: [defaulText, image], applicationActivities: nil)
                self.present(activityVC, animated: true, completion: nil)
            }
        }
        
        let delete = UIContextualAction(style: .normal, title: NSLocalizedString("🗑 Delete", comment: "")) { (action, view, completionHandler) in
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let objectToDelete = self.fetchedResultsController.object(at: indexPath)
                self.managedObjectContext?.delete(objectToDelete)
                appDelegate.saveContext()
            }
        }
        
        return UISwipeActionsConfiguration(actions: [delete, share])
    }
    
    override func configureCell(_ cell: UITableViewCell, withObject object: AnyObject) {
        guard let cell = cell as? ClientTableViewCell else { return }
        guard let object = object as? Client else { return }
        cell.nameLabel.text = object.name
        cell.adressLabel?.text = object.adress
        cell.phoneLabel.text = object.phone
        cell.imageViewCell.image = UIImage(data: object.image!)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        if segue.identifier == "clientDetailSegue" {
            let dvc = segue.destination as? ClientDetailViewController
            dvc?.client = fetchedResultsController.object(at: indexPath)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return delegateVC == nil
    }
        
    @IBAction func unwindToCansel(_ unwindSegue: UIStoryboardSegue) {
    }
            
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Client> {
        
        if _fetchedResultsController != nil { return _fetchedResultsController! }
        
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
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
    
    var _fetchedResultsController: NSFetchedResultsController<Client>? = nil
    
}


extension ClientTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            
            if !searchText.isEmpty {
                let predicate = NSPredicate(format: "name contains[c] %@ OR phone contains[c] %@", argumentArray: [searchText, searchText])
                fetchedResultsController.fetchRequest.predicate = predicate
            } else {
                fetchedResultsController.fetchRequest.predicate = nil
            }
            
            do {
                try fetchedResultsController.performFetch()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
                
        tableView.reloadData()
    }
}

extension ClientTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = false
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
}

extension ClientTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
