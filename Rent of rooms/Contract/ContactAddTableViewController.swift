//
//  ContactAddTableViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 07.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import CoreData

class ContactAddTableViewController: UITableViewController, DelegateViewController {
        
    var pickerView = UIPickerView()
    var contract: Contract?
    var room: Room?
    var client: Client?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var numberField: UITextField!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var roomField: UITextField!
    @IBOutlet var clientField: UITextField!
    @IBOutlet var priceField: UITextField!
    @IBOutlet var startDateField: UITextField!
    @IBOutlet var endDateField: UITextField!
    @IBOutlet var timeRentSegmented: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Methods
    
    func configureView() {
        
        tableView.tableFooterView = UIView(frame: .zero)
                
        dateField.setInputViewDatePicker(target: self, selector: #selector(tapDoneDate))
        startDateField.setInputViewDatePicker(target: self, selector: #selector(tapDoneStartDate))
        endDateField.setInputViewDatePicker(target: self, selector: #selector(tapDoneEndDate))
        
        roomField.delegate = self
        clientField.delegate = self
        priceField.delegate = self
        
        if let contract = contract {
            room = contract.room
            client = contract.client
            
            numberField.text = contract.number
            dateField.text = getDateFormatter().string(from: contract.date!)
            startDateField.text = getDateFormatter().string(from: contract.startDate!)
            endDateField.text = getDateFormatter().string(from: contract.endDate!)
            roomField.text = contract.room?.name
            clientField.text = contract.client?.name
            timeRentSegmented.selectedSegmentIndex = Int(contract.timeRent)
            priceField.text = getNumberFormatter().string(from: contract.price as NSNumber)
        } else {
            numberField.text = getRelevantNumber()
            dateField.text = getDateFormatter().string(from: Date())
            startDateField.text = getDateFormatter().string(from: Date())
            endDateField.text = getDateFormatter().string(from: Date(timeIntervalSinceNow: 31_536_000))
        }
    }
    
    @objc
    func tapDoneDate() {
        tapDone(dateField)
    }
    
    @objc
    func tapDoneStartDate() {
        tapDone(startDateField)
    }
    
    @objc
    func tapDoneEndDate() {
        tapDone(endDateField)
    }
    
    func tapDone(_ sender: UITextField) {
        if let datePicker = sender.inputView as? UIDatePicker {
            sender.text = getDateFormatter().string(from: datePicker.date)
        }
        sender.resignFirstResponder()
    }
    
    func getRelevantNumber() -> String {
        
        let lengthNumber = 6
        var relevantNumber = ""
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Contract> = Contract.fetchRequest()
            
            do {
                let count = try context.count(for: fetchRequest)
                let countItemString = String(Int(count) + 1)
                while relevantNumber.count < lengthNumber - countItemString.count {
                    relevantNumber = "0" + relevantNumber
                }
                relevantNumber += countItemString
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        return relevantNumber
    }
    
    func selectedValueDelegate(_ value: AnyObject) {
        if let value = value as? Room {
            room = value
            roomField.text = value.name
        } else if let value = value as? Client {
            client = value
            clientField.text = value.name
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        if roomField.text!.isEmpty {
            present(getAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You must specify the room", comment: "")), animated: true, completion: nil)
            return
        }
        
        if clientField.text!.isEmpty {
            present(getAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You must specify the client", comment: "")), animated: true, completion: nil)
            return
        }
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let newContact = contract != nil ? contract! : Contract(context: appDelegate.persistentContainer.viewContext)
            newContact.number = numberField.text
            newContact.date = getDateFormatter().date(from: dateField.text!)
            newContact.startDate = getDateFormatter().date(from: startDateField.text!)
            newContact.endDate = getDateFormatter().date(from: endDateField.text!)
            newContact.room = room
            newContact.client = client
            newContact.timeRent = Int16(timeRentSegmented.selectedSegmentIndex)
            if let price = getNumberFormatter().number(from: priceField.text!) {
                newContact.price = price as! Double
            }
            room?.free = false
            appDelegate.saveContext()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func canselButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension ContactAddTableViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return true }
        let context = appDelegate.persistentContainer.viewContext
        
        if textField == roomField {
            if let roomVC = storyboard?.instantiateViewController(identifier: "RoomTableViewController") as? RoomTableViewController {
                roomVC.delegateVC = self
                roomVC.managedObjectContext = context
                present(roomVC, animated: true, completion: nil)                
                return false
            }
        } else if textField == clientField {
            if let clientVC = storyboard?.instantiateViewController(identifier: "ClientTableViewController") as? ClientTableViewController {
                clientVC.delegateVC = self
                clientVC.managedObjectContext = context
                present(clientVC, animated: true, completion: nil)
                return false
            }
        }        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == priceField {
            if let number = getNumberFormatter().number(from: textField.text!) {
                textField.text = getNumberFormatter().string(from: number as NSNumber)
            }
        }
    }
}
