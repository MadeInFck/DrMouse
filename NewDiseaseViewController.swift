//
//  NewDiseaseViewController.swift
//  DrMouse
//
//  Created by Mickael Fonck on 01/09/2017.
//  Copyright © 2016 Mickael Fonck. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NewDiseaseViewController: UIViewController {

    @IBOutlet weak var backButtonItemOutlet: UIBarButtonItem!
    @IBOutlet weak var addButtonItemOutlet: UIBarButtonItem!
    @IBOutlet weak var firstSymptomTextfield: UITextField!
    @IBOutlet weak var secondSymptomLabel: UILabel!
    @IBOutlet weak var secondSymptomTextfield: UITextField!
    @IBOutlet weak var thirdSymptomLabel: UILabel!
    @IBOutlet weak var thirdSymptomTextfield: UITextField!
    @IBOutlet weak var diseaseTextfield: UITextField!
    @IBOutlet weak var firstSymptomLabel: UILabel!
    @IBOutlet weak var newDiseaseLabel: UILabel!
    
    var numSymptom = 1
    var ref:DatabaseReference!
    var username = ""

    override func viewDidLoad() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "Pacifico", size: 25)!]
        
        self.backButtonItemOutlet.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "Pacifico", size: 15)!], for: UIControlState())
        self.addButtonItemOutlet.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "Pacifico", size: 15)!], for: UIControlState())
        
        newDiseaseLabel.layer.cornerRadius = 5
        newDiseaseLabel.layer.masksToBounds = true
        firstSymptomLabel.layer.cornerRadius = 5
        firstSymptomLabel.layer.masksToBounds = true
        secondSymptomLabel.layer.cornerRadius = 5
        secondSymptomLabel.layer.masksToBounds = true
        thirdSymptomLabel.layer.cornerRadius = 5
        thirdSymptomLabel.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        self.ref.child("users").child(uid!).observe(.value) { (snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                self.username = dict["username"] as! String
            }
        }
    }
    
    @IBAction func BackButtonItem(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addDiseaseButton(_ sender: UIBarButtonItem) {
        if diseaseTextfield.text != "" && firstSymptomTextfield.text != "" {
            var disease = ["name": self.diseaseTextfield.text!,"madeBy" : self.username,"symptom1": self.firstSymptomTextfield.text!]
            if secondSymptomTextfield.isHidden == false && secondSymptomTextfield.text != "" {
                disease["symptom2"] = self.secondSymptomTextfield.text!
                if thirdSymptomTextfield.isHidden == false && thirdSymptomTextfield.text != "" {
                    disease["symptom3"] = self.thirdSymptomTextfield.text!
                } else if thirdSymptomTextfield.isHidden == false && thirdSymptomTextfield.text == "" {
                    symptomsAlert()
                    return
                }
            } else if secondSymptomTextfield.isHidden == false && secondSymptomTextfield.text == "" {
                symptomsAlert()
                return
            }
            self.ref.child("diseases").childByAutoId().setValue(disease)
        } else {
            symptomsAlert()
            return
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addSymptom(_ sender: UIButton) {
        if numSymptom == 1 && self.firstSymptomTextfield.text != "" {
            self.secondSymptomLabel.isHidden = false
            self.secondSymptomTextfield.isHidden = false
            numSymptom += 1
            print(numSymptom, terminator: "")
        } else if numSymptom == 2 && self.firstSymptomTextfield.text != "" && self.secondSymptomTextfield.text != "" {
            self.thirdSymptomLabel.isHidden = false
            self.thirdSymptomTextfield.isHidden = false
            numSymptom += 1
            print(numSymptom, terminator: "")
        } else {
            symptomsAlert()
            return
        }
    }
    
    func symptomsAlert() {
        let alertController = UIAlertController(title: "Caution", message: "Please fill in all the symptoms fields", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
