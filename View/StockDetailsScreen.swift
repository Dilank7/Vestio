//
//  StockDetailsScreen.swift
//  vestio
//
//  Created by Dilan K on 6/21/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI

struct StockDetailScreen: View {
    let stock: Stock
    @State private var amountString: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentBalance: Double = 0.0
    @State private var amountOwned: Double = 0
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private var database = Firestore.firestore()
    private var currentUser: FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
        
    
    init(stock: Stock) {
        self.stock = stock
    }
    
    func fetchBalance() {
        let userDocument = database.collection("Users").document(currentUser!.email!)
        
        userDocument.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user document: \(error)")
                return
            }
            
            guard let data = snapshot?.data() else {
                print("User document does not exist")
                return
            }
            
            if let balance = data["Balance"] as? Double {
                DispatchQueue.main.async {
                    currentBalance = balance
                }
                print(balance)
            }
        }
    }
    
    
    func fetchStockAmount() {
        let userDocument = database.collection("Users").document(currentUser!.email!).collection("Stocks").document(stock.symbol)
        
        userDocument.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user document: \(error)")
                return
            }
            
            guard let data = snapshot?.data() else {
                print("User document does not exist")
                amountOwned = 0
                return
            }
            
            if let amount = data["Amount"] as? Double {
                DispatchQueue.main.async {
                    amountOwned = amount
                }
            }
        }
    }
    
    func buyStock() {
        fetchStockAmount()
        fetchBalance()
        if let amountDouble = Double(amountString) {
            if ((amountDouble * stock.price) > currentBalance) {
                alertMessage = "Not enough money"
                showAlert = true
            } else {
                let amountAdd: [String: Any] = [
                    "Amount": (amountOwned + amountDouble),
                ]
                let newBalanceSubtract: [String: Any] = [
                    "Balance": (currentBalance - (amountDouble * stock.price)),
                    "Name": currentUser!.displayName!
                ]
                database.collection("Users").document(currentUser!.email!).collection("Stocks").document(stock.symbol).setData(amountAdd, merge: true) { error in
                    if let error = error {
                        alertMessage = "Error adding fields: \(error)"
                        showAlert = true
                    } else {
                        print("Fields added successfully!")
                    }
                }
                database.collection("Users").document(currentUser!.email!).setData(newBalanceSubtract, merge: true) { error in
                    if let error = error {
                        alertMessage = "Error adding fields: \(error)"
                        showAlert = true
                    } else {
                        print("Fields added successfully!")
                    }
                }
                presentationMode.wrappedValue.dismiss() // Pop the navigation view
            }
        } else {
            alertMessage = "invalid input for amount"
            showAlert = true
        }
        
    }
    
    
    func sellStock() {
        fetchStockAmount()
        fetchBalance()
        if let amountDouble = Double(amountString) {
            if (amountDouble > amountOwned) {
                alertMessage = "Not enough stock owned"
                showAlert = true
            } else {
                let amountSubtract: [String: Any] = [
                    "Amount": (amountOwned - amountDouble),
                ]
                let newBalanceAdd: [String: Any] = [
                    "Balance": (currentBalance + (amountDouble * stock.price)),
                    "Name": currentUser!.displayName!
                ]
                database.collection("Users").document(currentUser!.email!).collection("Stocks").document(stock.symbol).setData(amountSubtract, merge: true) { error in
                    if let error = error {
                        print("Error adding fields: \(error)")
                    } else {
                        print("Fields added successfully!")
                    }
                }
                database.collection("Users").document(currentUser!.email!).setData(newBalanceAdd, merge: true) { error in
                    if let error = error {
                        print("Error adding fields: \(error)")
                    } else {
                        print("Fields added successfully!")
                    }
                }
                presentationMode.wrappedValue.dismiss() // Pop the navigation view
            }
        } else {
            alertMessage = "invalid input for amount"
            showAlert = true
        }
        
    }
    
    
    var body: some View {
        VStack {
            // Display the stock information
            Text("Price: $\(String(format: "%.2f", stock.price))").bold().font(.title2)
//            if let userData = userData {
            Text("Amount owned: \(String(format: "%.2f", amountOwned))").bold().font(.title2)
            Text("Balance: $\(String(format: "%.2f", currentBalance))").bold().font(.title2)
//            }
            
            // Add an input field for the amount
            TextField("Amount", text: $amountString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Button(action: {
                    // Perform buy action here
                    buyStock()
                }) {
                    Text("Buy")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // Perform sell action here
                    sellStock()
                }) {
                    Text("Sell")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle(stock.symbol)
        .onAppear {
            fetchBalance()
            fetchStockAmount()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
