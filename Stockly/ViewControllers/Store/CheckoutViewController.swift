//
//  CheckoutViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/19/21.
//

import SDWebImage
import UIKit
import Firebase
import FirebaseDatabase
import Foundation

class CheckoutViewController: UIViewController {

    
    @IBOutlet weak var shipNameText: UITextField!
    @IBOutlet weak var shipAddress1Text: UITextField!
    @IBOutlet weak var shipAddress2Text: UITextField!
    @IBOutlet weak var shipCity: UITextField!
    @IBOutlet weak var shipState: UITextField!
    @IBOutlet weak var shipZip: UITextField!
    @IBOutlet weak var paymentNameText: UITextField!
    @IBOutlet weak var cardNumberText: UITextField!
    @IBOutlet weak var cardExpText: UITextField!
    @IBOutlet weak var cardSecText: UITextField!
    
    @IBOutlet weak var subtotalText: UILabel!
    @IBOutlet weak var shippingText: UILabel!
    @IBOutlet weak var taxText: UILabel!
    @IBOutlet weak var totalText: UILabel!
    
    @IBOutlet weak var errorMessageText: UILabel!
    
    var subtotal: String!
    var shipping: String!
    var tax: String!
    var total: String!
    var cartItems = [CartItem]()
    var storeName: String!
    
    let uid = Auth.auth().currentUser?.uid.description
    let db = Firestore.firestore()
    let ranNum = String(Int.random(in: 0..<1000000))
    var orderID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderID = uid!.suffix(5).appending(ranNum)
        subtotalText.text = String(subtotal)
        shippingText.text = String(shipping)
        taxText.text = String(tax)
        totalText.text = String(total)
    }
    

    @IBAction func toOrderPlaced(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "OrderPlacedViewController") as? OrderPlacedViewController {
            
            
            let err = validateFields()//validate fields are populated then get cart and place order
            if err != nil{
                errorMessageText.text = err
                errorMessageText.alpha = 1
            } else {
                getCartandPlaceOrder()
                
                //set vals of order placed
                vc.orderID = orderID
                vc.shipName = shipNameText.text
                vc.addLine1 = shipAddress1Text.text
                vc.addLine2 = shipAddress2Text.text
                vc.city = shipCity.text
                vc.state = shipState.text
                vc.zip = shipZip.text
                vc.cardName = paymentNameText.text
                vc.cardLast4 = String(cardNumberText.text!.suffix(4))
                vc.cardExp = cardExpText.text
                vc.shippingCost = shippingText.text
                vc.tax = taxText.text
                vc.total = totalText.text
                
                
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func validateFields() -> String? { //check if fields are blank
        if shipNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            shipAddress1Text.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            shipAddress2Text.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            shipCity.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            shipState.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            shipZip.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            paymentNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            cardNumberText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            cardExpText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            cardSecText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
                return "Please fill out all fields"
            }
        
        return nil //returns nil if ok.
    }
    
    
    func getCartandPlaceOrder() {
        //get cart details from db and store purchase in DB
        
        
        //pulling cart items
        db.collection("account").document(uid!)
            .collection("cart").document("CartID")
            .collection("cart_items")
        .getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    
                    //pulling data from document
                    var id = doc.documentID
                    var name = doc.get("name") as! String
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
                    var userID = doc.get("uid") as! String
                    
                    cartItems.append(CartItem(name: name, currentStock: currentStock, desc: desc, price: price, tags: tags, dateAdded: dateAdded, uid: userID, id: id, picId: picId, sellerName: sellerName,quantity: quantity))
                    
                }
                
                //setup data for db
                let totalC = Float(totalText.text!)
                let cartTotal = String(format: "%.2f", totalC!)
                for i in 0...cartItems.count-1 {
                    //inserts data for each item in cart
                let insertData:[String: Any] = [
                    "name": cartItems[i].name,
                    "price": cartItems[i].price,
                    "currentStock":cartItems[i].currentStock,
                    "dateAdded":cartItems[i].dateAdded,
                    "desc":cartItems[i].desc,
                    "image":cartItems[i].picId,
                    "tags":cartItems[i].tags,
                    "uid":cartItems[i].uid,
                    "numInCart": cartItems[i].quantity,
                    "salePrice": cartItems[i].quantity * cartItems[i].price,
                    "sellerName": cartItems[i].sellerName
                ]
                    
                    let docRef = db.collection("account").document(uid!)
                    
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                            storeName = document.get("storeName") as! String
                            print("Document data: \(dataDescription)")
                        } else {
                            print("Document does not exist")
                        }
                    
                    
                    
                    //create transaction
                    db.collection("transactions").document(orderID)
                        .setData(["numOfItems" : cartItems.count, "cartTotal": cartTotal, "purchaseDate": Date(),"shipName": shipNameText.text!, "addressL1": shipAddress1Text.text!, "addressL2": shipAddress2Text.text!, "shipCity": shipCity.text!, "shipState": shipState.text!, "shipZip": shipZip.text!, "uid": uid!, "buyerName": storeName!])
                    //insert transaction items
                    db.collection("transactions").document(orderID)
                        .collection("transItems").addDocument(data: insertData)
                    }
                }
            }
        }
        //get cart item IDs from DB then delete
        var docIDs = [String]()
        db.collection("account").document(uid!)
            .collection("cart").document("CartID")
        .collection("cart_items").getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for doc in querySnapshot!.documents {
                        docIDs.append(doc.documentID)
                    }
                }
            
            for j in 0...docIDs.count-1 {//delete items
            db.collection("account").document(uid!)
                .collection("cart").document("CartID")
                .collection("cart_items").document(docIDs[j]).delete()
            
                //edit stock
                db.collection("items").document(docIDs[j])
                    .updateData(["currentStock" : cartItems[j].currentStock - cartItems[j].quantity, "numSold": +cartItems[j].quantity])
                
            }
        }
    } // ------------- end db pull
    
}
