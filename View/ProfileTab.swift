//
//  ProfileTab.swift
//  vestio
//
//  Created by Dilan K on 6/19/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct ProfileTab: View {
    @EnvironmentObject var modelData: ModelData
    
    private var database = Firestore.firestore()
    private var currentUser: FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    
    @State private var stockAmounts: [Double?] = []
    @State private var stockPrices: [Double?] = []
    @State private var stockSybmols: [String?] = []
    @State private var currentBalance: Double = 0.0
    
    func fetchStockAmounts() {
        guard let stocks = modelData.stocks else { return }
        stockSybmols.removeAll()
        stockPrices.removeAll()
        stockAmounts.removeAll()
        
        for stock in stocks {
            fetchStockAmount(stock: stock) { amount in
                stockSybmols.append(stock.symbol)
                stockPrices.append(stock.price)
                stockAmounts.append(amount)
                
            }
        }
    }
    
    func fetchStockAmount(stock: Stock, completion: @escaping (Double) -> Void) {
        let userDocument = database.collection("Users").document(currentUser!.email!).collection("Stocks").document(stock.symbol)
        
        userDocument.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user document: \(error)")
                completion(0.0)
                return
            }
            
            guard let data = snapshot?.data() else {
                print("User document does not exist")
                completion(0.0)
                return
            }
            
            if let amount = data["Amount"] as? Double {
                DispatchQueue.main.async {
                    completion(amount)
                }
            }
        }
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
    
    func resetBalance() {
        stockSybmols.removeAll()
        stockPrices.removeAll()
        stockAmounts.removeAll()
        let userDocument = database.collection("Users").document(currentUser!.email!)
        
        // Update the balance to 1000
        userDocument.updateData(["Balance": 1000.0]) { error in
            if let error = error {
                print("Error updating balance: \(error)")
            } else {
                DispatchQueue.main.async {
                    currentBalance = 1000.0
                }
                print("Balance updated successfully")
            }
        }
        
        // Delete all documents in the stocks collection
        let stocksCollection = userDocument.collection("Stocks")
        stocksCollection.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching stock documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No stock documents found")
                return
            }
            
            let batch = self.database.batch()
            for document in documents {
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { error in
                if let error = error {
                    print("Error deleting stock documents: \(error)")
                } else {
                    print("Stock documents deleted successfully")
                }
            }
        }
    }
        
    var body: some View {
        VStack {
            Text(currentUser!.displayName!).bold().font(.title)
            Text("Balance: $\(String(format: "%.2f", currentBalance))").bold().font(.title2)
            ScrollView {
                if !stockSybmols.isEmpty {
                    ForEach(stockSybmols.indices, id: \.self) { index in
                        StockDisplay(stockSymbol: stockSybmols[index]!, stockPrice: stockPrices[index]!, stockAmount: stockAmounts[index]!)
                            .padding(10)
                        Divider()
                    }
                } else {
                    Text("Respectfully, your money is not up 😐😐. Add stocks to get rich 🥶😈🔥!")
                        .multilineTextAlignment(.center)
                        .frame(width: 300, alignment: .center)
                        .padding(.top, 200)
                }
            }
            
            Button(action: {
                resetBalance()
            }) {
                Text("Reset")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .font(.title2)
                    .cornerRadius(10)
            }
        }
        .navigationTitle(currentUser!.displayName!)
        .onAppear {
            fetchStockAmounts()
            fetchBalance()
        }
    }
}
