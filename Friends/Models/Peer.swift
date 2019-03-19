//
//  Peer.swift
//  Friends
//
//  Created by Mary Milchenko on 19.03.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import Foundation
import MultipeerConnectivity


class Peer: NSObject{
    let peerId: String?
    var name: String?
    var state = MCSessionState.notConnected
    var myPeerId: MCPeerID
    var msgArray: [Message] = []
    
    init(peerId: String, myPeerId: MCPeerID, name: String){
        self.name = name
        self.myPeerId = myPeerId
        self.peerId = peerId

        super.init()

    }
    
    func addMsg(msg: Message){
        msgArray.append(msg)
    }

}

