//
//  ClientAddTableViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 05.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import CoreData

class ClientAddTableViewController: UITableViewController {
    
    var saveButton: UIBarButtonItem!
        
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var adressField: UITextField!
    @IBOutlet var phoneField: UITextField!
    @IBOutlet var mailField: UITextField!
    
    @IBOutlet var collectionField: [UITextField]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        configureView()
    }
    
    // MARK: - Methods
    
    func configureView() {
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewObject(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        saveButton.isEnabled = false
        
        nameField.addTarget(self, action: #selector(editingChangedName), for: .editingChanged)
        
        for textField in collectionField {
            textField.delegate = self
        }
    }
    
    @objc
    func saveNewObject(_ sender: Any) {
        
        if nameField.text!.isEmpty {
            present(getAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You must fill in the name of the client", comment: "")), animated: true, completion: nil)
            return
        }
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let newClient = Client(context: appDelegate.persistentContainer.viewContext)
            newClient.name = nameField.text
            newClient.adress = adressField.text
            newClient.phone = phoneField.text
            newClient.mail = mailField.text
            if let image = imageView.image {
                newClient.image = image.pngData()
            }
            appDelegate.saveContext()
        }
                
        performSegue(withIdentifier: "unwindToCanselSegue", sender: nil)
    }
    
    @objc
    func editingChangedName() {
        saveButton.isEnabled = nameField.text?.isEmpty == false
    }
    
    func chooseImagePickerAction(sourseType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourseType) {
            let pickerController = UIImagePickerController()
            pickerController.allowsEditing = true
            pickerController.sourceType = sourseType
            pickerController.delegate = self
            present(pickerController, animated: true, completion: nil)
        }
    }
        
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let alertController = getAlertController(title: NSLocalizedString("Choose action", comment: ""), message: nil, style: .actionSheet)
            let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default) { (action) in
                self.chooseImagePickerAction(sourseType: .camera)
            }
            cameraAction.setValue(UIImage(named: "cameraIcon"), forKey: "image")
            cameraAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let libraryAction = UIAlertAction(title: NSLocalizedString("Library", comment: ""), style: .default) { (action) in
                self.chooseImagePickerAction(sourseType: .photoLibrary)
            }
            libraryAction.setValue(UIImage(named: "photoIcon"), forKey: "image")
            libraryAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            alertController.addAction(cameraAction)
            alertController.addAction(libraryAction)
            present(alertController, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.endEditing(true)
    }
}

extension ClientAddTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let originalImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        imageView.image = originalImage
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        dismiss(animated: true, completion: nil)
    }
}

extension ClientAddTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == collectionField.last {
            textField.resignFirstResponder()
        } else {
            if let index = collectionField.firstIndex(of: textField) {
                collectionField[index + 1].becomeFirstResponder()
            }
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        guard textField == mailField else { return true }
        if let text = textField.text {
            return text.isEmail
        }
        return true
    }
}
