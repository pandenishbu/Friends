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
    var heigh = 0.0
    var conversation: Conversation!

    weak var multipeerCommunicator: MultipeerCommunicator?

    @IBOutlet var sendButton: UIButton!
    @IBOutlet var newMessage: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        label.textAlignment = .center
        label.text = conversation.name

        self.navigationItem.titleView = label

        let origImage = UIImage(named: "next")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        sendButton.setImage(tintedImage, for: .normal)

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.conversationTable.addGestureRecognizer(tap)

        newMessage.delegate = self
        newMessage.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        conversationTable.dataSource = self
        conversationTable.delegate = self
        conversationTable.isScrollEnabled = true

        conversationTable.rowHeight = UITableView.automaticDimension
        conversationTable.estimatedRowHeight = 67

        let nib = UINib(nibName: "ConversationTableViewCell", bundle: nil)
        conversationTable.register(nib, forCellReuseIdentifier: "Cell")
        let nib2 = UINib(nibName: "ConversationTableViewMyCell", bundle: nil)
        conversationTable.register(nib2, forCellReuseIdentifier: "MyCell")

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadDataCell),
                                               name: Notification.Name.needReloadData,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userBecomeOnline),
                                               name: Notification.Name.becomeOnline,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userBecomeOffline),
                                               name: Notification.Name.becomeOffline,
                                               object: nil)
        reloadDataCell()
        if conversation.online {
            userBecomeOnline()
        }

    }

    @objc func reloadDataCell() {
        msgArray = MessagesData.getMessages(from: conversation.name) ?? []
        DispatchQueue.main.async {
            self.conversationTable.reloadData()
        }
    }

    @objc func userBecomeOffline() {
        DispatchQueue.main.async {
            Animation.animateButton(button: self.sendButton, isEnable: false)
            if let label = self.navigationItem.titleView {
                Animation.animateTitle(label: (label as? UILabel)!, isOnline: false)
            }
        }
    }

    @objc func userBecomeOnline() {
        DispatchQueue.main.async {
            if self.newMessage.text != "" {
                Animation.animateButton(button: self.sendButton, isEnable: true)
            } else {
                Animation.animateButton(button: self.sendButton, isEnable: false)
            }
            if let label = self.navigationItem.titleView {
                Animation.animateTitle(label: (label as? UILabel)!, isOnline: true)
            }
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

        multipeerCommunicator!.sendMessage(string: text, to: conversation.peerId) { (_, error) in
                self.showAlert(title: "Error", message: error?.localizedDescription)
        }
        let outgoingMessage = Message(text: text, msgId: conversation.name, type: true)
        msgArray.append(outgoingMessage)

        self.conversationTable.reloadData()

        MessagesData.newMessage(from: conversation.name, message: outgoingMessage)
        Animation.animateButton(button: self.sendButton, isEnable: false)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == self.newMessage {
            if textField.text != "" && (!self.sendButton.isEnabled) {
                Animation.animateButton(button: self.sendButton, isEnable: true)
            } else if textField.text == "" && (self.sendButton.isEnabled) {
                Animation.animateButton(button: self.sendButton, isEnable: false)
            }
        }
    }

    @objc func hideKeyboard(_ sender: UITapGestureRecognizer) {
        newMessage.resignFirstResponder()
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
        guard var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ConversationTableViewCell else {
            fatalError("DequeueReusableCell failed while casting")
        }
        if conversation.type {
            cell = (tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as? ConversationTableViewCell)!
        }

        cell.configure(
            message: msgArray[indexPath.row].text
        )

        return cell
    }

}
