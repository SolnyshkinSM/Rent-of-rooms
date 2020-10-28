//
//  Date.swift
//  Rent of rooms
//
//  Created by Administrator on 02.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit


extension UIColor {
    /**
    Extension UIColor
    */
    static func randomColor() -> UIColor {
        let red = CGFloat(arc4random() % 256) / 255
        let green = CGFloat(arc4random() % 256) / 255
        let blue = CGFloat(arc4random() % 256) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

extension String {
    /**
    Extension String
    */
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    // TODO: isPhone
    // TODO: isAdress
}

extension UITextField {
    /**
    Extension UITextField
    */
    func setInputViewDatePicker(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth / 2))
        datePicker.datePickerMode = .date
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: true)
        self.inputAccessoryView = toolBar
    }
    
    @objc
    func tapCancel() {
        self.resignFirstResponder()
    }
}

func getCurrentTabBarController() -> UITabBarController? {
       
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    guard let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController") as? UITabBarController else { return nil }
    guard let navigationControllers = tabBarController.viewControllers else { return nil }
        
    for navigationController in navigationControllers {
        guard let navigationController = navigationController as? UINavigationController else { continue }
        guard let topViewController = navigationController.topViewController else { continue }
        
        if var topViewController = topViewController as? ManagedObjectContext {
            topViewController.managedObjectContext = managedObjectContext
        }
    }
    
    navigationControllers.last?.tabBarItem.badgeValue = "1"
    
    return tabBarController
}

func animateTableInHeight(_ tableView: UITableView) {
    animateTable(tableView, translationX: 0, translationY: tableView.bounds.size.height)
}

func animateTableInWidth(_ tableView: UITableView) {
    animateTable(tableView, translationX: tableView.bounds.size.width, translationY: 0)
}

private func animateTable(_ tableView: UITableView, translationX: CGFloat, translationY: CGFloat) {
    
    tableView.reloadData()
    
    let cells = tableView.visibleCells
    
    // move all cells to the bottom of the screen
    for cell in cells {
        cell.transform = CGAffineTransform(translationX: translationX, y: translationY)
    }
    
    // move all cells from bottom to the right place
    var index = 0
    for cell in cells {
      UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
        cell.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
      index += 1
    }
}

func getAlertController(title: String?, message: String? = nil, style: UIAlertController.Style? = nil) -> UIAlertController {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: style ?? .alert)
    let defaultAction = UIAlertAction(title: NSLocalizedString("Cansel", comment: ""), style: .cancel, handler: nil)
    alert.addAction(defaultAction)
    
    return alert
}

func getDateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    return dateFormatter
}

func getNumberFormatter() -> NumberFormatter {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    return numberFormatter
}

/**
Async load image itunes music
*/
func loadImageMusic() {
    let networkDataFetcher: DataFetcher = NetworkDataFetcher()
    let urlMusic = "https://rss.itunes.apple.com/api/v1/us/itunes-music/hot-tracks/all/10/explicit.json"
    DispatchQueue.global(qos: .utility).async {
    networkDataFetcher.fetchGenericJSONData(urlString: urlMusic) { (appGroups: AppGroup?) in
            guard let results = appGroups?.feed.results else { return }
            collectionFeedResult = results
            for feedResult in results {
                guard let imageUrl = URL(string: feedResult.artworkUrl100) else { continue }
                let imageData = try? Data(contentsOf: imageUrl)
                cacheImage.setObject(imageData as AnyObject, forKey: feedResult)
            }
        }
    }
}

/**
 Fill in demo data when you first run the app
 */
func fillInDemoData() {
    
    let userDefaults = UserDefaults.standard
    if userDefaults.bool(forKey: "fillInDemoData") == false {
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            
            DispatchQueue.main.async {
                
                let newRoom = Room(context: context)
                newRoom.name = "Lenin Street, 22"
                newRoom.adress = "Moscow, Lenin Street, 22"
                newRoom.free = false
                newRoom.area = 10
                newRoom.image = UIImage(named: "Plan room")?.pngData()
                
                let newRoomFree = Room(context: context)
                newRoomFree.name = "Plandina Street, 76"
                newRoomFree.adress = "Moscow, Plandina Street, 76"
                newRoomFree.free = true
                newRoomFree.area = 20
                newRoomFree.image = UIImage(named: "Plan room two")?.pngData()
                
                let newClient = Client(context: context)
                newClient.name = "Steve Jobs"
                newClient.adress = "San Francisco, California, USA"
                newClient.phone = "+7-101-212-123-4567"
                newClient.mail = "SteveJobs@gmail.com"
                newClient.image = UIImage(named: "Steve Jobs")?.pngData()
                newClient.rating = 0
                
                appDelegate.saveContext()
                
                let startDate = Date(timeIntervalSinceNow: -86_400)
                let price = 10_000
                
                let newContract = Contract(context: context)
                newContract.room = newRoom
                newContract.client = newClient
                newContract.number = "000001"
                newContract.date = startDate
                newContract.startDate = startDate
                newContract.endDate = Date(timeIntervalSinceNow: 31_536_000)
                newContract.timeRent = 0
                newContract.price = Double(price)
                
                appDelegate.saveContext()
                
                let newPayment = Payment(context: context)
                newPayment.contract = newContract
                newPayment.client = newClient
                newPayment.date = startDate
                newPayment.sum = Double(price >> 2)
                newPayment.type = 0
                
                appDelegate.saveContext()
                
            }
        }
        
        userDefaults.set(true, forKey: "fillInDemoData")
        userDefaults.synchronize()
    }
}
