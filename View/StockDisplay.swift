//
//  StockDisplay.swift
//  vestio
//
//  Created by Dilan K on 6/21/23.
//

import Foundation
import SwiftUI

struct StockDisplay: View {
    @EnvironmentObject var modelData: ModelData
    let stockSymbol: String
    let stockPrice: Double
    let stockAmount: Double
    
    init(stockSymbol: String, stockPrice: Double, stockAmount: Double) {
        self.stockSymbol = stockSymbol
        self.stockPrice = stockPrice
        self.stockAmount = stockAmount
    }
    
    var body: some View {
        HStack {
            //Show stock symbol
            Text(stockSymbol)
                .font(.title2)
            Spacer()
            Text("$\(String(format: "%.2f", (stockPrice)))")
            
            Spacer()
            Text("\(String(format: "%.2f", (stockAmount)))")
            
        }
    }
}

