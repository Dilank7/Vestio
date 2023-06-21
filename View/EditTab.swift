//
//  EditTab.swift
//  vestio
//
//  Created by Ben Lischin on 6/14/23.
//

import SwiftUI

struct EditTab: View {
    @EnvironmentObject var modelData: ModelData
    @State var stockName: String = ""
    
    var body: some View {
        VStack {
            VStack {
                // Text field to get user input on stocks to add, saved to stockName
                HStack {
                    TextField("Search for a stock by ticker", text: $stockName)
                        .textFieldStyle(PlainTextFieldStyle())
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 200, alignment: .center)
                        .accentColor(.blue)
                        .foregroundColor(.blue)
                        .bold()
                        .font(Font.system(size: 15))
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.purple, lineWidth: 2)
                                        .padding(.vertical, 15)
                                )
//                     Adds the user inputted ticker to modelData.tickers on button press
//                       does not check for duplicates or if the ticker is valid
                    Button(action: {
                        let newStock = stockName.uppercased()
                        stockName = ""
                        modelData.tickers.append(newStock)
                        // Saves the updated ticker list in user default settings
                        modelData.defaults.set(modelData.tickers, forKey: "Saved Array")
                        modelData.load()
                    }){
                        Image(systemName: "plus.magnifyingglass")
                            .multilineTextAlignment(.center)
                    }
                }
            }
            
            ScrollView{
                //Checks if stock data exists
                if modelData.stocks != nil {
                    //Loops through each stock and shows the StockEdit view
                    ForEach(modelData.stocks!) { stock in
                        StockEdit(stock: stock)
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
        }.navigationTitle("Search")
    }
}
