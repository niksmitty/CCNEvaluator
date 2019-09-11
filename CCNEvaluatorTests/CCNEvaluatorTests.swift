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

    let americanExpressNumbers = [
        "373867484422390", "377959119526293", "342030949859361",
        "378809096932924", "340598394858882", "345459348424609",
        "372313178485220", "370497105866404", "347914242888828"
    ]
    
    let chinaUnionPayNumbers = [
        "628792352293160380", "6270750418488099", "6210495938538187145",
        "627202623540178185", "6223172985756695513", "626679030981179027",
        "6294768219475815162", "62710712943677758", "62710712943677758"
    ]
    
    let dinersClubNumbers = [
        "30362723320576", "38839617015257", "30087439675753",
        "30067597907446", "38861398148347", "36083937810426",
        "30127375921801", "30317110158260", "30253658981898"
    ]
    
    let discoverNumbers = [
        "6011243526028329", "6011805052205610", "6011295761811736",
        "6011925617967577", "6011602231112746", "6011830444184299",
        "6011386781305583", "6011798934501878", "6011713578534887"
    ]
    
    let jcbNumbers = [
        "3528062122672865", "3528732131260577", "3528130273272254",
        "3529436157866312", "3529044702880703", "3529881648108024",
        "3530028330154281", "3530007072603416", "3530826104585063",
        "3538134440571448", "3538528721470602", "3538528721470602",
        "3538134440571448", "3538528721470602", "3538553155017166",
        "3589747852651222", "3589455441381166", "3589557082574742"
    ]
    
    let maestroNumbers = [
        "5001727212047753", "5088086101551532", "5053250127402556",
        "5611441871300535", "5672202511820084", "5655020164413887",
        "5721672747164328", "5726427502763664", "5761164217371006",
        "5855743556375467", "5843654858187523", "5865524782687356",
        "6145470530287158", "6181166256453322", "6136687433182548",
        "6881043201118156", "6821260765587286", "6886553365358864",
        "6921234438756007", "6913627014864535", "6972322312800062"
    ]
    
    let masterCardNumbers = [
        "5129187892858887", "5316089796332584", "5324168430436389",
        "5430534412386192", "5357811976339638", "5492842318918850",
        "5327977939468223", "5517428927289239", "5243501311144896"
    ]
    
    let mirNumbers = [
        "2200678300296055", "2202794092915550", "2203848645773170",
        "2204958151637037", "2202785141782520", "2203132163992153",
        "2203871283907090", "2201404524317271", "2201404524317271"
    ]
    
    let visaNumbers = [
        "4916743482352895", "4929115173208766", "4929111150993017",
        "4532569705997925", "4532532346704936", "4539449005266755",
        "4539647967252222", "4485278059645588", "4716218684717841",
        "4916312540852", "4875293328226", "4539363085138",
        "4485124016097", "4485888470472", "4532619444738",
        "4556744269496", "4929217824669", "4485303685779"
    ]
    
    let unknownBrandNumbers = [
        "9792305016254606", "9792586724588905", "9792009260907408",
        "9792134617929448", "9792470409935446", "9792529232400971",
        "9792706877726349", "9792405682664009", "9792405682664009"
    ]
    
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

// MARK: Definition the type of network to which credit card number belongs
extension CCNEvaluatorTests {
    
    func testGetCreditCardNumberNetworkTypeForAmericanExpress() {
        americanExpressNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertEqual(CCNEvaluator.CardNetworkType.americanExpress.rawValue, recognizedType, "\($0) should be recognized as American Express.")
        }
        mirNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertNotEqual(CCNEvaluator.CardNetworkType.americanExpress.rawValue, recognizedType, "\($0) shouldn't be recognized as American Express.")
        }
    }
    
    func testGetCreditCardNumberNetworkTypeForChinaUnionPay() {
        chinaUnionPayNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertEqual(CCNEvaluator.CardNetworkType.chinaUnionPay.rawValue, recognizedType, "\($0) should be recognized as China Union Pay.")
        }
        mirNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertNotEqual(CCNEvaluator.CardNetworkType.chinaUnionPay.rawValue, recognizedType, "\($0) shouldn't be recognized as China Union Pay.")
        }
    }
    
    func testGetCreditCardNumberNetworkTypeForDinersClub() {
        dinersClubNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertEqual(CCNEvaluator.CardNetworkType.dinersClub.rawValue, recognizedType, "\($0) should be recognized as Diners Club.")
        }
        mirNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertNotEqual(CCNEvaluator.CardNetworkType.dinersClub.rawValue, recognizedType, "\($0) shouldn't be recognized as Diners Club.")
        }
    }
    
    func testGetCreditCardNumberNetworkTypeForDiscover() {
        discoverNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertEqual(CCNEvaluator.CardNetworkType.discover.rawValue, recognizedType, "\($0) should be recognized as Discover.")
        }
        mirNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertNotEqual(CCNEvaluator.CardNetworkType.discover.rawValue, recognizedType, "\($0) shouldn't be recognized as Discover.")
        }
    }
    
    func testGetCreditCardNumberNetworkTypeForJCB() {
        jcbNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertEqual(CCNEvaluator.CardNetworkType.jcb.rawValue, recognizedType, "\($0) should be recognized as JCB.")
        }
        mirNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertNotEqual(CCNEvaluator.CardNetworkType.jcb.rawValue, recognizedType, "\($0) shouldn't be recognized as JCB.")
        }
    }
    
    func testGetCreditCardNumberNetworkTypeForMaestro() {
        maestroNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertEqual(CCNEvaluator.CardNetworkType.maestro.rawValue, recognizedType, "\($0) should be recognized as Maestro.")
        }
        mirNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertNotEqual(CCNEvaluator.CardNetworkType.maestro.rawValue, recognizedType, "\($0) shouldn't be recognized as Maestro.")
        }
    }
    
    func testGetCreditCardNumberNetworkTypeForMastercard() {
        masterCardNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertEqual(CCNEvaluator.CardNetworkType.mastercard.rawValue, recognizedType, "\($0) should be recognized as Mastercard.")
        }
        mirNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertNotEqual(CCNEvaluator.CardNetworkType.mastercard.rawValue, recognizedType, "\($0) shouldn't be recognized as Mastercard.")
        }
    }
    
    func testGetCreditCardNumberNetworkTypeForMIR() {
        mirNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertEqual(CCNEvaluator.CardNetworkType.mir.rawValue, recognizedType, "\($0) should be recognized as MIR.")
        }
        masterCardNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertNotEqual(CCNEvaluator.CardNetworkType.mir.rawValue, recognizedType, "\($0) shouldn't be recognized as MIR.")
        }
    }
    
    func testGetCreditCardNumberNetworkTypeForVisa() {
        visaNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertEqual(CCNEvaluator.CardNetworkType.visa.rawValue, recognizedType, "\($0) should be recognized as Visa.")
        }
        mirNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertNotEqual(CCNEvaluator.CardNetworkType.visa.rawValue, recognizedType, "\($0) shouldn't be recognized as Visa.")
        }
    }
    
    func testGetCreditCardNumberNetworkTypeForUnknown() {
        unknownBrandNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertEqual(CCNEvaluator.CardNetworkType.notRecognized.rawValue, recognizedType, "\($0) should be recognized as `Not recognized`.")
        }
        mirNumbers.forEach {
            let recognizedType = CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)
            XCTAssertNotEqual(CCNEvaluator.CardNetworkType.notRecognized.rawValue, recognizedType, "\($0) shouldn't be recognized as `Not recognized`.")
        }
    }
    
}
