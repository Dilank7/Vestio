//
//  RegisterController.swift
//  vestio
//
//  Created by Ben Lischin on 6/12/23.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class RegisterController: UIViewController {

    let registerView = RegisterView()
        
    let database = Firestore.firestore()

    
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        registerView.buttonRegister.addTarget(self, action: #selector(registerFunc), for: .touchUpInside)
        title = "Register"
    }
    
    @objc func registerFunc(){
        //MARK: creating a new user on Firebase...
        
        registerNewAccount()
        
    }
    
    func registerNewAccount(){
        //MARK: display the progress indicator...
        //MARK: create a Firebase user with email and password...
        if let name = registerView.textFieldName.text,
           let email = registerView.textFieldEmail.text,
           let password = registerView.textFieldPassword.text, let password2 = registerView.textFieldPassword2.text {
            
            //Validations....
            
            if !(name.isEmpty || email.isEmpty || password.isEmpty || password2.isEmpty) {
                // non-empty valid strings were entered
                // --> good! send the data to screen 2 and open it up

                // VERIFY INPUT FORMATS WHERE NECESSARY
                // ensure email is valid format
                if !isValidEmail(email) {
                    showErrorAlertEmail()
                    return
                }
                
                if password != password2 {
                    showErrorAlertPasswordMatch()
                    return
                }
                
            } else {
                // alert about empty fields
                showErrorAlertEmpty()
            }
            
            
            
            Auth.auth().createUser(withEmail: email.lowercased(), password: password, completion: {result, error in
                if error == nil{
                    //MARK: the user creation is successful...
                    self.setNameOfTheUserInFirebaseAuth(name: name)
                }else{
                    //MARK: there is a error creating the user...
                    print(error)
                }
            })
            
            
            
            database.collection("Users").document(email.lowercased()).setData([
                "Name": name,
                "Balance": 1000.00
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
            database.collection("Users").document(email).collection("Stocks")
            
        }
    }
    
    //MARK: We set the name of the user after we create the account...
    func setNameOfTheUserInFirebaseAuth(name: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: {(error) in
            if error == nil{
                //MARK: hide the progress indicator...
                //MARK: the profile update is successful...
                
                // open portfolio
                let portfolioController = PortfolioController()
                self.navigationController?.pushViewController(portfolioController, animated: true)


            }else{
                //MARK: there was an error updating the profile...
                print("Error occured: \(String(describing: error))")
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
    
    func showErrorAlertPasswordMatch() {
        let alert = UIAlertController(title: "Error!", message: "Passwords must match", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alert, animated: true)
    }

    



}
