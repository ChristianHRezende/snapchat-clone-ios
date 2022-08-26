//
//  Alert.swift
//  SnapchatClone
//
//  Created by Christian Rezende on 11/08/22.
//

import UIKit

class MyAlert {
    
    let title:String!
    let message:String!
    
    init(title:String,message:String) {
        self.title = title
        self.message = message
    }

    func showTitleMessageAlert(viewController:UIViewController)->Void{
        
        let alertController = UIAlertController(title: self.title, message: self.message, preferredStyle: .alert)
        let actionController = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(actionController)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
