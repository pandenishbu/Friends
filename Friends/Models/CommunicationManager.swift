//
//  CommunicationManager.swift
//  Friends
//
//  Created by Mary Milchenko on 19.03.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol CommunicatorDelegate: class {
    //discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertaising(error: Error)
    
    //message
    func didReiciveMessage(text: String, fromUser: String, toUser: String)
}


class CommunicationManager : CommunicatorDelegate{
    
    
    var peers: [Peer] = []
    var offlinPeers: [Peer] = []
    var onlineConvs: [Conversation] = []
    var offlineConvs: [Conversation] = []
    
    func didFoundUser(userID: String, userName: String?) {
        offlineConvs.removeAll{$0.name == userID}
        let lastMessage = MessagesData.getMessages(from: userName!)?.last?.text
        let conv = Conversation.init(name: userName!, message: lastMessage, date: nil, online: true, hasUnreadMessages: false, peerId: userID)
        onlineConvs.append(conv)
        NotificationCenter.default.post(name: .becomeOnline, object: nil)
        NotificationCenter.default.post(name: .needReloadData, object: nil)
    }
    
    func didLostUser(userID: String) {
        if let conv = onlineConvs.first(where: {$0.peerId == userID}) {
            offlineConvs.append(conv)
            onlineConvs.removeAll{$0.name == conv.name}
        }
        NotificationCenter.default.post(name: .needReloadData, object: nil)
        NotificationCenter.default.post(name: .becomeOffline, object: nil)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
         print(error.localizedDescription)
    }
    
    func failedToStartAdvertaising(error: Error) {
         print(error.localizedDescription)
    }
    
    func didReiciveMessage(text: String, fromUser: String, toUser: String) {
        let incomingMessage = Message(text: text, msgId:fromUser)
        MessagesData.newMessage(from: fromUser, message: incomingMessage)
        
        NotificationCenter.default.post(name: .needReloadData, object: nil)
    }
    
}
