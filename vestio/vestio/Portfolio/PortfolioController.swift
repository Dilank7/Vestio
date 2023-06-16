//
//  PortfolioController.swift
//  vestio
//
//  Created by Ben Lischin on 6/12/23.
//

import UIKit
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class PortfolioController: UIViewController {

    let portfolioScreen = PortfolioView()
    let modelData = ModelData()

    var currentUser:FirebaseAuth.User! = Auth.auth().currentUser
    
    override func loadView() {
        view = portfolioScreen
    }

    


    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = currentUser.displayName
        
        // hide the back button so they have to logout to get to the login screen again
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // logout button top right
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutFunc))

 
        let controller = UIHostingController(rootView: ContentView().environmentObject(ModelData()))
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc func logoutFunc(){
        let logoutAlert = UIAlertController(title: "Logging out!", message: "Are you sure want to log out?",
            preferredStyle: .actionSheet)
        logoutAlert.addAction(UIAlertAction(title: "Yes, log out!", style: .default, handler: {(_) in
                do{
                    try Auth.auth().signOut()
                    self.navigationController?.popToRootViewController(animated: true)

                }catch{
                    print("Error occured!")
                }
            })
                              
        )
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(logoutAlert, animated: true)
    }
    



}
