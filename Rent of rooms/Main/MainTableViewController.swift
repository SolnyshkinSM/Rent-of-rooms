//
//  MainTableViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 09.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import CoreData
import ClassKit

class MainTableViewController: UITableViewController, ManagedObjectContext {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var debtContracts = [String]()
    var collectionView: UICollectionView!
    
    @IBOutlet var totalSumLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!    
    @IBOutlet var debtClientLabel: UILabel!
    @IBOutlet var collectionTableViewCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCollectionView()
        animateTableView()
    }
    
    // MARK: - Methods
    
    func configureView() {
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        reloadViewData()
        
        //refreshControl
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = .white
        refreshControl?.tintColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        refreshControl?.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
    }
    
    func animateTableView() {
        
        let cells = tableView.visibleCells
        cells.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 1) {
            cells.forEach { $0.alpha = 1 }
        }
    }
    
    func configureCollectionView() {
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if !collectionFeedResult.isEmpty {
                self.collectionView.reloadData()
            }
        }
        
        
        let layot = UICollectionViewFlowLayout()
        layot.itemSize = CGSize(width: 80, height: 80)
        layot.scrollDirection = .horizontal
        layot.minimumLineSpacing = 4
        
        let inset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        layot.sectionInset = inset
        
        collectionView = UICollectionView(frame: collectionTableViewCell.bounds, collectionViewLayout: layot)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellCollection")
        collectionView.backgroundColor = .white
        collectionTableViewCell.addSubview(collectionView)
        
    }
    
    func reloadViewData() {
        writeInTotalSum()
        writeInQuantity()
        writeInDebtClient()
    }
    
    func writeInTotalSum() {
        
        let expression = NSExpressionDescription()
        expression.expression =  NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "sum")])
        expression.name = "totalSum";
        expression.expressionResultType = .doubleAttributeType
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Payment.fetchRequest()
        fetchRequest.propertiesToFetch = [expression]
        fetchRequest.resultType = .dictionaryResultType

        do {
            let results = try managedObjectContext!.fetch(fetchRequest)
            let resultMap = results[0] as! [String:Double]
            if let totalSum = resultMap["totalSum"] {
                totalSumLabel.text = getNumberFormatter().string(from: totalSum as NSNumber)
            }
        } catch let error as NSError {
            NSLog(error.localizedDescription)
        }
    }
    
    func writeInQuantity() {
        
        let fetchRequestRoom: NSFetchRequest<Room> = Room.fetchRequest()
        let fetchRequestContract: NSFetchRequest<Contract> = Contract.fetchRequest()
        
        do {
            let countRoom = try managedObjectContext!.count(for: fetchRequestRoom)
            let countContract = try managedObjectContext!.count(for: fetchRequestContract)
            let totalQuantity = countRoom - countContract
            quantityLabel.text = getNumberFormatter().string(from: totalQuantity as NSNumber)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func writeInDebtClient() {
        
        let totalSumContract = getTotalSumContract()
        let totalSumPaymentOfMonth = getTotalSumPaymentOfMonth()
        let totalSum = totalSumContract - totalSumPaymentOfMonth
        
        debtClientLabel.text = getNumberFormatter().string(from: totalSum as NSNumber)
        
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Contract.fetchRequest()
        fetchRequest.fetchLimit = 1
        do {
            let results = try managedObjectContext!.fetch(fetchRequest)
            if !results.isEmpty {
                let contract = results[0] as! Contract
                debtContracts.append(contract.number!)
            }
        } catch let error as NSError {
            NSLog(error.localizedDescription)
        }
        
    }
    
    func getTotalSumContract() -> Double {
        
        var totalSumContract = 0.0
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Contract.fetchRequest()

        let predicate = NSPredicate(format: "price > %@", 0 as NSNumber)
        fetchRequest.predicate = predicate

        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.expression = NSExpression(format: "sum:(price)")
        sumExpressionDescription.name = "totalPrice"
        sumExpressionDescription.expressionResultType = .doubleAttributeType

        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = [sumExpressionDescription]

        do {
            let results = try managedObjectContext!.fetch(fetchRequest) as [Any]
            if !results.isEmpty {
                let dict = results[0] as? NSDictionary
                totalSumContract = dict!["totalPrice"] as! Double
            }
        } catch let error as NSError {
            NSLog(error.localizedDescription)
        }
        
        return totalSumContract
    }
    
    func getTotalSumPaymentOfMonth() -> Double {
        
        var totalSumPaymentOfMonth = 0.0
        
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month], from: Date())
        let startOfMonth = calendar.date(from: currentDateComponents)!
        
        
        let expression = NSExpressionDescription()
        expression.expression =  NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "sum")])
        expression.name = "totalSum";
        expression.expressionResultType = .doubleAttributeType
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Payment.fetchRequest()
        fetchRequest.propertiesToFetch = [expression]
        fetchRequest.resultType = .dictionaryResultType

        let predicate = NSPredicate(format: "date >= %@", startOfMonth as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let results = try managedObjectContext!.fetch(fetchRequest) as [Any]
            if !results.isEmpty {
                let resultMap = results[0] as! [String:Double]
                totalSumPaymentOfMonth = resultMap["totalSum"]!
            }
        } catch let error as NSError {
            NSLog(error.localizedDescription)
        }
        
        return totalSumPaymentOfMonth
    }
        
    @objc
    func refreshTableView() {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
            self.reloadViewData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.reuseIdentifier == "FreeRoomCell" {
            let roomTableViewController = storyboard?.instantiateViewController(identifier: "RoomTableViewController") as! RoomTableViewController
            roomTableViewController.managedObjectContext = managedObjectContext
            roomTableViewController.predicate = NSPredicate(format: "free == true", true)
            present(roomTableViewController, animated: true, completion: nil)
        } else if cell.reuseIdentifier == "DebtClientCell" {
            let contractTableViewController = storyboard?.instantiateViewController(identifier: "ContractTableViewController") as! ContractTableViewController
            contractTableViewController.managedObjectContext = managedObjectContext
            if !debtContracts.isEmpty {
                contractTableViewController.predicate = NSPredicate(format: "number in %@", debtContracts)
            }
            present(contractTableViewController, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionFeedResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCollection", for: indexPath)
        
        let feedResult = collectionFeedResult[indexPath.row]
        let imageView = UIImageView(frame: cell.bounds)
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        cell.removeFromSuperview()
        cell.addSubview(imageView)
        
        
        //cach
        if let image = cacheImage.object(forKey: feedResult) {
            imageView.image = UIImage(data: image as! Data)
            return cell
        }
        
        //load image
        DispatchQueue.main.async {
            if let imageUrl = URL(string: feedResult.artworkUrl100) {
                let imageData = try? Data(contentsOf: imageUrl)
                imageView.image = UIImage(data: imageData! as Data)
                cacheImage.setObject(imageData as AnyObject, forKey: feedResult)
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedResult = collectionFeedResult[indexPath.row]
        if let artistUrl = URL(string: feedResult.artistUrl) {
            let webViewController = storyboard?.instantiateViewController(identifier: "WebViewController") as? WebViewController
            webViewController?.hidesBottomBarWhenPushed = true
            webViewController?.url = artistUrl
            show(webViewController!, sender: self)
        }
    }
}
