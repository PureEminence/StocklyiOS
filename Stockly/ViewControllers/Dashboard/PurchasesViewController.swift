//
//  PurchasesViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/19/21.
//

import SDWebImage
import UIKit
import Firebase
import FirebaseDatabase

class PurchasesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
        
    
    let uid = Auth.auth().currentUser?.uid.description
    var pictures = [UIImage]()
    var items = [PurItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        databasePull()

    }
    
    func databasePull() {
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid.description
    //pull items where uid matches logged in user
        db.collection("transactions").whereField("uid", isEqualTo: uid!)
            .getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    
                    //pulling instance data from document and store
                    var id = doc.documentID
                    var total = doc.get("cartTotal") as! String
                    var date = doc.get("purchaseDate") as! Timestamp
                    var quantity = doc.get("numOfItems") as! Int
                    
                    
                    items.append(PurItem(id: id, total: total, date: date, quantity: quantity))
                    
                    self.tableView.reloadData()//reload tableView to populate data
                }
                
            }

        }
    }
 
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchasesCell") as! purchasesCell
      
        cell.setItem(item: item)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "PurchaseViewController") as? PurchaseViewController {
            
            vc.orderDetails.append(items[indexPath.row])
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
