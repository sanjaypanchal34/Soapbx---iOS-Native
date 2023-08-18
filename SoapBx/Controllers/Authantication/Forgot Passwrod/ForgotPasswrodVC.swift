//
//  ForgotPasswrodVC.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 24/07/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import UIKit
import OTLContaner

class ForgotPasswrodVC: UIViewController {
    
    @IBOutlet private weak var headerView: OTLHeader!
    
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblSubtitle: UILabel!
    
    @IBOutlet private weak var txtEmail: OTLTextField!
    
    @IBOutlet private weak var btnNext: OTLTextButton!
    
    private let vmObject = SignupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        lblTitle.setTheme("Forgot password?",
                          font: .bold,
                          size: 38)
        lblSubtitle.setTheme("Please enter your email / phone number to reset your account password",
                             color: .titleGray)
        
        txtEmail.setTheme(placeholder: "Email / Phone Number",
                          leftIcon: UIImage(named: "ic_email"))
        txtEmail.keyboardType = .emailAddress
        
        btnNext.appButton("Next")

    }
    
    
    //Actions
   
    @IBAction private func click_Next() {
        let validateEmail = txtEmail.text.validateEmail()
        
        if validateEmail.status == false {
            showToast(message: validateEmail.message)
        }
        else {
            forgotPassword()
        }
    }
    
    
    //API call
    private func forgotPassword() {
        showLoader()
        vmObject.forgotPassword(email: txtEmail.text) { result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                let vc = VerificationCodeVC()
                vc.navigateWithForgot(self.txtEmail.text)
                mackRootView(vc)
            }
        }
    }
}
