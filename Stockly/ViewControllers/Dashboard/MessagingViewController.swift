//
//  MessagingViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/24/21.
//

import UIKit
import Firebase

class MessagingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func newMessageButton(_ sender: UIButton) {//go to create new message
        let vc = storyboard?.instantiateViewController(identifier: "NewMessageViewController") as! NewMessageViewController
        vc.completion = { [weak self] result in
            self?.createNewConversation(result: result)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func createNewConversation(result: SearchResults){
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
    
    
    func getConversations(){
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell") as! MessagesCell
        
        cell.nameText.text = "Name"
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
