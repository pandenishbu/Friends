//
//  ProfileViewController.swift
//  Friends
//
//  Created by Mary Milchenko on 17.02.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate {

    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var editButton: DesignableButton!
    @IBOutlet var photo: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var descr: UILabel!
    
    
    let log = Log()
    var GCDData = GCDDataManager(name: "Александр Федоров", photo: "", description: "👨‍💻Люблю программировать под iOS 👨‍🎓Изучать новые технологии  👨‍🏫Помогаю развиваться другим")
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //print(editButton.frame)
//        log.VCLogger(message: "Unexpectedly found nil while unwrapping an Optional value")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        log.VCLogger(message: " frame:  \(String(describing: editButton?.frame)) ")
        
        GCDData.load(completionHandler: {txt1, txt2, txt3 in
            DispatchQueue.main.async {
                self.name.text = txt1
                self.descr.text = txt3
                let decodedData = NSData(base64Encoded: txt2, options: NSData.Base64DecodingOptions(rawValue: 0) )
                let decodedimage = UIImage(data: decodedData! as Data)
                self.avatarImg.image = decodedimage
            }
        })
        
    }
    
    
    @IBAction func GoBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EditProfileViewController{
            let vc = segue.destination as? EditProfileViewController
            vc?.GCDModel = GCDData
        }
    }
    

}
