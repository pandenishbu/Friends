//
//  MessageData.swift
//  Friends
//
//  Created by Mary Milchenko on 19.03.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import Foundation

class MessagesData {

    static private var messages = [String: [Message]]()

    static func getMessages(from userName: String) -> [Message]? {
        let messagesDict = MessagesData.messages as NSDictionary
        let messages = messagesDict.value(forKey: userName) as? [Message]

        return messages
    }

    static func newMessage(from userName: String, message: Message) {
        if MessagesData.getMessages(from: userName) != nil {
            MessagesData.messages[userName]?.append(message)
        } else {
            MessagesData.messages[userName] = [message]
        }
    }
}
