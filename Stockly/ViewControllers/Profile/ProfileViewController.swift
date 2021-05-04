//
//  ProfileViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/13/21.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var joinDateText: UILabel!
    @IBOutlet weak var taglineTexr: UILabel!
    @IBOutlet weak var bioText: UILabel!
    @IBOutlet weak var ImagePresentText: UILabel!
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
    var profileImage = UIImage()
    
    var profileInfo = Profile(profilePic: "", joinedDate: "", tagline: "", bioMessage: "", storeName: "", firstName: "", lastName: "", email: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        nameText.text = String("\(profileInfo.firstName) \(profileInfo.lastName)")
        joinDateText.text = profileInfo.joinedDate
        taglineTexr.text = profileInfo.tagline
        bioText.text = profileInfo.bioMessage
        
        getProfileData( { (profileIn) in
           
            self.profileInfo = profileIn
            
        })
        
        
    }
    

    @IBAction func LogoutBtn(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        } catch let logError {
            print(logError)
        }
        
        self.toLoginScreen()
        
    }
    
    
    @IBAction func editProfile(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(identifier: "ProfileEditViewController") as? ProfileEditViewController {
            
            vc.profileImage = profilePic.image
            vc.profileInfo = profileInfo
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    
    
    
    
    
    func toLoginScreen(){
        
        let vc = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController
        //display
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()

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
                    } else {
                        self!.ImagePresentText.alpha = 1
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
                        
                        self!.profilePic.image = image
                        }
                    
                    
                    self!.nameText.text = String("\(firstName) \(lastName)")
                    self!.joinDateText.text = joinedDate
                    self!.bioText.text = bioMessage
                    self!.taglineTexr.text = tagline
                    
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

public struct Profile {
    
    var profilePic: String
    var joinedDate: String
    var tagline: String
    var bioMessage: String
    var storeName: String
    var firstName: String
    var lastName: String
    var email: String
    
    init(profilePic: String
    , joinedDate: String
    , tagline: String
    , bioMessage: String
    , storeName: String
    , firstName: String
    , lastName: String
    , email: String
    ) {
        self.profilePic = profilePic
        self.joinedDate = joinedDate
        self.tagline = tagline
        self.bioMessage = bioMessage
        self.storeName = storeName
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
