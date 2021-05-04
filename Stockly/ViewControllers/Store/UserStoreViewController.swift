//
//  UserStoreViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/19/21.
//

import UIKit
import Firebase

class UserStoreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var joinDateText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var bioText: UILabel!
    @IBOutlet weak var taglineText: UILabel!
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
    var name: String!
    var bio: String!
    var tagline: String!
    var joinDate: String!
    var userID: String!
    
    var pictures = [UIImage]()
    var items = [Item]()
    var profileInfo = Profile(profilePic: "", joinedDate: "", tagline: "", bioMessage: "", storeName: "", firstName: "", lastName: "", email: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameText.text = name
        bioText.text = bio
        taglineText.text = tagline
        joinDateText.text = joinDate
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        getProfileData(userID: userID, { (profileIn) in
           
            self.profileInfo = profileIn
            
        })
        
        getItemsForSale(userID: userID)
    }
    
    func getProfileData(userID: String, _ completion: @escaping (_ data: Profile) -> Void) {
        
        var profileInfo = Profile(profilePic: "", joinedDate: "", tagline: "", bioMessage: "", storeName: "", firstName: "", lastName: "", email: "")
        
        db.collection("account").document(userID)
            .getDocument { [weak self] doc, error in
                if error != nil {
                    print(error!)
                } else {
                    var profilePic = ""
                    var tagline = "No tagline set."
                    var bioMessage = "No bio set."
                    if doc!.get("profilePic") != nil {
                        profilePic = doc!.get("profilePic")! as! String
                    }
                    
                    if doc!.get("tagline") != nil {
                        tagline = doc!.get("tagline")! as! String
                    }
                    if doc!.get("bio") != nil {
                        bioMessage = doc!.get("bio")! as! String
                    }
                    
                    let joinedDate = doc!.get("created")! as! String
                    let storeName = doc!.get("storeName")! as! String
                    let firstName = doc!.get("firstName")! as! String
                    let lastName = doc!.get("lastName")! as! String
                    let email = doc!.get("email")! as! String
                    
                    if profilePic == "" {
                        profilePic = "No pic data"
                    } else {
                        let picURL:URL = URL(string: profilePic)!
                            let imageData:NSData = NSData(contentsOf: picURL)!
                            let image = UIImage(data: imageData as Data)
                        
                        self!.profilePicture.image = image
                        }
                    
                    
                    self!.nameText.text = String("\(firstName) \(lastName)")
                    self!.joinDateText.text = "Joined ".appending(joinedDate)
                    self!.bioText.text = bioMessage
                    self!.taglineText.text = tagline
                    
                    profileInfo.profilePic = profilePic
                    profileInfo.tagline = tagline
                    profileInfo.bioMessage = bioMessage
                    profileInfo.joinedDate = String(self!.joinDateText.text!.dropFirst(7))
                    profileInfo.storeName = storeName
                    profileInfo.firstName = firstName
                    profileInfo.lastName = lastName
                    profileInfo.email = email
                    
                    self?.collectionView.reloadData()
                    
                    
                    completion(profileInfo)
                }
            }
        
        
    }
    

    func getItemsForSale(userID: String) {
    //pull items where uid matches logged in user
        db.collection("items").whereField("uid", isEqualTo: userID)
        .getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for doc in querySnapshot!.documents {
                    //pulling instance data from document and store in items
                    let id = doc.documentID
                    let name = doc.get("name") as! String
                    let costPer = doc.get("costPer") as! Int
                    let currentStock = doc.get("currentStock") as! Int
                    let desc = doc.get("desc") as! String
                    let price = doc.get("price") as! Int
                    let tags = doc.get("tags") as! String
                    let dateAdded = doc.get("dateAdded") as! Timestamp
                    var picId = doc.get("image") as! String
                    let numSold = doc.get("numSold") as! Int
                    let sellerName = doc.get("sellerName") as! String
                    
                    
                    //loading image and storing
                    if picId == "" {
                        picId = "No pic data"
                    } else {
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
                    
                        
                    }
                    items.append(Item(name: name, costPer: costPer, currentStock: currentStock, desc: desc, numSold:numSold, price: price, tags: tags, dateAdded: dateAdded, uid: userID, id: id, picId: picId, sellerName: sellerName))
                    
                    
                    
                    self.collectionView.reloadData()//reload tableView to populate data
                    
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreProfileCell", for: indexPath) as! StoreProfileCell
        
        let item = items[indexPath.row]
        
        cell.itemImage.image = pictures[indexPath.row]
        cell.itemNameText.text = item.name
        cell.itemPriceText.text = "$".appending(String(item.price))
        
        return cell
        
        
    }
    
}
