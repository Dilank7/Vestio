//
//  StockEdit.swift
//  vestio
//
//  Created by Ben Lischin on 6/14/23.
//

import SwiftUI

struct StockEdit: View {
    @EnvironmentObject var modelData: ModelData
    var stock: Stock
    
    var body: some View {
        HStack {
            //Show stock symbol
            Text(stock.symbol)
                .font(.title2)
            Spacer()
            
            // Remove stock button
            Button(action: {
                // Filters out all occurances of the stock symbol from the tickers array
                modelData.tickers = (modelData.tickers).filter(){$0 != stock.symbol}
                // Saves the updated ticker list in user default settings
                modelData.defaults.set(modelData.tickers, forKey: "Saved Array")
                modelData.load()
            }) {
                Text("Remove")
            }
        }
    }
}

