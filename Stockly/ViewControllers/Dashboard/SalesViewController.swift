//
//  SalesViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/19/21.
//

import SDWebImage
import UIKit
import Firebase
import FirebaseDatabase

class SalesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    
    
    let uid = Auth.auth().currentUser?.uid.description
    var pictures = [UIImage]()
    var items = [SalesItem]()
    
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
                    let id = doc.documentID
                    let total = doc.get("cartTotal") as! String
                    let date = doc.get("purchaseDate") as! Timestamp
                    let quantity = doc.get("numOfItems") as! Int
                    let buyerName = doc.get("buyerName") as! String
                    
                    
                    items.append(SalesItem(id: id, buyerName: buyerName, itemNumTotal: quantity, total: total, date: date))
                    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalesCell") as! SalesCell
      
        cell.setItem(item: item)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SaleViewController") as? SaleViewController {
            
            vc.orderDetails.append(items[indexPath.row])
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
