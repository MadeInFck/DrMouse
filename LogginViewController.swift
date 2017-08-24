//
//  LogginViewController.swift
//  DrMouse
//
//  Created by Mickael Fonck on 12/08/2016.
//  Copyright © 2016 Mickael Fonck. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class LogginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var SignUpButtonSegue: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!

    var backgroundImage : UIImageView!
    var logo : UILabel!
    var twitterButton : UIButton!
    var userName = ""
    var ref:DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting the views
        backgroundImage = UIImageView(image: UIImage(named: "welcome_pict.jpg"))
        backgroundImage.contentMode = UIViewContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        let logo = UILabel()
        logo.text = "Dr. Mouse"
        logo.textColor = UIColor.white
        logo.font = UIFont(name: "Pacifico", size: 50)
        logo.shadowColor = UIColor.lightGray
        logo.shadowOffset = CGSize(width: 2, height: 2)
        self.logo = logo
        self.view.addSubview(self.logo)
        
        customizeButton(LogInButton)
        customizeButton(SignUpButtonSegue)
        
        self.forgotPasswordButton.layer.borderColor = UIColor.clear.cgColor

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "toDiseasesVCSegue", sender: self)
        }
        ref = Database.database().reference()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImage.frame=self.view.frame
        let logoFrame = self.logo!.frame
        self.logo!.frame = CGRect(x: self.view.frame.width/2 - logoFrame.width/2, y: 200 - logoFrame.height - 16, width: self.view.frame.width,  height: logoFrame.height)
        self.logo!.sizeToFit()
       
    }
    
    
    @IBAction func LogInWithEmail(_ sender: UIButton) {
        if let email = self.emailTextField.text, let password = self.passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    self.sendAlertMessage(error.localizedDescription)
                    return
                } else if let user = user {
                    self.ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        if (!snapshot.exists()) {
                            let username = self.cutEmailToName(self.emailTextField.text!)
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = username
                            changeRequest?.commitChanges() { (error) in
                                if let error = error {
                                    self.sendAlertMessage(error.localizedDescription)
                                    return
                                }
                                self.ref.child("users").child(Auth.auth().currentUser!.uid).setValue(["username": username, "email": self.emailTextField.text!])
                                self.performSegue(withIdentifier: "toDiseasesVCSegue", sender: nil)
                            }
                        } else {
                            self.performSegue(withIdentifier: "toDiseasesVCSegue", sender: nil)
                        }
                    })
                }
            }
        } else {
            self.sendAlertMessage("email/password can't be empty")
        }
    }
    
    func customizeButton(_ button: UIButton!) {
        button.setBackgroundImage(nil, for: UIControlState())
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.titleLabel?.font = UIFont(name : "Pacifico", size: 20)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendAlertMessage(_ message:String) {
        let messageAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        messageAlert.addAction(defaultAction)
        
        present(messageAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        
    }
    
    @IBAction func createAccountButton(_ sender: UIButton) {
        if ((emailTextField.text != "") && (passwordTextField.text != "")) {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text! , completion: ({ (firebaseUser, firebaseError) in
                if firebaseError != nil {
                    self.sendAlertMessage((firebaseError?.localizedDescription)!)
                } else if firebaseUser != nil {
                            let username = self.cutEmailToName(self.emailTextField.text!)
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = username
                            changeRequest?.commitChanges() { (error) in
                                if let error = error {
                                    self.sendAlertMessage(error.localizedDescription)
                                    return
                                }
                            self.performSegue(withIdentifier: "toDiseasesVCSegue", sender: nil)
                            }
                }
                }))
        } else {
            sendAlertMessage("Check email and password fields please!")
        }
    }

    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        if self.emailTextField.text != "" {
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!, completion: { (error : NSError?) in
                if error != nil {
                    self.sendAlertMessage(error!.localizedDescription)
                }
        } as? SendPasswordResetCallback)
        } else {
            self.sendAlertMessage("Please fill in your email to reset your password!")
        }
    }
    
    func cutEmailToName(_ email:String) -> String {
    let index = email.range(of: "@")?.lowerBound
    return email.substring(to: index!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        LogInWithEmail(self.LogInButton)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
 
}
