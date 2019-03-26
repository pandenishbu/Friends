//
//  StorageManager.swift
//  Friends
//
//  Created by Mary Milchenko on 26.03.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import Foundation

protocol StorageDataManagerDelegate {

    func showAlert(title: String, message: String?)
    func endSaving()
    func startSaving()
}

class StorageDataManager {

    var delegate: StorageDataManagerDelegate?
    
    func save(name: String?, descr: String?, photo: UIImage?) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let saveContext = CoreDataStack.shared.getContext(.save) else {
                self.delegate?.showAlert(title: "Упс", message: "Ошибка контекста")
                return
            }
            
            guard let userData = User.findUserData(in: saveContext) else {
                self.delegate?.showAlert(title: "Упс", message: "Не удалось сохранить профиль")
                return
            }
            
            DispatchQueue.main.async {
                self.delegate?.startSaving()
            }
            saveContext.perform {
                if userData.name != name {
                    userData.name = name
                }
                if userData.descr != descr {
                    userData.descr = descr
                }
                let newImage = photo!.pngData()
                if userData.photo != newImage {
                    userData.photo = newImage
                }
                if saveContext.hasChanges {
                    CoreDataStack.shared.perfomSave(context: saveContext) {
                        DispatchQueue.main.async {
                            self.delegate?.showAlert(title: "Ура:)", message: "Профиль успешно сохранен")
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.delegate?.endSaving()
            }
        }
    }
    
    // MARK: - Data Loading
    
    func load() -> (String?, String?, UIImage?)? {
        guard let mainContext = CoreDataStack.shared.getContext(.main) else {
            self.delegate?.showAlert(title: "Упс", message: "Ошибка контекста")
            return nil
        }

        let userData = User.findUserData(in: mainContext)
        var photo: UIImage?
        if let newImage = userData?.photo {
            photo = UIImage(data: newImage)
        }
        
        let user = (name: userData?.name, descr: userData?.descr, photo: photo)
        
        return user
    }
    
    
}
