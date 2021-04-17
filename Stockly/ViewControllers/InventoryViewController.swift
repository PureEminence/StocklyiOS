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
class InventoryViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet var table: UITableView!
    

    
    let uid = Auth.auth().currentUser?.uid.description

    var itemCount = 0
    var picURLs = [URL]()
    var pictures = [UIImage]()
    var placeholderImage = UIImage(named: "loadingPicture")
    var items = [Item]()
    
    
    override func viewDidLoad() { //View Loading begins
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
       
       databasePull()
        
    }// end viewdidload
 
//------------------------------------------------------Database Pull
    func databasePull() {
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid.description
    //pull items where uid matches logged in user
    db.collection("items").whereField("uid", isEqualTo: uid)
        .getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    itemCount+=1
                    print(itemCount)

                    //pulling instance data from document and store in items
                    var id = doc.documentID
                    var name = doc.get("name") as! String
                    var costPer = doc.get("costPer") as! Int
                    var currentStock = doc.get("currentStock") as! Int
                    var desc = doc.get("desc") as! String
                    var initialStock = doc.get("initialStock") as! Int
                    var price = doc.get("price") as! Int
                    var tags = doc.get("tags") as! String
                    var dateAdded = doc.get("dateAdded") as! Timestamp
                    var uid = doc.get("uid") as! String
                    var picId = doc.get("picURL") as! String
                    
                    //loading image and storing
                    var picURL = URL(string: picId)
                    if var data = try? Data(contentsOf: picURL!) {
                        DispatchQueue.global().async {
                            var tempPic = UIImage(data: data)
                            pictures.append(tempPic!)
                        }
                    }
                    items.append(Item(name: name, costPer: costPer, currentStock: currentStock, desc: desc, initialStock: initialStock, price: price, tags: tags, dateAdded: dateAdded ,uid: uid ,id: id, picId: picId))
                    
                    self.tableView.reloadData()//reload tableView to populate data
                }
            }
        }
    } // -------------------------------------------- end db pull
}//end VC

//extention for setting table view cells
extension InventoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    //get items size
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
}















