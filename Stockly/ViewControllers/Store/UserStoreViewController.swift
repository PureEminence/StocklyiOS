//
//  UserStoreViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/19/21.
//

import UIKit

class UserStoreViewController: UIViewController {

    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var joinDateText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var bioText: UILabel!
    @IBOutlet weak var taglineText: UILabel!
    
    
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
    
    //TODO: Database pull for items for sale and link up with store VC search
    

}
