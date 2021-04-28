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
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getProfileData()
        
    }
    

    @IBAction func LogoutBtn(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        } catch let logError {
            print(logError)
        }
        
        self.toLoginScreen()
        
    }
    
    
    
    func toLoginScreen(){
        let vc = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
    
        navigationController?.pushViewController(vc!, animated: true)

    }
    
    func getProfileData(){
        db.collection("account").document(uid)
            
        
    }
}
