//
//  CameraViewController.swift
//  SnapchatClone
//
//  Created by Christian Rezende on 12/08/22.
//

import UIKit
import Firebase
import FirebaseStorage
class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let storageFirebase = Storage.storage()
    
    var idImage = NSUUID().uuidString
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var descriptionImageTextField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func cameraButtonHandler(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func nextButtonHandler(_ sender: Any)  {
        self.nextButton.isEnabled = false
        self.nextButton.setTitle("loading", for: .normal)
        
        let storage = storageFirebase.reference()
        let images = storage.child("images")
        
        
        // get image
        if let selectedImage = image.image {
            // compression quality 0.1 to tests
            if let dataImage = selectedImage.jpegData(compressionQuality: 0.1){
                images.child("\(self.idImage).jpg").putData(dataImage,metadata: nil) { (storageMetadata, error) in
                    
                    if error == nil {
                        print("Success Upload")
                        images.child("\(self.idImage).jpg").downloadURL {
                            (url,error) in
                            if let downloadURL = url  {
                                print(downloadURL.absoluteURL)
                                let url = downloadURL.absoluteURL
                                self.performSegue(withIdentifier: "selectUserSegue", sender: url)
                            }else {
                                print("error on try get url",error?.localizedDescription)
                            }
                        }
                    }else {
                        
                        MyAlert(title: "failed upload", message: String(describing: error?.localizedDescription)).showTitleMessageAlert(viewController: self)
                    }
                }
                
            }
            
        }
        self.nextButton.isEnabled = true
        self.nextButton.setTitle("Next", for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectUserSegue" {
            let userTableViewController = segue.destination as! UsersTableViewController
            userTableViewController.descriptionImage = self.descriptionImageTextField.text! 
            userTableViewController.idImage = self.idImage
            let url:NSURL = sender as! NSURL
            userTableViewController.urlImage = url.absoluteURL!.absoluteString
            
            
            
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.image.image = image
        
        imagePicker.dismiss(animated: true)
        
        // enable button
        self.nextButton.isEnabled = true
        self.nextButton.backgroundColor = UIColor(displayP3Red: 0.553, green: 0.369, blue: 0.749, alpha: 1)
        
    }
    
    // get images
    // need UIImagePickerControllerDelegate, UINavigationControllerDelegate
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        // unable Button
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor.gray
    }
    
    
    
}
