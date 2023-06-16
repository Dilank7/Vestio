//
//  LoginView.swift
//  vestio
//
//  Created by Ben Lischin on 6/12/23.
//

import UIKit

class LoginView: UIView {
    
    var textfieldEmail: UITextField!
    var textfieldPassword: UITextField!
    var login: UIButton!
    var labelMessage: UILabel!
    var create: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        // setup
        setupEmail()
        setupPassword()
        setupLogin()
        setupMessage()
        setupCreate()
        
        
        initConstraints()
    }
    
    
    func setupEmail() {
        textfieldEmail = UITextField()
        textfieldEmail.placeholder = "Email"
        textfieldEmail.keyboardType = .emailAddress
        textfieldEmail.borderStyle = .roundedRect
        textfieldEmail.autocorrectionType = .no
        textfieldEmail.autocapitalizationType = .none
        textfieldEmail.spellCheckingType = .no
        textfieldEmail.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textfieldEmail)
    }
    
    func setupPassword() {
        textfieldPassword = UITextField()
        textfieldPassword.placeholder = "Password"
        textfieldPassword.textContentType = .password
        textfieldPassword.isSecureTextEntry = true
        textfieldPassword.borderStyle = .roundedRect
        textfieldPassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textfieldPassword)
    }
    
    func setupLogin() {
        login = UIButton(type: .system)
        login.setTitle("Login", for: .normal)
        login.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(login)
    }
    
    func setupMessage() {
        labelMessage = UILabel()
        labelMessage.text = "Don't have an account yet?"
        labelMessage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelMessage)
    }
    
    func setupCreate() {
        create = UIButton(type: .system)
        create.setTitle("Create Account", for: .normal)
        create.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(create)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate(
            [
                textfieldEmail.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 128),
                textfieldEmail.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                textfieldEmail.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),

                
                textfieldPassword.topAnchor.constraint(equalTo: textfieldEmail.bottomAnchor, constant: 16),
                textfieldPassword.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                textfieldPassword.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),

                
                login.topAnchor.constraint(equalTo: textfieldPassword.bottomAnchor, constant: 16),
                login.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                
                labelMessage.topAnchor.constraint(equalTo: login.bottomAnchor, constant: 48),
                labelMessage.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                
                create.topAnchor.constraint(equalTo: labelMessage.bottomAnchor, constant: 16),
                create.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),

            ]
        )
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
