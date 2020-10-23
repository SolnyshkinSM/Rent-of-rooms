//
//  RoomTableViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 06.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import CoreData

class RoomTableViewController: TemplateCoreDataTVC {
    
    let cellIdentifier = "Cell"
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
        tableView.register(UINib(nibName: "RoomTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc
    func insertNewObject(_ sender: Any) {
        guard let roomAddVC = storyboard?.instantiateViewController(identifier: "RoomAddViewController") else { return }
        roomAddVC.modalPresentationStyle = .fullScreen
        present(roomAddVC, animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! RoomTableViewCell
        let room = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withObject: room)
        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let delegateVC = delegateVC as? DelegateViewController {
            delegateVC.selectedValueDelegate(fetchedResultsController.object(at: indexPath))
            dismiss(animated: true, completion: nil)
        }
        
        if let roomAddVC = storyboard?.instantiateViewController(identifier: "RoomAddViewController") as? RoomAddViewController {
            roomAddVC.modalPresentationStyle = .fullScreen
            roomAddVC.room = fetchedResultsController.object(at: indexPath)
            present(roomAddVC, animated: true, completion: nil)
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
        guard let cell = cell as? RoomTableViewCell else { return }
        guard let object = object as? Room else { return }
        cell.textLabelRoom.text = object.name
        cell.detailTextLabelRoom.text = object.adress
        cell.imageViewRoom.image = UIImage(data: object.image!)
    }
        
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Room> {
        
        if _fetchedResultsController != nil { return _fetchedResultsController! }
        
        let fetchRequest: NSFetchRequest<Room> = Room.fetchRequest()
        fetchRequest.fetchBatchSize = 20

        fetchRequest.predicate = predicate != nil ? predicate : nil
        
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
    
    var _fetchedResultsController: NSFetchedResultsController<Room>? = nil
        
}
