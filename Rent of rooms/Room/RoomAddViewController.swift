//
//  RoomAddViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 06.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit

class RoomAddViewController: UIViewController {

    var room: Room?
    var pickerView = UIPickerView()
    var areaList: [String] = []
    
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var adressField: UITextField!
    @IBOutlet var areaField: UITextField!
    @IBOutlet var collectionField: [UITextField]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Methods
    
    func configureView() {
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        areaField.inputView = pickerView
        for index in 1...100 {
            areaList.append(String(Double(index)))
        }
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(dismissKeyboard))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        areaField.inputAccessoryView = toolBar
        
        for textField in collectionField {
            textField.delegate = self
        }
        
        if let room = room {
            nameField.text = room.name
            adressField.text = room.adress
            areaField.text = String(room.area)
            imageView.image = UIImage(data: room.image!)
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @IBAction func saveAction(_ sender: UIButton) {
        
        if nameField.text!.isEmpty {
            present(getAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You must fill in the name of the room", comment: "")), animated: true, completion: nil)
            return
        }
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let newRoom = room != nil ? room! : Room(context: appDelegate.persistentContainer.viewContext)
            newRoom.name = nameField.text
            newRoom.adress = adressField.text
            newRoom.free = room != nil ? room!.free : true
            if let area = Double(areaField.text!) {
                newRoom.area = area
            }
            if let image = imageView.image {
                newRoom.image = image.pngData()
            }
            appDelegate.saveContext()
        }
                
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func canselAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
    
    // MARK: - UIResponder
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
        
    // MARK: - Actions
    
    @IBAction func addImageAction(_ sender: UIButton) {
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
    
}

extension RoomAddViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        areaList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return areaList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        areaField.text = areaList[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerViewLabel = UILabel()
        
        if let currentLabel = view as? UILabel {
            pickerViewLabel = currentLabel
        }
        
        pickerViewLabel.textColor = .white
        pickerViewLabel.textAlignment = .center
        pickerViewLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 23)
        pickerViewLabel.text = areaList[row]
        
        return pickerViewLabel
    }
    
}

extension RoomAddViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let originalImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        imageView.image = originalImage
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        dismiss(animated: true, completion: nil)
    }
}

extension RoomAddViewController: UITextFieldDelegate {
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text {
            let firstDot = text.firstIndex(of: ".") ?? text.endIndex
            let firstNumber = text[..<firstDot].description
            if let index = Int(firstNumber) {
                pickerView.selectRow(index - 1, inComponent: 0, animated: true)
            }
        }
    }
}
