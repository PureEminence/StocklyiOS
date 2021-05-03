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
    //pull items where uid matches logged in user
        db.collection("items")
        .getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    itemCount+=1
                    

                    //pulling instance data from document and store in items
                    let id = doc.documentID
                    let name = doc.get("name") as! String
                    let costPer = doc.get("costPer") as! Int
                    let currentStock = doc.get("currentStock") as! Int
                    let desc = doc.get("desc") as! String
                    let price = doc.get("price") as! Int
                    let tags = doc.get("tags") as! String
                    let dateAdded = doc.get("dateAdded") as! Timestamp
                    let picId = doc.get("image") as! String
                    let numSold = doc.get("numSold") as! Int
                    let sellerName = doc.get("sellerName") as! String
                    let userID = doc.get("uid") as! String
                    
                    //loading image and storing
                    let picURL:URL = URL(string: picId)!
                
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
                    storeItems.append(Item(name: name, costPer: costPer, currentStock: currentStock, desc: desc, numSold:numSold, price: price, tags: tags, dateAdded: dateAdded, uid: userID, id: id, picId: picId, sellerName: sellerName))
                    
                    self.tableViewOutlet.reloadData()//reload tableView to populate data
                }
                print("dumping piccs: ")
                dump(pictures)
                print("dumping items: ")
                dump(storeItems)
                
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
            let itemsData = storeItems[indexPath.row]
            vc.itemData = itemsData
            
            //data for recently viewed
            let insertData:[String: Any] = [
                "name": storeItems[indexPath.row].name,
                "price": storeItems[indexPath.row].price,
                "image":storeItems[indexPath.row].picId,
                "uid":storeItems[indexPath.row].uid,
                "salePrice": storeItems[indexPath.row].price,
                "sellerName": storeItems[indexPath.row].sellerName,
                "dateAdded": Date(),
                "costPer":storeItems[indexPath.row].costPer,
                "currentStock":storeItems[indexPath.row].currentStock,
                "desc":storeItems[indexPath.row].desc,
                "numSold":storeItems[indexPath.row].numSold,
                "tags": storeItems[indexPath.row].tags
            ]
                
            //add item to recently viewed
            let db = Firestore.firestore()
            db.collection("account").document(uid!)
                .collection("recentlyViewed").document(itemsData.id)
                .setData(insertData)
            //deselect and push
            
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
       
        
        
    
        
    }
    
}
