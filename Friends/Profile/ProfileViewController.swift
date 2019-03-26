//
//  ProfileViewController.swift
//  Friends
//
//  Created by Mary Milchenko on 17.02.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var editButton: DesignableButton!
    @IBOutlet var saveButton: DesignableButton!
    @IBOutlet var photo: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var editPhoto: UIButton!
    @IBOutlet var name: UITextField!
    @IBOutlet var descr: UITextField!
    

    let imagePickerController = UIImagePickerController()
    var profile : UserDataModel?
    var user: (String?, String?, UIImage?)
    let storageDataManager = StorageDataManager()
    var y = 0.0
    
    var editingMode: Bool = false {
        didSet {
            self.setMode(editing: editingMode)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        name.delegate = self
        descr.delegate = self
        descr.borderStyle = UITextField.BorderStyle.roundedRect
        
        self.imagePickerController.allowsEditing = true
        self.imagePickerController.delegate = self

        storageDataManager.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.editingMode = false
        self.saveButton.isEnabled = false
        self.loadData()        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    
    @IBAction func GoBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chanePhoto(_ sender: UIButton) {
        addPhotoSheet()
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
         self.editingMode = true
    }
    
    @IBAction func saveProfile(_ sender: UIButton) {
        self.storageDataManager.save(name: self.name.text, descr: self.descr.text, photo: self.photo.image!)
        
    }
    
    
    func loadData() {
        user = storageDataManager.load()!
        
        self.photo.image = user.2 ?? UIImage.init(named: "placeholder-user")
        self.name.text = user.0
        self.descr.text = user.1
        
    }
    
 
    func setMode(editing: Bool) {
        self.editButton.isHidden = editing
        self.saveButton.isHidden = !editing
        
        self.name.isEnabled = editing
        self.descr.isEnabled = editing
    }
    
    
    func addPhotoSheet(){
        let actionSheet = UIAlertController.init(title: "Выбери изображение профиля", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "Сделать фото", style: UIAlertAction.Style.default, handler: {
            (action) in
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .denied:
                print("Denied, request permission from settings")
                self.presentCameraSettings()
            case .restricted:
                print("Restricted, device owner must approve")
            case .authorized:
                self.openCamera()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { success in
                    if success {
                        self.openCamera()
                    }
                }
            }
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Установить из галлереи", style: UIAlertAction.Style.default, handler: {
            (action) in
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                self.openPhotoLibrary()
            case .denied, .restricted :
                print("Denied, request permission from settings")
                self.presentCameraSettings()
            case .notDetermined:
                // ask for permissions
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        self.openPhotoLibrary()
                    }
                    else {
                        self.presentCameraSettings()
                    }
                }
            }
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Отмена", style: UIAlertAction.Style.cancel, handler: { (action) in
            
        }))
        //Present the controller
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func openCamera(){
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func openPhotoLibrary() {
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            photo.image = img
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            photo.image = img
        }
        self.saveButton.isEnabled = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Ошибка",
                                                message: "Доступ к камере/галерее запрещен",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Отменить", style: .default))
        alertController.addAction(UIAlertAction(title: "Настройки", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })
        
        present(alertController, animated: true)
    }
    

}

extension ProfileViewController: UITextFieldDelegate, UITextViewDelegate{
    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            self.y = Double(self.view.frame.origin.y)
            self.view.frame.origin.y -= keyboardFrame.cgRectValue.height - 60
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        if (self.name.text != user.0 || self.descr.text != user.1){
            self.saveButton.isEnabled = true
        }
        else {
            self.saveButton.isEnabled = false
        }
        self.view.frame.origin.y = CGFloat(self.y)
    }
  
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 100
    }
    
}

extension ProfileViewController: StorageDataManagerDelegate{
    
    func endSaving() {
        self.activityIndicator.stopAnimating()
        self.view.alpha = 1
        self.view.isUserInteractionEnabled = true
        self.editingMode = false
    }
    
    func startSaving() {
        self.activityIndicator.startAnimating()
        self.view.alpha = 0.5
        self.view.isUserInteractionEnabled = false
        self.saveButton.isEnabled = false
    }
    
    func showAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
