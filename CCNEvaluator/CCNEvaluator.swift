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
    
    /**
     * @brief Returns network type (card type) of credit card
                validating prefix specifications only
     * @param creditCardNumber Credit card number
     * @return String Credit card network type (can be recognized only
                        amongst the cases of CardNetworkType enumeration)
     **/
    class func getCreditCardNumberNetworkType(creditCardNumber number: String) -> String {
        let number = number.removeAllWhitespacesAndNewlines()
        
        return CardNetworkType.type(for: number, checkFromTypes: CardNetworkType.allCases).rawValue
    }
    
    // `CardNetworkType` is the credit card network type name,
    // used to name concrete card network type
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
        
        /**
         * @brief Returns specifications for concrete network type
         **/
        private var specifications: CCNNetworkTypeSpecifications {
            return CCNNetworkTypeSpecifications(with: self)
        }
        
        /**
         * @brief Checks given credit card number satisfies
                    concrete network type specification conditions
         * @param type Credit card network type
         * @param creditCardNumber Credit card number
         * @return Bool `true` if checking was passed, `false` otherwise
         **/
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
        
        /**
         * @brief Returns result network type which was defined
                    by validating to specifications of different types
         * @param creditCardNumber Credit card number
         * @param types Credit card network types which necessary to check
         * @return CardNetworkType result network type (included not recognized case)
         **/
        static func type(for creditCardNumber: String, checkFromTypes types: [CardNetworkType]) -> CardNetworkType {
            var resultType: CardNetworkType = .notRecognized
            for type in types {
                if validateSpecifications(for: type, and: creditCardNumber) {
                    resultType = type
                    break
                }
            }
            return resultType
        }
        
    }
    
}

// MARK: Obtaining additional information about credit card through https://binlist.net API
public extension CCNEvaluator {
    
    /**
     * @brief Retrieves additional information about credit card using https://binlist.net API
     * @param creditCardNumber Credit card number
     * @param completion Use this completion block for getting result information string
     **/
    class func getCreditCardAdditionalInformation(creditCardNumber number: String, _ completion: @escaping (String) -> Void) {
        let number = number.removeAllWhitespacesAndNewlines()
        
        getInformation(creditCardNumber: number) { informationString, errorDescription in
            guard errorDescription == nil, let informationString = informationString else { completion(errorDescription ?? ""); return }
            completion(informationString)
        }
    }
    
    /**
     * @brief Retrieves additional information about credit card:
                uses APIClient instance for request performing,
                checks status code,
                also performs decoding to corresponding model
     * @param creditCardNumber Credit card number
     * @param completion Use this completion block for getting
                            result information string or
                            error description string
     **/
    internal class func getInformation(creditCardNumber number: String, _ completion: @escaping (String?, String?) -> Void) {
        var informationString = Const.informationIsNotFoundString
        
        APIClient().perform(APIRequest(method: .get, path: number)) { result in
            
            switch result {
            case .success(let response):
                if let statusCode = response.statusCode {
                    switch statusCode {
                    case .notFound:
                        completion(nil, String(format: Const.errorPatternString, informationString))
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

// MARK: Filtering credit card numbers list
public extension CCNEvaluator {
    
    /**
     * @brief Performs filtering credit card numbers list using different flags
     * @param list Credit card numbers list
     * @param useValidating Flag for use validating as a criteria for filtering
     * @param useConcreteTypes Concrete card network types list which will be used
                                as a criteria for filtering
                                (pass nil or [] if you don't want to use this criteria)
     * @return [String] Filtered credit card numbers list
     **/
    class func filterCreditCardNumbersList(list: [String], useValidating: Bool, useConcreteTypes: [String]?) -> [String] {
        var list = list
        if useValidating {
            list = list.filter { isCreditCardNumberValid(creditCardNumber: $0) }
        }
        if let useConcreteTypes = useConcreteTypes, !useConcreteTypes.isEmpty {
            let networkTypes = useConcreteTypes.compactMap { CardNetworkType(rawValue: $0) }
            list = list.filter { CardNetworkType.type(for: $0, checkFromTypes: networkTypes) != .notRecognized }
        }
        return list
    }
    
}

private extension CCNEvaluator {
    private enum Const {
        static let zeroString = "0"
        static let creditCardNumberMinimumLength = 12
        static let creditCardNumberMaximumLength = 19
        
        static let informationIsNotFoundString = "no information about this card"
        static let errorPatternString = "Error: %@"
        static let failedToDecodeString = "failed to decode response"
    }
}
