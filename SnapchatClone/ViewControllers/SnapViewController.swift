//
//  SnapViewController.swift
//  SnapchatClone
//
//  Created by Christian Rezende on 25/08/22.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseStorage

class SnapViewController: UIViewController {

    @IBOutlet weak var snapImageView: UIImageView!
    
    @IBOutlet weak var snapDetailLabel: UILabel!
    
    @IBOutlet weak var snapCounterLabel: UILabel!
    
    var snap:Snap? = nil

    var counter = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        snapDetailLabel.text = snap?.description
        if !(snap?.urlImage.isEmpty ?? true){
            if let url  = URL(string: snap!.urlImage) {
                snapImageView.sd_setImage(with: url) { uiImage, error, sdImageCache, url in
                    if error == nil {
                            
                        self.snapDetailLabel.text = self.snap?.description
                        
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                            self.counter = self.counter - 1
                            
                            self.snapCounterLabel.text = String(self.counter)
                            
                            if self.counter == 0 {
                                timer.invalidate()
                                self.dismiss(animated: true)
                            }
                        }
                    }
                }

            }
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let auth = Auth.auth()
        if let authenticatedUserId = auth.currentUser?.uid{
            // Remove nodes from database
            let database = Database.database().reference()
            let users = database.child("users")
            
            let snaps = users.child(authenticatedUserId).child("snaps")
            if let identifier = snap?.idendifier {
                snaps.child(identifier).removeValue()
           
                // Remove image from storage
                let storage = Storage.storage().reference()
                let imagesSrc = storage.child("images")
                if let idImage = snap?.idImage {
                    imagesSrc.child("\(idImage).jpg").delete { error in
                        if error == nil {
                            print("Success on delete")
                        }else {
                            print("Error on delete image")
                        }
                    }
                }
               
            }
          }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
