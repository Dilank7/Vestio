//
//  MainTab.swift
//  vestio
//
//  Created by Ben Lischin on 6/14/23.
//

import SwiftUI



struct MainTab: View {
    @EnvironmentObject var modelData: ModelData
    
    func createGrid() -> [GridItem] {
        let columns = [
            GridItem(.fixed(120), spacing: 16),
            GridItem(.fixed(120), spacing: 16),
            GridItem(.fixed(120), spacing: 16)]
        return columns
    }
    
    var body: some View {
        ScrollView {
            // Check if stock data exists
            if let stocks = modelData.stocks {
                // Loop through each stock and show the StockRow view for the stock
                LazyVGrid(columns: createGrid(), spacing: 20) {
                    ForEach(stocks) { stock in
                        NavigationLink(destination: StockDetailScreen(stock: stock)) {
                            StockRow(stock: stock)
                                .padding(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.green, lineWidth: 4)
                                )
                        }
                    }
                }
                .padding(.top, 20)
            } else {
                Text("You aren't tracking any stocks 😔! Be sure to check out the search page some time!!!")
                    .multilineTextAlignment(.center)
                    .frame(width: 300, alignment: .center)
                    .padding(.top, 200)
            }
        }
        .padding(.top, 20)
    }
}
