//
//  Country.swift
//  Trvlr
//
//  Created by Vo Huy on 8/6/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import Foundation

typealias Country = [String: CountryValue]

struct CountryValue: Codable {
    let name, native, phone: String
    let continent: Continent.CodingKeys
    let capital, currency: String
    let languages: [String]
}

class CountryData: Codable {
    let name, capital, currency: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case capital
        case currency
    }
    
    init(name: String, capital: String, currency: String) {
        self.name = name
        self.capital = capital
        self.currency = currency
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        capital = try container.decode(String.self, forKey: .capital)
        currency = try container.decode(String.self, forKey: .currency)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(capital, forKey: .capital)
        try container.encode(currency, forKey: .currency)
    }
}
