//
//  ModelData.swift
//  vestio
//
//  Created by Ben Lischin on 6/14/23.
//

import Foundation
import Combine

class ModelData: ObservableObject {
    @Published var stocks: [Stock]?
    @Published var tickers: [String] = ["AAPL","GOOG"]
    // Support for saving user settings
    let defaults = UserDefaults.standard
    
    init() {
        // Assign tickers to be previously saved tickers if any
        tickers = defaults.array(forKey: "Saved Array") as? [String] ?? tickers
        self.load()
    }
    func load(){
        let apiKey = "0d36cb23e8d0fd3aafc549f2db74781a"
        var stockArray: [Stock] = []
        if(tickers.count != 0) {
            for i in tickers.indices {
                parseStock(tickerIndex: i, apiKey: apiKey) { (parsedStock) in
                    stockArray.append(parsedStock)
                    self.stocks = stockArray
                }
            }
        }
        // Empty ticker list
        else {
            self.stocks = nil
        }
    }
    func parseStock(tickerIndex: Int, apiKey: String, completed: @escaping (Stock) -> Void) {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/quote/\(tickers[tickerIndex])?apikey=\(apiKey)")
        else {
            fatalError("Invalid URL.")
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if error == nil && data != nil {
                    let decoder = JSONDecoder()
                    let stocksData = try decoder.decode([Stock].self, from: data!)
                    DispatchQueue.main.async {
                        if(stocksData.count > 0) {
                            completed(stocksData[0])
                        }
                    }
                }
            }
            catch {
                print("Couldn't parse JSON as Stocks:\n\(error)")
            }
        }
        .resume()
    }
}




