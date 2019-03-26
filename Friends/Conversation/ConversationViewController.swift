//
//  ConversationViewController.swift
//  Friends
//
//  Created by Mary Milchenko on 25.02.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var conversationTable: UITableView!
    var msgArray: [Message] = []
    var name: String?
    var id: String?
    var y = 0.0
    
    weak var multipeerCommunicator: MultipeerCommunicator?
    
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var newMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = name

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.conversationTable.addGestureRecognizer(tap)
        
//        msgArray = randomArray()
        newMessage.delegate = self
        
        conversationTable.dataSource = self
        conversationTable.delegate = self
        conversationTable.isScrollEnabled = true
        
        conversationTable.rowHeight = UITableView.automaticDimension
        conversationTable.estimatedRowHeight = 67
        
        let nib = UINib(nibName: "ConversationTableViewCell", bundle: nil)
        conversationTable.register(nib, forCellReuseIdentifier: "Cell")
        let nib2 = UINib(nibName: "ConversationTableViewMyCell", bundle: nil)
        conversationTable.register(nib2, forCellReuseIdentifier: "MyCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataCell), name: Notification.Name.needReloadData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userBecomeOnline), name: Notification.Name.becomeOnline, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userBecomeOffline), name: Notification.Name.becomeOffline, object: nil)
    }

    
    @objc func reloadDataCell() {
        msgArray = MessagesData.getMessages(from: name!)!
        DispatchQueue.main.async {
            self.conversationTable.reloadData()
        }
    }
    
    @objc func userBecomeOffline() {
        DispatchQueue.main.async {
            self.sendButton.isEnabled = false
            self.sendButton.alpha = 0.5
        }
    }
    
    @objc func userBecomeOnline() {
        DispatchQueue.main.async {
            self.sendButton.isEnabled = true
            self.sendButton.alpha = 1
        }
    }
    
    func updateConversations(_ conversations: [Conversation]) {
        for conversation in conversations {
            guard let lastMessage = MessagesData.getMessages(from: conversation.name)?.last else {
                conversation.hasUnreadMessages = false
                continue
            }
            conversation.message = lastMessage.text
            conversation.date = lastMessage.datetime
        }
    }
    
    
    @IBAction func sendMsg(_ sender: UIButton) {
        guard let text = newMessage.text,
            text != "" else { return }
        
        newMessage.text = ""
        
        multipeerCommunicator!.SendMessage(string: text, to: id!) { (true, error) in
            self.showAlert(title: "Error", message: error?.localizedDescription)
        }
        
        let outgoingMessage = Message(text: text, msgId: name!, type: true)
        msgArray.append(outgoingMessage)
        
        self.conversationTable.reloadData()
        
        MessagesData.newMessage(from: name!, message: outgoingMessage)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer) {
        newMessage.resignFirstResponder()
    }
    
   @objc func keyboardWillShow(sender: NSNotification) {
//        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            UIView.animate(withDuration: 0.1, animations: { () -> Void in
//                self.y = Double(self.view.frame.origin.y)
//                self.view.frame.origin.y -= keyboardSize.height - 60
//                self.view.layoutIfNeeded()
//            })
//        }
    }
    
   @objc func keyboardWillHide(sender: NSNotification) {
//        if ((sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
//            UIView.animate(withDuration: 0.1, animations: { () -> Void in
//                self.view.frame.origin.y = CGFloat(self.y)
//                self.view.layoutIfNeeded()
//            })
//        }
    }
    
    func showAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var conversation: Message
        conversation = msgArray[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ConversationTableViewCell
        if conversation.type  {
            cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! ConversationTableViewCell
        }

        cell.configure(
            message: msgArray[indexPath.row].text
        )

        return cell
    }

 
    
}
