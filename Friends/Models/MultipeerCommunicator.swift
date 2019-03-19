//
//  MultipeerCommunicator.swift
//  Friends
//
//  Created by Mary Milchenko on 19.03.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol Communicator: class {
    func SendMessage(string: String, to userID: String, completionHandler : (( _ success: Bool, _ error: Error?) -> ()?))
    var delegate : CommunicatorDelegate? {get set}
    var online : Bool {get set}
}

struct Message: Codable {
    let eventType = "TextMessage"
    var text: String
    var messageId: String
    var datetime: Date
    

    init(text: String, msgId: String){
        self.text = text
        self.messageId = msgId
        self.datetime = Date(timeIntervalSinceNow: 0)
    }
}

class MultipeerCommunicator: NSObject, Communicator{
    
    
    static let shared = MultipeerCommunicator()
    
    private var _delegate: CommunicatorDelegate?
    private var _online: Bool?
    
    var myPeerID: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    
    var sessions = [String: MCSession]()
    
    var delegate: CommunicatorDelegate? {
        get{
            return _delegate
        }
        set{
            return _delegate = newValue
        }
    }
    
    var online: Bool{
        get {
            return _online!
        }
        set {
            if (newValue == true){
                advertiser.startAdvertisingPeer()
                browser.startBrowsingForPeers()
            }
            else {
                advertiser.stopAdvertisingPeer()
                browser.stopBrowsingForPeers()
            }
            _online = newValue
        }
        
    }
    
   override init() {
        
        super.init()

        myPeerID = MCPeerID(displayName: "Mariya")
        
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID,
                                               discoveryInfo: ["userName": "Mariya Milchenko"],
                                               serviceType: "tinkoff-chat")
        advertiser.delegate = self
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: "tinkoff-chat")
        browser.delegate = self
    }
    
    func generateMessageId() -> String {
        return "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)"
            .data(using: .utf8)!.base64EncodedString()
    }
    
    func SendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ()?)) {
        let msg = Message(text: string, msgId: generateMessageId())
        
        guard let session = findSession(for: userID) else { return }
        
        let data = try! JSONEncoder().encode(msg)
        
        if session.connectedPeers.count > 0 {
            do {
                try session.send(data, toPeers: [MCPeerID(displayName: userID)], with: .reliable)
            }
            catch let error {
                print("sending error: \(error)")
            }
        } else {
            print("no peers")
        }
        
    }
    
    func findSession(for userID: String) -> MCSession? {
        if let session = (sessions as NSDictionary).value(forKey: userID) as? MCSession {
            return session
        }
        
        return nil
    }
    
    deinit {
        self.advertiser.stopAdvertisingPeer()
        self.browser.stopBrowsingForPeers()
    }
    
}



extension MultipeerCommunicator: MCBrowserViewControllerDelegate {
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        let session = MCSession(peer: myPeerID)
        session.delegate = self
        sessions[peerID.displayName] = session
    
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }

}


extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
        delegate?.failedToStartAdvertaising(error: error)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        if let session = findSession(for: peerID.displayName) {
            invitationHandler(true, session)
        } else {
            let session = MCSession(peer: myPeerID)
            invitationHandler(true, session)
            session.delegate = self
            sessions[peerID.displayName] = session
        }
        delegate?.didFoundUser(userID: peerID.displayName, userName: advertiser.discoveryInfo?["userName"])
    }
}

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
        delegate?.didLostUser(userID: peerID.displayName)
    }
    
}


extension MultipeerCommunicator : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        
        guard let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSDictionary,
            let text = dict.value(forKey: "text") as? String else { return }
        self.delegate?.didReiciveMessage(text: text, fromUser: peerID.displayName, toUser: "me")
 
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
}

