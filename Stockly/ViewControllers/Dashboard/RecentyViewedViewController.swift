//
//  RecentyViewedViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/19/21.
//

import SDWebImage
import UIKit
import Firebase
import FirebaseDatabase

class RecentyViewedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
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
            .collection("recentlyViewed").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    
                    //pulling instance data from document and store in items
                    var id = doc.documentID
                    var name = doc.get("name") as! String
                    var currentStock = String(doc.get("stock") as! Int)
                    var price = String(doc.get("price") as! Int)
                    var dateAdded = doc.get("date") as! Timestamp
                    var picId = doc.get("image") as! String
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentCell") as! recentCell
        
        cell.itemImage.image = pictures[indexPath.row]
        cell.setItem(item: item)
        
        return cell
    }
    
}
