//
//  CreditCardInformation.swift
//  CCNEvaluator
//
//  Created by Никита on 11/09/2019.
//  Copyright © 2019 Никита. All rights reserved.
//

struct CreditCardInformation: Decodable {
    let scheme: String
    let type: String
    let brand: String
    let country: Country
    let bank: Bank
    
    func getDescriptionString() -> String {
        return """
        Additional information:
        \tscheme - \(scheme),
        \ttype - \(type),
        \tbrand - \(brand),
        \tcountry - \(country.name) \(country.emoji),
        \tbank - \(bank.name ?? "bank name not found")
        """
    }
}

struct Country: Decodable {
    let name: String
    let emoji: String
}

struct Bank: Decodable {
    let name: String?
}
