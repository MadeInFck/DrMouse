//
//  DiseasesTableViewController.swift
//  DrMouse
//
//  Created by Mickael Fonck on 01/09/2017.
//  Copyright © 2016 Mickael Fonck. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DiseasesTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var logOutBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var diseases  : [Disease] = []
    var filteredDiseases : [Disease] = []
    var ref : DatabaseReference!
    var username = ""
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        searchBar.delegate = self
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "Pacifico", size: 25)!]
        self.logOutBarButtonItem.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "Pacifico", size: 15)!], for: UIControlState())
        
        ref = Database.database().reference()
        self.ref.child("diseases").observe(.childAdded) { (snapshot:DataSnapshot) in
            let disease = Disease()
            if let dict = snapshot.value as? [String:AnyObject] {
                disease.name = dict["name"] as! String
                disease.madeBy = dict["madeBy"] as! String
                disease.key = snapshot.key
                disease.symptom1 = dict["symptom1"] as! String
                disease.symptom2 = dict["symptom2"] as! String
                disease.symptom3 = dict["symptom3"] as! String
                self.diseases.append(disease)
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let uid = Auth.auth().currentUser?.uid
        self.ref.child("users").child(uid!).observe(.value) { (snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                self.username = dict["username"] as! String
            }
        }
    }
    
    @IBAction func SignOut(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredDiseases.count
        }
        return diseases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "diseasesCell", for: indexPath)
        
        if searchActive {
            cell.textLabel?.text = self.filteredDiseases[indexPath.row].name
            cell.detailTextLabel?.text = "by " + self.filteredDiseases[indexPath.row].madeBy
            return cell
        }
        cell.textLabel?.text = self.diseases[indexPath.row].name
        cell.detailTextLabel?.text = "by " + self.diseases[indexPath.row].madeBy
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let disease = diseases[indexPath.row]
        self.performSegue(withIdentifier: "toSymptomsVC", sender: disease)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if self.username == diseases[indexPath.row].madeBy {
                self.ref.child("diseases").child(diseases[indexPath.row].key).removeValue()
                self.diseases.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSymptomsVC" {
            let nextVc = segue.destination as! ViewDiseaseViewController
            nextVc.disease = sender as! Disease
        }
    }
    
    // UISearchBar implementation
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredDiseases = []
        for disease in diseases {
            if disease.name.range(of: searchText, options: .regularExpression) != nil {
                filteredDiseases.append(disease)
            }
        }
        if(filteredDiseases.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
}
