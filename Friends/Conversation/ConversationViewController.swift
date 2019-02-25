//
//  ConversationViewController.swift
//  Friends
//
//  Created by Mary Milchenko on 25.02.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    @IBOutlet weak var conversationTable: UITableView!
    var msgArray: [(String, Bool)] = []
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = name

        msgArray = randomArray()
        
        conversationTable.dataSource = self
        conversationTable.delegate = self
        conversationTable.isScrollEnabled = true
        
        conversationTable.rowHeight = UITableView.automaticDimension
        conversationTable.estimatedRowHeight = 67
        
        let nib = UINib(nibName: "ConversationTableViewCell", bundle: nil)
        conversationTable.register(nib, forCellReuseIdentifier: "Cell")
        let nib2 = UINib(nibName: "ConversationTableViewMyCell", bundle: nil)
        conversationTable.register(nib2, forCellReuseIdentifier: "MyCell")
    }

}

extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var conversation: (String, Bool)
        conversation = msgArray[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ConversationTableViewCell
        if (conversation.1) {
            cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! ConversationTableViewCell
        }
        
        cell.configure(
            message: conversation.0)
        
        return cell
    }

 
    
}
