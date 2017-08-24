//
//  ViewDiseaseViewController.swift
//  DrMouse
//
//  Created by Mickael Fonck on 03/09/2016.
//  Copyright © 2016 Mickael Fonck. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewDiseaseViewController: UIViewController {
    
    
    @IBOutlet weak var backViewButton: UIBarButtonItem!
    @IBOutlet weak var symptom1Label: UILabel!
    var disease : Disease!
    
    override func viewDidLoad() {
 
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "Pacifico", size: 20)!]
        self.backViewButton.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "Pacifico", size: 15)!], for: UIControlState())
        self.navigationItem.title = self.disease.name
        self.symptom1Label.text = self.disease.symptom1
        
    }
    
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
}
