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

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var editButton: DesignableButton!
    @IBOutlet weak var photoButton: DesignableButton!
    let imagePickerController = UIImagePickerController()
    
    let log = Log()
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //print(editButton.frame)
        log.VCLogger(message: "Unexpectedly found nil while unwrapping an Optional value")
        //Кнопка "Регистрация" еще не инициализирована
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePickerController.allowsEditing = true
        self.imagePickerController.delegate = self
        
        log.VCLogger(message: " frame:  \(String(describing: editButton?.frame)) ")
        //Frame кнопки из .storyboard
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        log.VCLogger(message: " frame:  \(String(describing: editButton?.frame)) ")
        //Frame кнопки уже непосредственно устройства, тк метод viewDidAppear вызывается, когда ViewController уже появился на экране после метода LayoutSubViews
    }
    
    @IBAction func GoBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func AddPhoto(_ sender: UIButton) {
        print("Выбери изображение профиля")
        addPhotoSheet()
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
            avatarImg.image = img
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
             avatarImg.image = img
        }
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
