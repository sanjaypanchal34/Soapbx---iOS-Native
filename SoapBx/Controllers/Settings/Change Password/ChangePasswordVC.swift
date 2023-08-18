//
//  ChangePasswordVC.swift
//  SoapBx
//
//  Created by Mac on 19/07/23.
//

import UIKit
import OTLContaner

enum ChangePasswordScreenType {
    case fromSetting, fromForgotPassword
}

class ChangePasswordVC: UIViewController {

    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var txtOldPassword: OTLPasswordField!
    @IBOutlet private weak var txtNewPassword: OTLPasswordField!
    @IBOutlet private weak var txtConfPassword: OTLPasswordField!
    @IBOutlet private weak var btnUpdate: OTLTextButton!
    
    private var screenType = ChangePasswordScreenType.fromSetting
    private let vmObject = ChangePasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func navigateForForgot(otp: String, email: String) {
        screenType = .fromForgotPassword
        vmObject.otp = otp
        vmObject.email = email
    }

    private func setupUI() {
 
        viewHeader.lblTitle.setHeader("Change Password")
        
        txtOldPassword.setTheme(placeholder: "Old Password")
        txtNewPassword.setTheme(placeholder: "New Password")
        txtConfPassword.setTheme(placeholder: "Confirm Password")
        
        btnUpdate.appButton("Update")
        
        if screenType == .fromForgotPassword {
            txtOldPassword.isHidden = true
        }
    }
    
    //actions
    @IBAction private func click_btnUpdate() {
        let validatePass = txtOldPassword.text.validateOldPassword()
        let validateNewPass = txtNewPassword.text.validateNewPassword()
        let validateConfPass = txtConfPassword.text.validateConfirmPassword(with: txtNewPassword.text)
        
        if validatePass.status == false, screenType == .fromSetting {
            showToast(message: validatePass.message)
        }
        else if validateNewPass.status == false {
            showToast(message: validateNewPass.message)
        }
        else if validateConfPass.status == false {
            showToast(message: validateConfPass.message)
        } else {
            if screenType == .fromSetting {
                changePassword()
            } else {
                resetForgotPassword()
            }
        }
    }
    
    // API calls
    private func resetForgotPassword() {
        showLoader()
        vmObject.resetForgotPassword(new: txtNewPassword.text,
                                     confirmPassword: txtConfPassword.text) { result in
            
            showToast(message: result.message)
            if result.status {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    hideLoader()
                    mackRootView(LoginVC())
                })
            }
            else {
                hideLoader()
            }
            
        }
    }
    
    private func changePassword() {
        showLoader()
        vmObject.changePassword(new: txtOldPassword.text, newPassword: txtNewPassword.text, confirmPassword: txtConfPassword.text) { result in
            showToast(message: result.message)
            if result.status {
                self.navigationController?.popViewController(animated: true)
            }
            hideLoader()
        }
    }
}
