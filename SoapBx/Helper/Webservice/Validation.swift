//
//  Validation.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 26/02/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation
import UIKit
import OTLContaner
//Password RX details
/*^                         Start anchor
 (?=.*[A-Z].*[A-Z])              Ensure string has two uppercase letters.
 (?=.*[!@#$&*])                  Ensure string has one special case letter.
 (?=.*[0-9].*[0-9])               Ensure string has two digits.
 (?=.*[a-z].*[a-z].*[a-z])       Ensure string has three lowercase letters.
 .{8}                                    Ensure string is of length 8.
 $                                       End anchor.
 */
enum validationRX{
    case email, password, phoneNo
    
    var RX : String {
        get{
            switch self{
            case .email: return "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
                //            case .password: return "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{6,50}$"
            case .password: return "^(?=.*[A-Z])(?=.*[0-9]).{4,50}$"
            case .phoneNo : return "^[0-9+]{0,1}+[0-9]{5,16}$"
            }
        }
    }
}

extension String
{
    func validateWith(RX value : validationRX)-> Bool {
        let emailRegEx = value.RX
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

typealias ValidationResult = (status : Bool, message: String)


extension String
{
    func validateFirst() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Enter First Name.")
        } else {
            return (true, "")
        }
    }
    
    func validateLast() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Enter Last Name.")
        } else {
            return (true, "")
        }
    }
    
    func validateEmail() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Please enter email")
        } else if !self.validateWith(RX: .email) {
            return (false, "Please enter valid email")
        } else {
            return (true, "")
        }
    }
    
    func validatePhone() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Please enter phone number")
        } else if !self.validateWith(RX: .phoneNo)  {
            return (false, "Please enter valid phone number")
        } else {
            return (true, "")
        }
    }
    
    func validatePassword() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Please enter password")
        } else if self.count < 7 {
            return (false, "Password must contain at least 8 characters")
        } else {
            return (true, "")
        }
    }
    
    func validateOldPassword() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Please enter old password")
        } else if self.count < 7 {
            return (false, "Old password must contain at least 8 characters")
        } else {
            return (true, "")
        }
    }
    
    func validateNewPassword() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Please enter new password")
        } else if self.count < 7 {
            return (false, "New Password must contain at least 8 characters")
        } else {
            return (true, "")
        }
    }
    
    func validateConfirmPassword(with password: String) -> ValidationResult {
        if self.isEmptyString {
            return (false, "Please enter confirm password")
        } else if self.count < 7 {
            return (false, "Confirm password must contain at least 8 characters")
        } else if self != password{
            return (false, "Password does not match")
        } else {
            return (true, "")
        }
    }
    
    func validateOTP() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Please enter OTP")
        } else if self.count < 4 {
            return (false, "OTP must contain 4 characters")
        } else {
            return (true, "")
        }
    }
    
    func validateCommentOnPost() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Please add a comment")
        }else {
            return (true, "")
        }
    }
    
    func validateReason() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Please enter a reason")
        }else {
            return (true, "")
        }
    }
    
    func validateTitle() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Please enter title")
        }else {
            return (true, "")
        }
    }
    
    func validateDescription() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Please enter description")
        }else {
            return (true, "")
        }
    }
    
    func validateProfileName() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Enter profile name.")
        } else {
            return (true, "")
        }
    }
    
    func validateSuggestComment() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Please provide a comment.")
        } else {
            return (true, "")
        }
    }
    
    func validateQuestion() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Please provide a question")
        } else {
            return (true, "")
        }
    }
    
    func validateStartDate() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Please provide start date")
        } else {
            return (true, "")
        }
    }
    func validateEndDate() -> ValidationResult {
        if self.isEmptyString {
            return (false, "Please provide end date")
        } else {
            return (true, "")
        }
    }
    
    func validatePollOptions(_ option: String) -> ValidationResult {
        if self.isEmptyString {
            return (false, "Please provide option \(option) value")
        } else {
            return (true, "")
        }
    }
}
