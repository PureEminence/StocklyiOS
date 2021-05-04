//
//  ProfileEditViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/13/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

class ProfileEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePicOut: UIButton!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var taglineText: UITextField!
    @IBOutlet weak var bioText: UITextField!

    private let storage = Storage.storage().reference()
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid.description
    
    var profileImage: UIImage!
    var urlString: String = ""
    var profileInfo: Profile!

    override func viewDidLoad() {
        super.viewDidLoad()

        profilePicOut.setImage(profileImage, for: .normal)
        firstNameText.text = profileInfo.firstName
        lastNameText.text = profileInfo.lastName
        emailText.text = profileInfo.email
        taglineText.text = profileInfo.tagline
        bioText.text = profileInfo.bioMessage
    }
    

    @IBAction func saveProfileBtn(_ sender: Any) {
        
        let insertData:[String: Any] = [
            "profilePic": urlString,
            "firstName": firstNameText.text!,
            "lastName": lastNameText.text!,
            "email": emailText.text!,
            "tagline": taglineText.text!,
            "bio": bioText.text!,
            "created": profileInfo.joinedDate,
            "storeName": profileInfo.storeName
        
    ]
       
        dump(insertData)
        db.collection("account").document(uid!)
            .setData(insertData)
        
        if let vc = self.storyboard?.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController {
            
            vc.profileImage = (profilePicOut.imageView?.image)!
            vc.profileInfo = profileInfo
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    @IBAction func addProfilePicBtn(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        
        profilePicOut.imageView!.image = nil
        
        present(picker,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //get image from users photo library
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = image.pngData() else { return }
        
        profilePicOut.setImage(image, for: .normal)
        profilePicOut.setTitle("", for: .normal)
        
        let ranNum = String(Int.random(in: 0..<1000000)) //Randomly Generate Image File location
        let picStore = Auth.auth().currentUser?.uid.description.appending(ranNum) //Uses uid as a prefix
        
        storage.child("images/items/file\(picStore!).png") //store item in database
            .putData(imageData, metadata: nil, completion: { _, error in
                guard error == nil else {
                    print("Upload Failed")
                    return
                }
                
                self.storage.child("images/items/file\(picStore!).png").downloadURL { url, error in
                    guard let url = url, error == nil else {
                        return
                    }
                    self.urlString = url.absoluteString
                }
        })
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {//image picker cancel
        picker.dismiss(animated: true, completion: nil)
    }
}
