//
//  StoreViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/19/21.
//

import SDWebImage
import UIKit
import Firebase
import FirebaseDatabase

class StoreViewController: UIViewController {

    
    @IBOutlet weak var searchBarOut: UISearchBar!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    let uid = Auth.auth().currentUser?.uid.description
    var itemCount = 0
    var pictures = [UIImage]()
    var placeholderImage = UIImage(named: "loadingPicture")
    var storeItems = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewOutlet.delegate = self
        self.tableViewOutlet.dataSource = self
        
       databasePull()
    }
        
    func databasePull() {
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid.description
    //pull items where uid matches logged in user
        db.collection("items")
        .getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    itemCount+=1
                    

                    //pulling instance data from document and store in items
                    var id = doc.documentID
                    var name = doc.get("name") as! String
                    var costPer = doc.get("costPer") as! Int
                    var currentStock = doc.get("currentStock") as! Int
                    var desc = doc.get("desc") as! String
                    var price = doc.get("price") as! Int
                    var tags = doc.get("tags") as! String
                    var dateAdded = doc.get("dateAdded") as! Timestamp
                    var picId = doc.get("image") as! String
                    var numSold = doc.get("numSold") as! Int
                    var sellerName = doc.get("sellerName") as! String
                    var userID = doc.get("uid") as! String
                    
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
                    storeItems.append(Item(name: name, costPer: costPer, currentStock: currentStock, desc: desc, numSold:numSold, price: price, tags: tags, dateAdded: dateAdded, uid: userID, id: id, picId: picId, sellerName: sellerName))
                    
                    self.tableViewOutlet.reloadData()//reload tableView to populate data
                }
                
            }

        }
    } // -------------------------------------------- end db pull
    
}

extension StoreViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    //get items size
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return storeItems.count
    }
    //set cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  item = storeItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeItemCell") as! storeItemViewCell

        cell.displayImage.image = pictures[indexPath.row]
        cell.setItem(item: item)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "StoreItemViewController") as? StoreItemViewController {
            
            vc.itemImage = pictures[indexPath.row]
            var itemsData = storeItems[indexPath.row]
            vc.itemData = itemsData
            
            var docData:[String: Any] = [
                "name": itemsData.name,
                "price": itemsData.price,
                "seller": itemsData.sellerName,
                "stock": itemsData.currentStock,
                "date": Date(),
                "image": itemsData.picId
                
            ]
            
            let db = Firestore.firestore()
            db.collection("account").document(uid!)
                .collection("recentlyViewed").document(itemsData.id)
                .setData(docData)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
       
        
        
    
        
    }
    
}
