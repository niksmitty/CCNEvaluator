//
//  CCNEvaluator.swift
//  CCNEvaluator
//
//  Created by Никита on 08/09/2019.
//  Copyright © 2019 Никита. All rights reserved.
//

import UIKit

public class CCNEvaluator {
    
    
    
}

// MARK: Credit Card Number Validation
public extension CCNEvaluator {
    
    /**
     * @brief Validates given credit card number, checking different conditions,
                e.g. containing only numbers, starting with no leading zero etc.,
                also validating number using Luhn algorithm
     * @param creditCardNumber Credit card number
     * @return Bool `true` if validation was passed, `false` otherwise
     **/
    class func isCreditCardNumberValid(creditCardNumber number: String) -> Bool {
        let number = number.removeAllWhitespacesAndNewlines()
        
        guard
            validateOnlyNumbers(creditCardNumber: number),
            validateNoLeadingZero(creditCardNumber: number),
            validateLength(creditCardNumber: number),
            validateWithLuhnCheck(creditCardNumber: number) else { return false }
        
        return true
    }
    
    /**
     * @brief Checks given credit card number contains only numbers
     * @param creditCardNumber Credit card number
     * @return Bool `true` if checking was passed, `false` otherwise
     **/
    internal class func validateOnlyNumbers(creditCardNumber number: String) -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: number))
    }
    
    /**
     * @brief Checks given credit card number hasn't leading zero
     * @param creditCardNumber Credit card number
     * @return Bool `true` if checking was passed, `false` otherwise
     **/
    internal class func validateNoLeadingZero(creditCardNumber number: String) -> Bool {
        return !number.hasPrefix(Const.zeroString)
    }
    
    /**
     * @brief Checks given credit card number length satisfies the specified limits
     * @param creditCardNumber Credit card number
     * @return Bool `true` if checking was passed, `false` otherwise
     **/
    internal class func validateLength(creditCardNumber number: String) -> Bool {
        let length = number.count
        return length >= Const.creditCardNumberMinimumLength && length <= Const.creditCardNumberMaximumLength
    }
    
    /**
     * @brief Checks given credit card number satisfies Luhn algorithm
     * @param creditCardNumber Credit card number
     * @return Bool `true` if checking was passed, `false` otherwise
     **/
    internal class func validateWithLuhnCheck(creditCardNumber number: String) -> Bool {
        var sum = 0
        let digitStrings = number.reversed().map { String($0) }
        
        for digitString in digitStrings.enumerated() {
            if let digit = Int(digitString.element) {
                let odd = digitString.offset % 2 == 1
                
                switch (odd, digit) {
                case (true, 9):
                    sum += 9
                case (true, 0...8):
                    sum += (digit * 2) % 9
                default:
                    sum += digit
                }
            } else {
                return false
            }
        }
        
        return sum % 10 == 0
    }
    
}

// MARK: Definition the type of network to which credit card number belongs
public extension CCNEvaluator {
    
    class func getCreditCardNumberNetworkType(creditCardNumber number: String) -> String {
        let number = number.removeAllWhitespacesAndNewlines()
        
        return CardNetworkType.type(for: number)
    }
    
    internal enum CardNetworkType: String, CaseIterable {
        
        case americanExpress = "American Express"
        case chinaUnionPay = "China Union Pay"
        case dinersClub = "Diners Club"
        case discover = "Discover"
        case jcb = "JCB"
        case maestro = "Maestro"
        case mastercard = "Mastercard"
        case mir = "MIR"
        case visa = "Visa"
        case notRecognized = "Not recognized"
        
        private var specifications: CCNNetworkTypeSpecifications {
            return CCNNetworkTypeSpecifications(with: self)
        }
        
        private static func validateSpecifications(for type: CardNetworkType, and creditCardNumber: String) -> Bool {
            var isValid = false
            for prefix in type.specifications.prefixes {
                if creditCardNumber.count >= prefix.length {
                    let numberPrefix = creditCardNumber.prefix(prefix.length)
                    if let number = Int(numberPrefix), number >= prefix.rangeStart, number <= prefix.rangeEnd {
                        isValid = true
                        break
                    }
                }
            }
            return isValid
        }
        
        static func type(for creditCardNumber: String) -> String {
            var resultType: CardNetworkType = .notRecognized
            for type in CardNetworkType.allCases {
                if validateSpecifications(for: type, and: creditCardNumber) {
                    resultType = type
                    break
                }
            }
            return resultType.rawValue
        }
        
    }
    
}

// MARK: Obtaining additional information about credit card through https://binlist.net API
public extension CCNEvaluator {
    
    class func getCreditCardAdditionalInformation(creditCardNumber number: String, _ completion: @escaping (String) -> Void) {
        let number = number.removeAllWhitespacesAndNewlines()
        
        getInformation(creditCardNumber: number) { informationString, errorDescription in
            guard errorDescription == nil, let informationString = informationString else { completion(errorDescription ?? ""); return }
            completion(informationString)
        }
    }
    
    internal class func getInformation(creditCardNumber number: String, _ completion: @escaping (String?, String?) -> Void) {
        var informationString = Const.informationIsNotFoundString
        
        APIClient().perform(APIRequest(method: .get, path: number)) { result in
            
            switch result {
            case .success(let response):
                if let statusCode = response.statusCode {
                    switch statusCode {
                    case .notFound:
                        completion(informationString, nil)
                        return
                    }
                }
                if let response = try? response.decode(to: CreditCardInformation.self) {
                    let creditCardInformation = response.body
                    informationString = creditCardInformation.getDescriptionString()
                    completion(informationString, nil)
                } else {
                    completion(nil, String(format: Const.errorPatternString, Const.failedToDecodeString))
                }
            case .failure(let error):
                completion(nil, String(format: Const.errorPatternString, error.localizedDescription))
            }
            
        }
    }
    
}

private extension CCNEvaluator {
    private enum Const {
        static let zeroString = "0"
        static let creditCardNumberMinimumLength = 12
        static let creditCardNumberMaximumLength = 19
        
        static let informationIsNotFoundString = "No information about this card"
        static let errorPatternString = "Error: %@"
        static let failedToDecodeString = "failed to decode response"
    }
}
