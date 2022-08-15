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
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var descriptionImageTextField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func cameraButtonHandler(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func nextButtonHandler(_ sender: Any) {
        self.nextButton.isEnabled = false
        self.nextButton.setTitle("loading", for: .normal)
        
        let storage = storageFirebase.reference()
        let images = storage.child("images")
        
        // get image
        if let selectedImage = image.image {
            if let dataImage = selectedImage.jpegData(compressionQuality: 0.5){
                images.child("image.jpg").putData(dataImage,metadata: nil) { storageMetadata, error in
                    
                    if error == nil {
                            print("Success Upload")
                    }else {
                        print("failed upload",error?.localizedDescription)
                    }
                }
                
            }
            
        }
        
        self.nextButton.isEnabled = true
        self.nextButton.setTitle("Next", for: .normal)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.image.image = image
        
        imagePicker.dismiss(animated: true)
    }
    
    // get images
    // need UIImagePickerControllerDelegate, UINavigationControllerDelegate
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
    }
    


}
