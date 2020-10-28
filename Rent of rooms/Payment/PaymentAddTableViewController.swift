//
//  PaymentAddTableViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 08.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit

class PaymentAddTableViewController: UITableViewController, DelegateViewController {
    
    var payment: Payment?
    var contract: Contract?
    var client: Client?
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBOutlet var dateField: UITextField!
    @IBOutlet var contractField: UITextField!
    @IBOutlet var clientField: UITextField!
    @IBOutlet var typeSegmented: UISegmentedControl!
    @IBOutlet var sumField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        editingChangedContract()
    }
    
    // MARK: - Methods
    
    func configureView() {
        
        saveButton.isEnabled = false
                
        tableView.tableFooterView = UIView(frame: .zero)
        
        dateField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        
        contractField.delegate = self
        clientField.delegate = self
        sumField.delegate = self
        
        if let payment = payment {
            contract = payment.contract
            client = payment.client
            
            dateField.text = getDateFormatter().string(from: payment.date!)
            contractField.text = (payment.contract?.number)! + NSLocalizedString(" from ", comment: "") + getDateFormatter().string(from: (payment.contract?.date!)!)
            clientField.text = payment.client?.name
            typeSegmented.selectedSegmentIndex = Int(payment.type)
            sumField.text = getNumberFormatter().string(from: payment.sum as NSNumber)
        } else {
            dateField.text = getDateFormatter().string(from: Date())
        }
    }
    
    @objc
    func tapDone() {
        if let datePicker = dateField.inputView as? UIDatePicker {
            dateField.text = getDateFormatter().string(from: datePicker.date)
        }
        dateField.resignFirstResponder()
    }
    
    func selectedValueDelegate(_ value: AnyObject) {
        if let value = value as? Contract {
            contract = value
            contractField.text = value.number! + NSLocalizedString(" from ", comment: "") + getDateFormatter().string(from: value.date!)
            client = value.client
            clientField.text = client?.name
            sumField.text = getNumberFormatter().string(from: value.price as NSNumber)
            editingChangedContract()
        } else if let value = value as? Client {
            client = value
            clientField.text = value.name
        }
    }
    
    @objc
    func editingChangedContract() {
        saveButton.isEnabled = contractField.text?.isEmpty == false
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func saveActions(_ sender: UIBarButtonItem) {
        
        if contractField.text!.isEmpty {
            present(getAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You must specify the contract", comment: "")), animated: true, completion: nil)
            return
        }
        
        if clientField.text!.isEmpty {
            present(getAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You must specify the client", comment: "")), animated: true, completion: nil)
            return
        }
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let newPayment = payment != nil ? payment! : Payment(context: appDelegate.persistentContainer.viewContext)
            newPayment.contract = contract
            newPayment.client = client
            newPayment.type = Int16(typeSegmented.selectedSegmentIndex)
            if let date = getDateFormatter().date(from: dateField.text!) {
                newPayment.date = date
            }
            if let sum = getNumberFormatter().number(from: sumField.text!) {
                newPayment.sum = sum as! Double
            }
            appDelegate.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }
}

extension PaymentAddTableViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return true }
        let context = appDelegate.persistentContainer.viewContext
        
        if textField == contractField {
            if let contractVC = storyboard?.instantiateViewController(identifier: "ContractTableViewController") as? ContractTableViewController {
                contractVC.delegateVC = self
                contractVC.managedObjectContext = context
                present(contractVC, animated: true, completion: nil)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == sumField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == sumField {
            if let sum = getNumberFormatter().number(from: textField.text!) {
                textField.text = getNumberFormatter().string(from: sum as NSNumber)
            }
        }
    }
}
