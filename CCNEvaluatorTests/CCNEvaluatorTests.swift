//
//  CCNEvaluatorTests.swift
//  CCNEvaluatorTests
//
//  Created by Никита on 08/09/2019.
//  Copyright © 2019 Никита. All rights reserved.
//

import XCTest
@testable import CCNEvaluator

class CCNEvaluatorTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
}

// MARK: Credit Card Number Validation
extension CCNEvaluatorTests {
    
    func testIsCreditCardNumberValid() {
        let validCardNumbers = [
            "4929804463622139", "6762765696545485", "6210948000000029",
            "373867484422390", "5019844570388446", "5129187892858887",
            "6011574229193527", "348570250878868", "5128888281063960",
            " 4716 0149 2948 1859 ", "55 233  355  605    502 4 3    "
        ]
        let invalidCardNumbers = [
            "4929804463622138", "5212132012291762", "8888888888888",
            "373867484422398", "6762765696545484", "6210948000000027",
            "0", "1234687", "0989098909890989", "6666666666666666",
            "ab1234??989898", "a 2 3 6789 b", "4129939187355598"
        ]
        
        validCardNumbers.forEach {
            let isValid = CCNEvaluator.isCreditCardNumberValid(creditCardNumber: $0)
            XCTAssertEqual(isValid, true, "\($0) should be validated as a correct one.")
        }
        
        invalidCardNumbers.forEach {
            let isValid = CCNEvaluator.isCreditCardNumberValid(creditCardNumber: $0)
            XCTAssertEqual(isValid, false, "\($0) shouldn't be validated as a correct one.")
        }
    }
    
    func testValidateOnlyNumbers() {
        let notANumbersStrings = ["str4929804463622139",
                                  "a b c d 87 t",
                                  "1A2B3C4D 1234 5678 ",
                                  "4949????49494949"]
        notANumbersStrings.forEach {
            let isValid = CCNEvaluator.validateOnlyNumbers(creditCardNumber: $0)
            XCTAssertEqual(isValid, false, "\($0) with not a numbers shouldn't be validated as a correct one.")
        }
    }
    
    func testValidateNoLeadingZero() {
        let leadingZeroString = "0"
        let isValid = CCNEvaluator.validateNoLeadingZero(creditCardNumber: leadingZeroString)
        XCTAssertEqual(isValid, false, "\(leadingZeroString) with leading zero shouldn't be validated as a correct one.")
    }
    
    func testValidateLength() {
        let wrongLengthStrings = ["49298044636", "49298044636221391234"]
        wrongLengthStrings.forEach {
            let isValid = CCNEvaluator.validateLength(creditCardNumber: $0)
            XCTAssertEqual(isValid, false, "\($0) is too short or long and shouldn't be validated as a correct one.")
        }
    }
    
    func testValidateWithLuhnCheck() {
        let validCardNumbers = [
            "4929804463622139", "6762765696545485", "6210948000000029",
            "373867484422390", "5019844570388446", "5129187892858887"
        ]
        let invalidCardNumbers = [
            "4929804463622138", "5212132012291762", "8888888888888",
            "373867484422398", "6762765696545484", "6210948000000027"
        ]
        
        validCardNumbers.forEach {
            let isValid = CCNEvaluator.validateWithLuhnCheck(creditCardNumber: $0)
            XCTAssertEqual(isValid, true, "\($0) should be validated as a correct one.")
        }
        
        invalidCardNumbers.forEach {
            let isValid = CCNEvaluator.validateWithLuhnCheck(creditCardNumber: $0)
            XCTAssertEqual(isValid, false, "\($0) shouldn't be validated as a correct one.")
        }
    }
    
}
