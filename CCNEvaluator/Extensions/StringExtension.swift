//
//  StringExtension.swift
//  CCNEvaluator
//
//  Created by Никита on 08/09/2019.
//  Copyright © 2019 Никита. All rights reserved.
//

import Foundation

extension String {
    
    func removeCharactersInSet(_ set: CharacterSet) -> String {
        let stringComponents = self.components(separatedBy: set)
        let notEmptyStringComponents = stringComponents.filter { !$0.isEmpty }
        return notEmptyStringComponents.joined()
    }
    
    func removeAllWhitespacesAndNewlines() -> String {
        return removeCharactersInSet(.whitespacesAndNewlines)
    }
    
}
