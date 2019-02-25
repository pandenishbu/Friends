//
//  ConversationsListViewController.swift
//  Friends
//
//  Created by Mary Milchenko on 24.02.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {

    @IBOutlet weak var convTable: UITableView!
    
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = "Tinkoff Chat"
        
        convTable.dataSource = self
        convTable.delegate = self
        
        convTable.rowHeight = UITableView.automaticDimension
        convTable.estimatedRowHeight = 67
        let nib = UINib(nibName: "ConversationsListCell", bundle: nil)
        convTable.register(nib, forCellReuseIdentifier: "Cell")
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToConversation"{
            let VC = segue.destination as? ConversationViewController
            if selectedIndexPath?.section == 0 {
                let conversation: (String, String?, Date?, Bool, Bool)
                conversation = onlineConv[(selectedIndexPath?.row)!]
                VC?.name = conversation.0
            }
            else {
                let conversation: (String, String?, Date?, Bool, Bool)
                conversation = onlineConv[(selectedIndexPath?.row)!]
                VC?.name = conversation.0
            }
    }
    }
    
}

extension ConversationsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return onlineConv.count
        case 1:
            return  offlineConv.count
        default:
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ConversationsListCell
        
        var conversation: (String, String?, Date?, Bool, Bool)
        
        if indexPath.section == 0 {
            conversation = onlineConv[indexPath.row]
        } else {
            conversation = offlineConv[indexPath.row]
        }
        
        cell.configure(
            name: conversation.0,
            message: conversation.1,
            date: conversation.2,
            online: conversation.3,
            hasUnreadMessages: conversation.4)
        
        return cell
    }
    
    // Select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "ToConversation", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return ""
        }
    }
    
}



