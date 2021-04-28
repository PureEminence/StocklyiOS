//
//  MessagingViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/24/21.
//

import UIKit
import Firebase

struct Conversation {
    let id: String
    let name: String
    let otherUserID: String
    let latestMessage: LatestMessage
}
struct LatestMessage{
    let id: String
    let date: String
    let message: String
    let isRead: Bool
}

class MessagingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var conversations = [Conversation]()
    var messages = [Message]()
    let uid = Auth.auth().currentUser!.uid
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func newMessageButton(_ sender: UIButton) {//go to create new message
        let vc = storyboard?.instantiateViewController(identifier: "NewMessageViewController") as! NewMessageViewController
        vc.completion = { [weak self] result in
            self?.createNewConversation(result: result)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func createNewConversation(result: SearchResults){//gets search results and push to chat view
        let vc = ChatViewController()
        guard let name = result.storeName, let userID = result.userID else { return }
        vc.title = name
        vc.otherUserID = userID
        vc.isNewConv = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        getConversations()//load from database
    }
    
    
    func getConversations(){//pull convo's from db
        DatabaseHelper.shared.getAllConvo(for: uid, { (conversation) in
            
                if conversation.isEmpty {
                    print("No Conversations")
                    return
                    }
                self.conversations = conversation
                DispatchQueue.main.async {
                self.tableView.reloadData()
                }
        })
    }
    
    
    func getMessages(otherID: String){ //gets messages from DB
        DatabaseHelper.shared.getConvMessages(with: otherID, { [weak self] (message) in
            
            if message.isEmpty {
                print("no messages")
                return
            }
            self!.messages = message
            DispatchQueue.main.async {
                self!.tableView.reloadData()
            }
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell") as! MessagesCell
        
        cell.nameText.text = conversations[indexPath.row].name
        cell.messageText.text = conversations[indexPath.row].latestMessage.message
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {//when row tapped go to chatVC with conv data
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController()
        var conversation = conversations[indexPath.row]
        
        if vc.isNewConv == false {
            getMessages(otherID: conversation.otherUserID)
            vc.messages = messages
            vc.otherUserID = conversation.otherUserID
        }
        
        vc.conversation.append(conversation)
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
