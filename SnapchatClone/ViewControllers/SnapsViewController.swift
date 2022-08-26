//
//  SnapsViewController.swift
//  SnapchatClone
//
//  Created by Christian Rezende on 11/08/22.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    let auth = Auth.auth()
    var snaps:[Snap] = []

    @IBOutlet weak var tableView: UITableView!
    
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
        if let authenticatedUserId = auth.currentUser?.uid {
            let database  = Database.database().reference()
            let users = database.child("users")
            
            let snaps = users.child(authenticatedUserId).child("snaps")
            
            snaps.observe(DataEventType.childAdded) { dataSnapshot in
                let data = dataSnapshot.value as? NSDictionary
                let snap = Snap(
                    identifier: dataSnapshot.key,
                    name: data?["name"] as! String,
                    from: data?["from"] as! String ,
                    description: data?["description"] as! String,
                    urlImage: data?["urlImage"] as! String,
                    idImage: data?["idImage"] as! String
                )
                
                self.snaps.append(snap)
                self.tableView.reloadData()
            }
            
            snaps.observe(DataEventType.childRemoved) { dataSnapshot in
                var index = 0
                for snap in self.snaps {
                    
                    if snap.idendifier == dataSnapshot.key {
                        self.snaps.remove(at: index)
                    }
                    index = index + 1
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalSnaps = snaps.count
        if totalSnaps == 0 {
            return 1
        }
        return snaps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "snapTableviewCell",for: indexPath)
        let totalSnaps = snaps.count
        if totalSnaps ==  0 {
            var defaultConfiguration = cell.defaultContentConfiguration()
            defaultConfiguration.text = "None snaps for you"
            cell.contentConfiguration = defaultConfiguration
            
        }else {
            let snap = self.snaps[indexPath.row]
        
            var defaultConfiguration = cell.defaultContentConfiguration()
            defaultConfiguration.text = snap.name
            cell.contentConfiguration = defaultConfiguration
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let totalSnaps = snaps.count
        if totalSnaps > 0 {
            let snap = self.snaps[indexPath.row]
            self.performSegue(withIdentifier: "snapDetailSegue", sender: snap)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "snapDetailSegue" {
            let snapViewController = segue.destination as! SnapViewController
            snapViewController.snap = sender as! Snap
        }
    }
}
