//
//  UsersTableViewController.swift
//  SnapchatClone
//
//  Created by Christian Rezende on 16/08/22.
//

import UIKit
import Firebase

class UsersTableViewController: UITableViewController {
        
    var users:[User] = []
    var urlImage = ""
    var descriptionImage = ""
    var idImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let database = Database.database().reference()
        let users = database.child("users")
        
        let auth = Auth.auth()
        
        let authenticatedUserId = auth.currentUser?.uid
        
        
        users.observe(DataEventType.childAdded) { dataSnapshot in
            let data = dataSnapshot.value as? NSDictionary
            //get user data\
            
            let email = data?["email"] as! String
            let name = data?["name"] as! String
            // get the user ID
            
            let idUser = dataSnapshot.key
            
            let user = User(email: email, name: name, uid: idUser)
            if authenticatedUserId != idUser {
                self.users.append(user)
            }
            
            self.tableView.reloadData()
            

        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTableCellIdentifier", for: indexPath)

        var contentConfiguration = cell.defaultContentConfiguration()
        
        
        
        let user = self.users[indexPath.row]
        
        contentConfiguration.text = user.name
        contentConfiguration.secondaryText = user.email
        
        cell.contentConfiguration = contentConfiguration
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedUser = self.users[indexPath.row]
        let idSelectedUser = selectedUser.uid
        
        let database = Database.database().reference()
        let users = database.child("users")
        
        let snapsDB = users.child(idSelectedUser).child("snaps")
        
        let authentication = Auth.auth()
        if let idUserAuthenticated = authentication.currentUser?.uid {
            let authenticatedUser = users.child(idUserAuthenticated)
            authenticatedUser.observeSingleEvent(of: DataEventType.value) { dataSnapshot in
                let data = dataSnapshot.value as? NSDictionary
                
                let snap = [
                    "from": data?["email"] as! String,
                    "name": data?["name"] as! String,
                    "description": self.descriptionImage,
                    "urlImage": self.urlImage,
                    "idImage": self.idImage,
                ]
                
                // auto id
                snapsDB.childByAutoId().setValue(snap)
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    
       
       
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
