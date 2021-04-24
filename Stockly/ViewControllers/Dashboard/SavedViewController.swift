//
//  SavedViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/19/21.
//

import SDWebImage
import UIKit
import Firebase
import FirebaseDatabase

class SavedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    let uid = Auth.auth().currentUser?.uid.description
    var pictures = [UIImage]()
    var items = [SavedItem]()
    
    
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
        db.collection("account").document(uid!)
            .collection("saved").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    
                    //pulling instance data from document and store in items
                    var id = doc.documentID
                    var name = doc.get("name") as! String
                    var currentStock = doc.get("numStock") as! String
                    var price = doc.get("price") as! String
                    var dateAdded = doc.get("dateAdded") as! Timestamp
                    var picId = doc.get("picID") as! String
                    var sellerName = doc.get("seller") as! String
                    
                    //loading image and storing
                    var picURL:URL = URL(string: picId)!
                
                    if querySnapshot!.count == 1 {//DisbatchQueue breaks for 1 item... fetching manually
                        let imageData:NSData = NSData(contentsOf: picURL)!
                        let image = UIImage(data: imageData as Data)
                        pictures.append(image!)
                    } else {
                    if var data = try? Data(contentsOf: picURL) {
                        DispatchQueue.global(qos: .userInteractive).async {
                            var tempPic = UIImage(data: data)
                            pictures.append(tempPic!)
                        }
                    }
                }
                    items.append(SavedItem(name: name, currentStock: currentStock, price: price, dateAdded: dateAdded, id: id, picId: picId, sellerName: sellerName))
                    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedCell") as! savedCell
        
        cell.itemImage.image = pictures[indexPath.row]
        cell.setItem(item: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {//swipe action = delete
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {//delete from table
            tableView.beginUpdates()
            
            let db = Firestore.firestore()//delete data from database
            db.collection("account").document(uid!)
                .collection("saved").document(items[indexPath.row].id).delete()
            
            
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
            tableView.endUpdates()
        }
    }
    
}
