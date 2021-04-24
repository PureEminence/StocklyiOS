//
//  SaleViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/19/21.
//

import UIKit
import Firebase

class SaleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var orderIDText: UILabel!
    @IBOutlet weak var quantityText: UILabel!
    @IBOutlet weak var orderTotalText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var buyerName: UIButton!
    
    var orderDetails = [SalesItem]()
    var items = [SaleItem]()
    var pictures = [UIImage]()
    var db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid.description
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        orderIDText.text = orderDetails[0].id
        var date = orderDetails[0].date.dateValue().description
        dateText.text = String(date.dropLast(5))
        orderTotalText.text = "$".appending(String(orderDetails[0].total))
        quantityText.text = String(orderDetails[0].itemNumTotal)
        buyerName.setTitle(orderDetails[0].buyerName, for: .normal)
    
        databasePull()
        
    }
    

    func databasePull() {
        
        db.collection("transactions").document(orderDetails[0].id)
            .collection("transItems").getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for doc in querySnapshot!.documents {
                       
                        //pulling instance data from document and store in items
                        var id = doc.documentID
                        var name = doc.get("name") as! String
                        var price = doc.get("price") as! Int
                        var picId = doc.get("image") as! String
                        var quantity = doc.get("numInCart") as! Int
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
                        items.append(SaleItem(id: id, name: name, quantity: quantity, price: price, total: salePrice))
                        
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
         let cell = tableView.dequeueReusableCell(withIdentifier: "SaleCell") as! SaleCell
       
         cell.itemImage.image = pictures[indexPath.row]
         cell.setItem(item: item)
        
         return cell
    }
    
}
