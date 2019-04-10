//
//  ConversationConfiguration.swift
//  Friends
//
//  Created by Mary Milchenko on 19.03.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import Foundation

protocol ConversationsCellConfiguration: class {
    var name: String {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessages: Bool {get set}
    var peerId: String {get set}
}

class Conversation: ConversationsCellConfiguration {
    var name: String
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool
    var peerId: String

    init(name: String, message: String?, date: Date?, online: Bool, hasUnreadMessages: Bool, peerId: String) {
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
        self.peerId = peerId
    }
}
