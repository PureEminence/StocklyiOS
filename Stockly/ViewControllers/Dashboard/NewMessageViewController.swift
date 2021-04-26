//
//  NewMessageViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/24/21.
//

import UIKit
import Firebase
class NewMessageViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    public var completion: ((SearchResults) -> (Void))?
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid.description
    var searchUser = [SearchResults]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else { return }

        searchUsers(searchText: text)//search DB for search string
    }

    
    func searchUsers(searchText: String) {//search users for store name
        
        db.collection("account").whereField("storeName", isEqualTo: searchText).getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    
                    var storeName = doc.get("storeName") as! String
                    var userID = doc.documentID
                    self.searchUser.append(SearchResults(storeName: storeName, userID: userID))
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchResultCell", for: indexPath) as! UserSearchResultCell
        
        cell.userStoreNameText.text = searchUser[indexPath.row].storeName
      
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let userData = searchUser[indexPath.row]
        
        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(userData)
        })
    }
}

public class SearchResults{
    
    var storeName: String!
    var userID: String!

    init(storeName: String,
         userID: String) {
        self.storeName = storeName
        self.userID = userID
    }
    
}
