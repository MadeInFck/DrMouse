//
//  ViewDiseaseViewController.swift
//  DrMouse
//
//  Created by Mickael Fonck on 03/09/2017.
//  Copyright © 2016 Mickael Fonck. All rights reserved.
//

import UIKit

class ViewDiseaseViewController: UIViewController {
    
    
    @IBOutlet weak var backViewButton: UIBarButtonItem!
    @IBOutlet weak var symptom1Label: UILabel!
    @IBOutlet weak var symptom2Label: UILabel!
    @IBOutlet weak var symptom3Label: UILabel!

    var disease : Disease!
    
    override func viewDidLoad() {
 
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "Pacifico", size: 20)!]
        self.backViewButton.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "Pacifico", size: 15)!], for: UIControlState())
        self.navigationItem.title = self.disease.name
        symptom1Label.text = disease.symptom1
        symptom2Label.text = disease.symptom2
        symptom3Label.text = disease.symptom3
        
        symptom1Label.layer.cornerRadius = 5
        symptom1Label.layer.masksToBounds = true
        symptom2Label.layer.cornerRadius = 5
        symptom2Label.layer.masksToBounds = true
        symptom3Label.layer.cornerRadius = 5
        symptom3Label.layer.masksToBounds = true
    }
    
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
}
