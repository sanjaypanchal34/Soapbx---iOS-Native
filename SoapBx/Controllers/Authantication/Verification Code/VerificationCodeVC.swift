//
//  VerificationCodeVC.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import UIKit
import OTLContaner

enum VerificationCodeScreenType {
    case fromSignup, fromForgotPassword, fromUpdateProfile
}

class VerificationCodeVC: UIViewController {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblDescription: UILabel!
    
    @IBOutlet private weak var otpField: OTLOTPView!
    
    @IBOutlet private weak var btnResend: OTLTextButton!
    @IBOutlet private weak var btnNext: OTLTextButton!
    
    private var vmObject = SignupViewModel()
    private var screenType = VerificationCodeScreenType.fromSignup
    private var vmProfileObject: EditProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    func navigate(_ data: SignupRequestModel) {
        screenType = .fromSignup
        vmObject.signupJson = data
    }
    
    func navigateUpdateProfile(_ vmObject: EditProfileViewModel) {
        screenType = .fromUpdateProfile
        self.vmProfileObject = vmObject
        self.vmObject.signupJson = vmObject.requestObj
    }
    
    func navigateWithForgot(_ email: String) {
        screenType = .fromForgotPassword
        vmObject.signupJson =  SignupRequestModel()
        vmObject.signupJson?.email = email
    }
    
    //MARK: - Setup view
    private func setupUI() {
        lblTitle.setTheme("Verification code",
                          font: .bold,
                          size: 40)
        
        let attributesMain = NSMutableAttributedString(string: "Please type the verification code sent to your email \(vmObject.signupJson?.email ?? "")")
        let rang = attributesMain.mutableString.range(of: vmObject.signupJson?.email ?? "")
        attributesMain.addAttributes([.foregroundColor: UIColor.primaryBlue, .font: AppFont.medium.font(size: 16)], range: rang)
        
        lblDescription.attributedText = attributesMain
        
        otpField.setOTPTheme()
        btnResend.setTheme("Resend", color: .primaryBlue, font: .medium)
        btnNext.appButton(screenType == .fromUpdateProfile ? "Verify" : "Next")
        
        if screenType == .fromSignup || screenType == .fromUpdateProfile{
            btnResend.isHidden = false
        } else {
            btnResend.isHidden = true
        }
    }
    
    // action
    @IBAction private func click_resend(){
        if screenType == .fromSignup {
            resendOTP()
        }
        else if screenType == .fromUpdateProfile {
            resendUpdateProfileOTP()
        }
    }
    
    @IBAction private func click_Next(){
        let validateOTP = otpField.text.validateOTP()
        
        if validateOTP.status == false {
            showToast(message: validateOTP.message)
        } else {
            vmObject.signupJson?.otp = otpField.text
            if screenType == .fromSignup {
                registerWithVerify()
            }
            else if screenType == .fromForgotPassword {
                verifyOTP()
            }
        }
    }
    
    private func registerWithVerify() {
        showLoader()
        vmObject.registerWithVerify(complition: { result in
            hideLoader()
            if result.status {
                let vc = ProfileCoverVC()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                showToast(message: result.message)
            }
        })
    }
    
    private func verifyOTP() {
        showLoader()
        vmObject.verifyOTP(otp: otpField.text) { result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                let vc = ChangePasswordVC()
                vc.navigateForForgot(otp: self.otpField.text, email: self.vmObject.signupJson?.email ?? "")
                mackRootView(vc)
            }
            else {
                showToast(message: result.message)
            }
        }
    }
    
    private func verifyUpdateProfileOTP() {
        showLoader()
        vmProfileObject?.verifyUpdateProfileOTP(otp: otpField.text) { result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                mackRootView(ProfileVC())
            }
            else {
                showToast(message: result.message)
            }
        }
    }
    
    private func resendOTP() {
        showLoader()
        vmObject.register(phone: vmObject.signupJson?.phone_number ?? "",
                          country: vmObject.signupJson?.country_code ?? "",
                          email: vmObject.signupJson?.email ?? "",
                          verified: vmObject.signupJson?.verified_by ?? 0,
                          complition: { result in
            hideLoader()
            if result.status {
                showToast(message: result.message)
            } else {
                showToast(message: result.message)
            }
        })
    }
    
    private func resendUpdateProfileOTP() {
        showLoader()
        vmProfileObject?.updateProfile { result in
            hideLoader()
            if result.status {
                showToast(message: result.message)
            } else {
                showToast(message: result.message)
            }
        }
    }
}
