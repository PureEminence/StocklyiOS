//
//  InventoryViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/13/21.
//
import SDWebImage
import UIKit
import Firebase
import FirebaseDatabase
class InventoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noItemText: UILabel!
    
    let uid = Auth.auth().currentUser?.uid.description
    var pictures = [UIImage]()
    var items = [Item]()
  
    override func viewDidLoad() { //View Loading begins
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
 
       databasePull()
        
    } // end viewdidload
    
//------------------------------------------------------Database Pull
    func databasePull() {
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid.description
    //pull items where uid matches logged in user
        db.collection("items").whereField("uid", isEqualTo: uid!)
        .getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for doc in querySnapshot!.documents {
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
                    
                    
                    //loading image and storing
                    if picId == "" {
                        picId = "No pic data"
                    } else {
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
                    
                        
                    }
                    items.append(Item(name: name, costPer: costPer, currentStock: currentStock, desc: desc, numSold:numSold, price: price, tags: tags, dateAdded: dateAdded, uid: uid!, id: id, picId: picId, sellerName: sellerName))
                    
                    
                    
                    self.tableView.reloadData()//reload tableView to populate data
                    
                }
            }
        }
    } // -------------------------------------------- end db pull


        
    //get items size
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(items.count)
        if items.count == 0 {
            noItemText.alpha = 1
        } else {
            noItemText.alpha = 0
        }
        return items.count
    }
    //set cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! itemCell

        cell.imageC.image = pictures[indexPath.row]
        cell.setItem(item: item)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EditItemViewController") as? EditItemViewController {
            
            vc.image = pictures[indexPath.row]
            var itemsData = items[indexPath.row]
            vc.indexPath = indexPath
            vc.itemData = itemsData
            
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {//swipe action = delete
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {//delete from table
            tableView.beginUpdates()
            
            let db = Firestore.firestore()//delete data from database
            db.collection("items").document(items[indexPath.row].id).delete()
            
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
            tableView.endUpdates()
        }
    }
}















