//
//  UserStoreViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/19/21.
//

import UIKit
import Firebase

class UserStoreViewController: UIViewController {

    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameText.text = name
        bioText.text = bio
        taglineText.text = tagline
        joinDateText.text = joinDate
        
    }
    
    func getProfileData(_ completion: @escaping (_ data: Profile) -> Void) {
        
        var profileInfo = Profile(profilePic: "", joinedDate: "", tagline: "", bioMessage: "", storeName: "", firstName: "", lastName: "", email: "")
        
        db.collection("account").document(uid)
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
                    self!.joinDateText.text = joinedDate
                    self!.bioText.text = bioMessage
                    self!.taglineText.text = tagline
                    
                    profileInfo.profilePic = profilePic
                    profileInfo.tagline = tagline
                    profileInfo.bioMessage = bioMessage
                    profileInfo.joinedDate = self!.joinDateText.text!
                    profileInfo.storeName = storeName
                    profileInfo.firstName = firstName
                    profileInfo.lastName = lastName
                    profileInfo.email = email
                    
                    completion(profileInfo)
                }
            }
        
    }
    

}
