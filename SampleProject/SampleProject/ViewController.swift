//
//  ViewController.swift
//  SampleProject
//
//  Created by Никита on 12/09/2019.
//  Copyright © 2019 Никита. All rights reserved.
//

import UIKit
import CCNEvaluator

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let creditCardNumbers = ["4929804463622139",
                                 "4929804463622138",
                                 "6762765696545485",
                                 "5212132012291762",
                                 "6210948000000029"]
        
        creditCardNumbers.forEach { print(CCNEvaluator.isCreditCardNumberValid(creditCardNumber: $0)) }
        
        creditCardNumbers.forEach { print(CCNEvaluator.getCreditCardNumberNetworkType(creditCardNumber: $0)) }
        
        creditCardNumbers.forEach {
            CCNEvaluator.getCreditCardAdditionalInformation(creditCardNumber: $0) { informationString in
                print(informationString)
            }
        }
        
        print(CCNEvaluator.filterCreditCardNumbersList(list: creditCardNumbers, useValidating: true, useConcreteTypes: nil))
        print(CCNEvaluator.filterCreditCardNumbersList(list: creditCardNumbers, useValidating: false, useConcreteTypes: ["Visa"]))
        print(CCNEvaluator.filterCreditCardNumbersList(list: creditCardNumbers, useValidating: true, useConcreteTypes: ["Visa"]))
        print(CCNEvaluator.filterCreditCardNumbersList(list: creditCardNumbers, useValidating: false, useConcreteTypes: nil))
        print(CCNEvaluator.filterCreditCardNumbersList(list: creditCardNumbers, useValidating: false, useConcreteTypes: []))
        print(CCNEvaluator.filterCreditCardNumbersList(list: creditCardNumbers, useValidating: false, useConcreteTypes: ["Unknown brand"]))
        print(CCNEvaluator.filterCreditCardNumbersList(list: creditCardNumbers, useValidating: false, useConcreteTypes: ["Mastercard", "China Union Pay"]))
    }

}
