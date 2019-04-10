//
//  ConversationsListViewController.swift
//  Friends
//
//  Created by Mary Milchenko on 24.02.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import UIKit
import CoreData

public protocol NSFetchedResultsControllerDelegate: NSObjectProtocol {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?)
}

class ConversationsListViewController: UIViewController, ThemesViewControllerDelegate {

    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        logThemeChanging(selectedTheme: selectedTheme)
        UINavigationBar.appearance().barTintColor = selectedTheme
        self.navigationController?.navigationBar.barTintColor = selectedTheme
        let defaults = UserDefaults.standard
        let colorData: NSData = NSKeyedArchiver.archivedData(withRootObject: selectedTheme) as NSData
        defaults.set(colorData, forKey: "Theme")
    }

    @IBOutlet weak var convTable: UITableView!
    @IBOutlet var themeButton: UIBarButtonItem!

    let communicationManager = CommunicationManager()
    var multipeerCommunicator = MultipeerCommunicator()

    var conversations = [CDConversation]()
    var onlineConv = [Conversation]()

    var offlineConv = [Conversation]()
    var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.multipeerCommunicator.delegate = self.communicationManager
        self.multipeerCommunicator.online = true

        self.navigationController?.navigationBar.topItem?.title = "Tinkoff Chat"

        convTable.dataSource = self
        convTable.delegate = self

        convTable.rowHeight = UITableView.automaticDimension
        convTable.estimatedRowHeight = 67
        let nib = UINib(nibName: "ConversationsListCell", bundle: nil)
        convTable.register(nib, forCellReuseIdentifier: "Cell")

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadData),
                                               name: Notification.Name.needReloadData,
                                               object: nil)

        guard let saveContext = CoreDataStack.shared.getContext(.save) else {
            print("Ошибка контекста")
            return
        }

        let request: NSFetchRequest<CDConversation> = CDConversation.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: saveContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)

        do {
          try frc.performFetch()
        } catch {
            print("error wile fetching")
        }
        conversations = frc.fetchedObjects ?? []

        reloadData()
    }

    @IBAction func changeTheme(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Themes", bundle: nil)
        guard let navController = storyboard.instantiateViewController(withIdentifier: "NavThemesViewController") as? UINavigationController else {
            return
        }
        guard let themesViewController = navController.topViewController as? ThemesViewController else {
            return
        }
        themesViewController.delegate = self
        self.present(navController, animated: true, completion: nil)
    }

    func logThemeChanging(selectedTheme: UIColor) {
        let log = Log()
        log.vCLogger(message: " UIColor:  \(selectedTheme) ")
    }

    @objc func reloadData() {
//        onlineConv = communicationManager.onlineConvs
        offlineConv = communicationManager.offlineConvs
//        updateConversations(onlineConv)
        updateConversations(offlineConv)

        DispatchQueue.main.async {
            self.convTable.reloadData()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToConversation"{
            let vcConv = segue.destination as? ConversationViewController
            if selectedIndexPath?.section == 0 {
                let conversation: Conversation
                conversation = onlineConv[(selectedIndexPath?.row)!]
                vcConv?.name = conversation.name
                vcConv?.idConv = conversation.peerId
                vcConv?.multipeerCommunicator = multipeerCommunicator
            } else {
                let conversation: Conversation
                conversation = offlineConv[(selectedIndexPath?.row)!]
                vcConv?.name = conversation.name
                vcConv?.idConv = conversation.peerId
                vcConv?.multipeerCommunicator = multipeerCommunicator
            }
        } else if segue.identifier == "Profile" {

        } else {
            guard let navigationContoller = segue.destination as? UINavigationController else {
                return
            }
            guard let themesViewController = navigationContoller.topViewController as? ThemesViewController else {
                return
            }
            themesViewController.delegate = self
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ConversationsListCell
        else {
            fatalError("DequeueReusableCell failed while casting")
        }

        var conversation: Conversation

        if indexPath.section == 0 {
            conversation = onlineConv[indexPath.row]
        } else {
            conversation = offlineConv[indexPath.row]
        }

        cell.configure(
            name: conversation.name,
            message: conversation.message,
            date: conversation.date,
            online: conversation.online,
            hasUnreadMessages: conversation.hasUnreadMessages,
            peerId: conversation.peerId)

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

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.convTable.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.convTable.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert :
            self.convTable.insertRows(at: [newIndexPath!], with: .automatic)
        case .move :
            self.convTable.deleteRows(at: [indexPath!], with: .automatic)
            self.convTable.insertRows(at: [newIndexPath!], with: .automatic)
        case .update :
            self.convTable.reloadRows(at: [indexPath!], with: .automatic)
        case .delete :
            self.convTable.deleteRows(at: [indexPath!], with: .automatic)
        }
    }

}
