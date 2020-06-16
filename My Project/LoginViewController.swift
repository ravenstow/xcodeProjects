//
//  LoginViewController.swift
//  My Project
//
//  Created by susanne on 2020/5/23.
//  Copyright © 2020 Mike Wu. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet var accountNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var signInButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Listener for Account State
//        let listener = Auth.auth().addStateDidChangeListener { (auth, user) in
//            <#code#>
//        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.isEnabled = false
        
        Utilities.addingGuestToFirebase(with: Utilities.guestSample1)
        Utilities.addingGuestToFirebase(with: Utilities.guestSample2)
        Utilities.addingGuestToFirebase(with: Utilities.guestSample3)
        Utilities.addingGuestToFirebase(with: Utilities.guestSample4)
        Utilities.addingGuestToFirebase(with: Utilities.guestSample5)
        
    }
    
    @IBAction func credentialEditChanged(_ sender: UITextField) {
        if accountNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            signInButton.isEnabled = true
        }
    }
  
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: accountNameTextField.text!, password: passwordTextField.text!) { (authDataResult, error) in
            // If there's Error
            if let error = error {
                self.signInErrorPopUp(error: error.localizedDescription)
            }
            // No Error, Sign-in the User
            else {
                self.signInSuccessfulPopUp()
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    func emailValidation(email: String) -> Bool {
        return false
    }
    
    func passwordValidation(password: String) -> Bool {
        return false
    }
    
    func signInSuccessfulPopUp() {
        let alertController = UIAlertController(title: "歡迎回來，管理員！", message: "目前訂房件數：", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
        
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func signInErrorPopUp(error: String) {
        let alertController = UIAlertController(title: error, message: "請輸入有效帳號名稱(), 密碼()", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
        
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
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
