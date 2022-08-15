//
//  SnapsViewController.swift
//  SnapchatClone
//
//  Created by Christian Rezende on 11/08/22.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController {

    let auth = Auth.auth()
    
    @IBAction func logout(_ sender: Any) {
        do {
            try auth.signOut()
            dismiss(animated: true, completion: nil)
        } catch let error {
            print("Error on try signout",error.localizedDescription)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
