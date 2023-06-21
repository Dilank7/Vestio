//
//  ViewController.swift
//  vestio
//
//  Created by Ben Lischin on 6/12/23.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    let loginScreen = LoginView()
    
    override func loadView() {
        view = loginScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        loginScreen.login.addTarget(self, action: #selector(loginButtonFunc), for: .touchUpInside)
        loginScreen.create.addTarget(self, action: #selector(createButtonFunc), for: .touchUpInside)

    }
    
    @objc func createButtonFunc() {
        let registerController = RegisterController()
        //push the screen to Stack...
        navigationController?.pushViewController(registerController, animated: true)
        self.loginScreen.textfieldEmail.text = ""
        self.loginScreen.textfieldPassword.text = ""
    }
    
    @objc func loginButtonFunc() {
        let email = loginScreen.textfieldEmail.text
        let password = loginScreen.textfieldPassword.text
        
        if let unwrappedEmail = email, let unwrappedPassword = password {
            // all non-nil

            if !(unwrappedEmail.isEmpty || unwrappedPassword.isEmpty) {
                // non-empty valid strings were entered
                // --> good! send the data to screen 2 and open it up

                // VERIFY INPUT FORMATS WHERE NECESSARY
                // ensure email is valid format
                if !isValidEmail(unwrappedEmail) {
                    showErrorAlertEmail()
                    return
                }
                
                // do stuff
                signInToFirebase(email: unwrappedEmail, password: unwrappedPassword)
                self.loginScreen.textfieldEmail.text = ""
                self.loginScreen.textfieldPassword.text = ""

            } else {
                // alert about empty fields
                showErrorAlertEmpty()
            }

        }
    }
    
    func signInToFirebase(email: String, password: String){
        //MARK: can you display progress indicator here?
        //MARK: authenticating the user...
        Auth.auth().signIn(withEmail: email, password: password, completion: {(result, error) in
            if error == nil{
                //MARK: user authenticated...
                print("user authenticated")
                
                let portfolioController = PortfolioController()
                self.navigationController?.pushViewController(portfolioController, animated: true)
                
                //MARK: can you hide the progress indicator here?
            }else{
                //MARK: alert that no user found or password wrong...
                print("no user found")
            }
        })
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func showErrorAlertEmpty(){
        let alert = UIAlertController(title: "Error!", message: "Input fields cannot be empty!", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alert, animated: true)
    }
    
    func showErrorAlertEmail(){
        let alert = UIAlertController(title: "Error!", message: "Please enter a valid email address", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alert, animated: true)
    }

    func showErrorAlertLogin(){
        let alert = UIAlertController(title: "Error!", message: "Either the email or password is incorrect", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alert, animated: true)
    }
    


}

