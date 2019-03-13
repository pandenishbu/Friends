//
//  EditProfileViewController.swift
//  Friends
//
//  Created by Mary Milchenko on 13.03.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


class EditProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var aboutTextView: UITextView!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var editPhotoButton: UIButton!
    @IBOutlet var photoView: UIImageView!
    @IBOutlet var GCD: UIButton!
    @IBOutlet var operation: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var isName = false
    var isDescr = false
    var isPhoto = false
    var y = 0.0
    
    let imagePickerController = UIImagePickerController()
    var GCDModel: GCDDataManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        nameTextField.delegate = self
        aboutTextView.delegate = self
        
        nameTextField.text = GCDModel.name
        aboutTextView.text = GCDModel.description
            
        self.imagePickerController.allowsEditing = true
        self.imagePickerController.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.GCD.isEnabled = false
        self.operation.isEnabled = false
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (self.nameTextField.text != GCDModel.name){
            isName = true
            self.GCD.isEnabled = true
            self.operation.isEnabled = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (self.aboutTextView.text != GCDModel.description){
            isDescr = true
            self.GCD.isEnabled = true
            self.operation.isEnabled = true
        }
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.y = Double(self.view.frame.origin.y)
                self.view.frame.origin.y -= keyboardSize.height - 60
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        if ((sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y = CGFloat(self.y)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func changePhoto(_ sender: UIButton) {
        print("Выбери изображение профиля")
        addPhotoSheet()
    }
    

    @IBAction func saveByGCD(_ sender: UIButton) {
        self.activityIndicator.startAnimating()
        self.GCD.isEnabled = false
        self.operation.isEnabled = false
        GCDModel.save(type: "name") {result in
            if result {
                
            }
            else {
                
            }
            isName = false
            isPhoto = false
            isDescr = false
        }
        
    }
    
    @IBAction func saveByOperation(_ sender: UIButton) {
        self.activityIndicator.startAnimating()
        self.GCD.isEnabled = false
        self.operation.isEnabled = false
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
            photoView.image = img
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            photoView.image = img
        }
        
        picker.dismiss(animated: true, completion: nil)
        isPhoto = true
        self.GCD.isEnabled = true
        self.operation.isEnabled = true
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
