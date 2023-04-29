//
//  NumberFromText.swift
//  VKR1.3
//
//  Created by Сергей Васильев on 07.04.2023.
//

import Foundation


func numbersFromText(s: String) -> (String, String?) {
    let text = s
    var number1: String?
    var number2: String?
    
    let range = NSRange(0..<text.count)
    let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
    
    let dataDetector = try! NSDataDetector(types: types.rawValue)
    dataDetector.enumerateMatches(in: text, range: range) { (match, _, _) in
        switch match?.resultType {
        case .phoneNumber?:
            let phoneNumber = match?.phoneNumber ?? "Error"
            if number1 == nil {
                number1 = phoneNumber
            } else {
                number2 = phoneNumber
            }
        default:
            break
        }
    }
    
    return (number1 ?? "No number found", number2)
}


func isMobileNumber (num: String) -> Bool {
    
    var isMobile = true
    
    if num.contains("+74") || num.contains("+7 4") || num.contains("+7 (4") || num.contains("+7(4") {
        isMobile = false
    }
    return isMobile
}


