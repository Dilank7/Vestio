//
//  StockRow.swift
//  vestio
//
//  Created by Ben Lischin on 6/14/23.
//

import SwiftUI

struct StockRow: View {
    var stock: Stock
    
    var body: some View {
        VStack {
            //Show stock symbol
            Text(stock.symbol)
                .font(.title2)
                // Show stock price
                Text("$\(String(format: "%.2f", (stock.price)))")
                if stock.change < 0 {
                    Text("\(String(format: "%.2f", (stock.change)))").foregroundColor(Color.red)
//                        .background(Color.red)
                }else {
                    Text("+\(String(format: "%.2f", (stock.change)))").foregroundColor(Color.green)
//                        .background(Color.green)
                }
//                Text("\(String(format: "%.2f", (stock.change)))")
            }
        }
    }

