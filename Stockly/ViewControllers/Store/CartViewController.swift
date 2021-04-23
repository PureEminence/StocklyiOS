//
//  CartViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/19/21.
//


import SDWebImage
import UIKit
import Firebase
import FirebaseDatabase

class CartViewController: UIViewController {

    @IBOutlet weak var orderTotalText: UILabel!
    @IBOutlet weak var itemsTotalText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let uid = Auth.auth().currentUser?.uid.description
    var pictures = [UIImage]()
    var cartItems = [CartItem]()
    var total:Int = 0
    var itemTotal:Int = 0
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
            .collection("cart").document("CartID")
            .collection("cart_items")
        .getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
    
                    

                    //pulling instance data from document and store in items
                    var id = doc.documentID
                    var name = doc.get("name") as! String
                    var costPer = doc.get("price") as! Int
                    var currentStock = doc.get("currentStock") as! Int
                    var desc = doc.get("desc") as! String
                    var price = doc.get("price") as! Int
                    var tags = doc.get("tags") as! String
                    var dateAdded = doc.get("dateAdded") as! Timestamp
                    var picId = doc.get("image") as! String
                    var sellerName = doc.get("sellerName") as! String
                    var quantity = doc.get("numInCart") as! Int
                    var salePrice = doc.get("salePrice") as! Int
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
                    total = total + salePrice
                    itemTotal = itemTotal + quantity
                    cartItems.append(CartItem(name: name, costPer: costPer, currentStock: currentStock, desc: desc, price: price, tags: tags, dateAdded: dateAdded, uid: uid!, id: id, picId: picId, sellerName: sellerName,quantity: quantity))
                    
                    self.tableView.reloadData()//reload tableView to populate data
                }
                orderTotalText.text = String(total)
                itemsTotalText.text = String(itemTotal)
            }

        }
    } // -------------------------------------------- end db pull
    
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    //get items size
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cartItems.count
    }
    //set cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  item = cartItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as! cartCell

        cell.imageC.image = pictures[indexPath.row]
        cell.setItem(item: item)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
    }
    
}
