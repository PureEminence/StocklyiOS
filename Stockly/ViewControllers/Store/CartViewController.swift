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
    var deleteItem:Bool = false
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
                    let id = doc.documentID
                    let name = doc.get("name") as! String
                    let currentStock = doc.get("currentStock") as! Int
                    let desc = doc.get("desc") as! String
                    let price = doc.get("price") as! Int
                    let tags = doc.get("tags") as! String
                    let dateAdded = doc.get("dateAdded") as! Timestamp
                    let picId = doc.get("image") as! String
                    let sellerName = doc.get("sellerName") as! String
                    let quantity = doc.get("numInCart") as! Int
                    let salePrice = doc.get("salePrice") as! Int
                    let picURL:URL = URL(string: picId)!
                    let userID = doc.get("uid") as! String
                    
                    if querySnapshot!.count == 1 {//DisbatchQueue breaks for 1 item... fetching manually
                        let imageData:NSData = NSData(contentsOf: picURL)!
                        let image = UIImage(data: imageData as Data)
                        pictures.append(image!)
                    } else {
                    if let data = try? Data(contentsOf: picURL) {
                        DispatchQueue.global(qos: .userInteractive).async {
                            let tempPic = UIImage(data: data)
                            pictures.append(tempPic!)
                        }
                    }
                        
                    }
                    total = total + salePrice
                    itemTotal = itemTotal + quantity
                    cartItems.append(CartItem(name: name, currentStock: currentStock, desc: desc, price: price, tags: tags, dateAdded: dateAdded, uid: userID, id: id, picId: picId, sellerName: sellerName,quantity: quantity))
                    
                    self.tableView.reloadData()//reload tableView to populate data
                }
                orderTotalText.text = "$".appending(String(total))
                itemsTotalText.text = String(itemTotal)
            }

        }
    } // -------------------------------------------- end db pull
    
    
    @IBAction func toCheckout(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as? CheckoutViewController {
            var shippingCost:Int = 10
            let total = Int(orderTotalText.text!.dropFirst())
            if(total!>100) {
                shippingCost = 0
            }
            let tax = Float(total!) * 0.07
            
            vc.subtotal = String(total!)
            vc.shipping = String(shippingCost)
            vc.tax = String(tax)
            vc.total = String(Float(tax)+Float(total!)+Float(shippingCost))
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {//swipe action = delete
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {//delete from table
            tableView.beginUpdates()
            
            let db = Firestore.firestore()//delete data from database
            db.collection("account").document(uid!)
                .collection("cart").document("CartID")
                .collection("cart_items").document(cartItems[indexPath.row].id).delete()
            
            let price = cartItems[indexPath.row].price * cartItems[indexPath.row].quantity
            orderTotalText.text = String(Int(orderTotalText.text!.dropFirst())! - price) //update order total
          
            itemsTotalText.text = String(Int(itemsTotalText.text!)! - cartItems[indexPath.row].quantity)//update items total
            
            cartItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
