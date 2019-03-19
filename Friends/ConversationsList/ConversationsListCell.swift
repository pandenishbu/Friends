//
//  ConversationsListCell.swift
//  Friends
//
//  Created by Mary Milchenko on 25.02.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import UIKit


class ConversationsListCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var msgLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    private var dateF: Date?
    private var isUnrMsg: Bool = false
    private var isOnline: Bool = false
    private var peer: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(
        name: String,
        message: String?,
        date: Date?,
        online: Bool,
        hasUnreadMessages: Bool,
        peerId: String){
        self.name = name
        self.message = message
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
        self.date = date
        self.peer = peerId
    }
}

extension ConversationsListCell: ConversationsCellConfiguration {
    
    var peerId: String {
        get {
            return self.peer!
        }
        set {
            self.peer = newValue
        }
    }
    

    var name: String {
        get {
            return self.nameLabel.text!
        }
        set {
            self.nameLabel.text = newValue
        }
    }
    var message: String? {
        get {
            return self.msgLabel.text
        }
        set {
            if let textValue = newValue {
                self.msgLabel.text = textValue
                self.msgLabel.font = UIFont.systemFont(ofSize: self.msgLabel.font.pointSize)
            } else {
                self.msgLabel.text = "No message yet"
                self.msgLabel.font = UIFont.italicSystemFont(ofSize: self.msgLabel.font.pointSize)
            }
        }
    }
    var date: Date? {
        get {
            return self.dateF
        }
        set {
            if let date = newValue {
                self.dateF = date
                let calendar = Calendar.current
                let dateFormatter = DateFormatter()
                if calendar.isDateInToday(date) {
                    dateFormatter.dateFormat = "HH:mm"
                }
                else {
                    dateFormatter.dateFormat = "dd MMM"
                }
                self.dateLabel.text = dateFormatter.string(from: date)
                self.dateLabel.isHidden = false
            } else {
                self.dateLabel.isHidden = true
            }
        }
    }
    
    var online: Bool {
        get {
            return self.isOnline
        }
        set {
            self.isOnline = newValue
            if newValue {
                self.backgroundColor = UIColor(red: 255/255, green: 253/255, blue: 209/255, alpha: 1)
            } else {
                self.backgroundColor = UIColor.white
            }
        }
    }
    
    var hasUnreadMessages: Bool {
        get {
            return self.isUnrMsg
        }
        set {
            self.isUnrMsg = newValue
            if newValue {
                self.msgLabel.font = UIFont.boldSystemFont(ofSize: self.msgLabel.font.pointSize)
                self.msgLabel.textColor = UIColor.black
            } else {
                self.msgLabel.font = UIFont.systemFont(ofSize: self.msgLabel.font.pointSize)
                self.msgLabel.textColor = UIColor.darkGray
            }
        }
    }

    
}



