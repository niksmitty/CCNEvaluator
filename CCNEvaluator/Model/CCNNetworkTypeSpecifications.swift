//
//  CCNNetworkTypeSpecifications.swift
//  CCNEvaluator
//
//  Created by Никита on 09/09/2019.
//  Copyright © 2019 Никита. All rights reserved.
//

struct CCNNetworkTypeSpecifications {
    let prefixes: [CCNPrefix]
    let lengths: [Int]
}

extension CCNNetworkTypeSpecifications {
    
    init(with cardNetworkType: CCNEvaluator.CardNetworkType) {
        var specifications: (prefixes: [CCNPrefix], lengths: [Int]) = ([], [])
        switch cardNetworkType {
        case .americanExpress:
            specifications = CCNNetworkTypeSpecifications.americanExpressSpecifications()
        case .chinaUnionPay:
            specifications = CCNNetworkTypeSpecifications.chinaUnionPaySpecifications()
        case .dinersClub:
            specifications = CCNNetworkTypeSpecifications.dinersClubSpecifications()
        case .discover:
            specifications = CCNNetworkTypeSpecifications.discoverSpecifications()
        case .jcb:
            specifications = CCNNetworkTypeSpecifications.jcbSpecifications()
        case .maestro:
            specifications = CCNNetworkTypeSpecifications.maestroSpecifications()
        case .mastercard:
            specifications = CCNNetworkTypeSpecifications.mastercardSpecifications()
        case .mir:
            specifications = CCNNetworkTypeSpecifications.mirSpecifications()
        case .visa:
            specifications = CCNNetworkTypeSpecifications.visaSpecifications()
        case .notRecognized:
            break
        }
        self.init(prefixes: specifications.prefixes, lengths: specifications.lengths)
    }
    
    /* these specifications are taken from https://en.wikipedia.org/wiki/Payment_card_number */
    
    private static func americanExpressSpecifications() -> (prefixes: [CCNPrefix], lengths: [Int]) {
        return (
            prefixes: [CCNPrefix(rangeStart: 34, rangeEnd: 34, length: 2),
                       CCNPrefix(rangeStart: 37, rangeEnd: 37, length: 2)],
            lengths: [15]
        )
    }
    
    private static func chinaUnionPaySpecifications() -> (prefixes: [CCNPrefix], lengths: [Int]) {
        return (
            prefixes: [CCNPrefix(rangeStart: 62, rangeEnd: 62, length: 2)],
            lengths: [16, 17, 18, 19]
        )
    }
    
    private static func dinersClubSpecifications() -> (prefixes: [CCNPrefix], lengths: [Int]) {
        return (
            prefixes: [CCNPrefix(rangeStart: 300, rangeEnd: 305, length: 3),
                       CCNPrefix(rangeStart: 3095, rangeEnd: 3095, length: 4),
                       CCNPrefix(rangeStart: 36, rangeEnd: 36, length: 2),
                       CCNPrefix(rangeStart: 38, rangeEnd: 39, length: 2)],
            lengths: [14]
        )
    }
    
    private static func discoverSpecifications() -> (prefixes: [CCNPrefix], lengths: [Int]) {
        return (
            prefixes: [CCNPrefix(rangeStart: 6011, rangeEnd: 6011, length: 4),
                       CCNPrefix(rangeStart: 622126, rangeEnd: 622925, length: 6),
                       CCNPrefix(rangeStart: 624000, rangeEnd: 626999, length: 6),
                       CCNPrefix(rangeStart: 628200, rangeEnd: 628899, length: 6),
                       CCNPrefix(rangeStart: 64, rangeEnd: 64, length: 2),
                       CCNPrefix(rangeStart: 65, rangeEnd: 65, length: 2)],
            lengths: [16, 17, 18, 19]
        )
    }
    
    private static func jcbSpecifications() -> (prefixes: [CCNPrefix], lengths: [Int]) {
        return (
            prefixes: [CCNPrefix(rangeStart: 3528, rangeEnd: 3589, length: 4)],
            lengths: [16, 17, 18, 19]
        )
    }
    
    private static func maestroSpecifications() -> (prefixes: [CCNPrefix], lengths: [Int]) {
        return (
            prefixes: [CCNPrefix(rangeStart: 50, rangeEnd: 50, length: 2),
                       CCNPrefix(rangeStart: 56, rangeEnd: 69, length: 2)],
            lengths: [12, 13, 14, 15, 16, 17, 18, 19]
        )
    }
    
    private static func mastercardSpecifications() -> (prefixes: [CCNPrefix], lengths: [Int]) {
        return (
            prefixes: [CCNPrefix(rangeStart: 2221, rangeEnd: 2720, length: 4),
                       CCNPrefix(rangeStart: 51, rangeEnd: 55, length: 2)],
            lengths: [16]
        )
    }
    
    private static func mirSpecifications() -> (prefixes: [CCNPrefix], lengths: [Int]) {
        return (
            prefixes: [CCNPrefix(rangeStart: 2200, rangeEnd: 2204, length: 4)],
            lengths: [16]
        )
    }
    
    private static func visaSpecifications() -> (prefixes: [CCNPrefix], lengths: [Int]) {
        return (
            prefixes: [CCNPrefix(rangeStart: 4, rangeEnd: 4, length: 1)],
            lengths: [16]
        )
    }
    
}
