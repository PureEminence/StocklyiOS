//
//  PurchaseViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/19/21.
//

import UIKit
import Firebase
class PurchaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var orderIDText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var orderTotalText: UILabel!
    @IBOutlet weak var numItemsText: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var orderDetails = [PurItem]()
    var items = [PurchaseItem]()
    var pictures = [UIImage]()
    var db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid.description
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        orderIDText.text = orderDetails[0].id
        dateText.text = orderDetails[0].date.description
        orderTotalText.text = orderDetails[0].total
        numItemsText.text = String(orderDetails[0].quantity)
    
        databasePull()
        
    }
    

    func databasePull() {
        
        db.collection("account").document(uid!)
            .collection("purchases").document(orderDetails[0].id)
            .collection("itemsPurchased").getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for doc in querySnapshot!.documents {
                       
                        //pulling instance data from document and store in items
                        var id = doc.documentID
                        var name = doc.get("name") as! String
                        var desc = doc.get("desc") as! String
                        var price = doc.get("price") as! Int
                        var tags = doc.get("tags") as! String
                        var dateAdded = doc.get("dateAdded") as! Timestamp
                        var picId = doc.get("image") as! String
                        var numPur = doc.get("numInCart") as! Int
                        var sellerName = doc.get("sellerName") as! String
                        var salePrice = doc.get("salePrice") as! Int
                        
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
                        items.append(PurchaseItem(id: id, name: name, desc: desc, price: price, tags: tags, dateAdded: dateAdded, picId: picId, numPur: numPur, sellerName: sellerName, salePrice: salePrice))
                        
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
         let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseCell") as! purchaseCell
       
         cell.itemImage.image = pictures[indexPath.row]
         cell.setItem(item: item)
        
         return cell
    }
    
}
