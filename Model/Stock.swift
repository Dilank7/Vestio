//
//  Stock.swift
//  vestio
//
//  Created by Ben Lischin on 6/14/23.
//

import Foundation

// Structure for storing stock information
struct Stock: Identifiable, Decodable {
    
    // Unique ID for each struct
    let id = UUID()
    
    let symbol: String
    let price: Double
    let change: Double
    
    // CodingKey to ignore id when decoding
    enum CodingKeys : String, CodingKey {
        case symbol
        case price
        case change
    }
}
