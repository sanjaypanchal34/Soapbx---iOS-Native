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

    @IBAction private func click_back() {
        self.navigationController?.popToRootViewController(animated: true)
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
        self.vmObject.signupJson?.verified_by = 0 // email verify
        vmObject.signupJson?.email = email
    }
    
    //MARK: - Setup view
    private func setupUI() {
        lblTitle.setTheme(LocalStrings.V_TITLE.rawValue.addLocalizableString(),
                          font: .bold,
                          size: 40)
        var displayString = vmObject.signupJson?.email ?? ""
        var discription = LocalStrings.V_DESC_EMAIL.rawValue.addLocalizableString()
        if self.vmObject.signupJson?.verified_by == 1{ // phone verify
            displayString = "+" + (self.vmObject.signupJson?.country_code ?? "1") + (self.vmObject.signupJson?.phone_number ?? "")
            discription = LocalStrings.V_DESC_PHONE.rawValue.addLocalizableString()
        }
        let attributesMain = NSMutableAttributedString(string: "\(discription) \(displayString)")
        let rang = attributesMain.mutableString.range(of: displayString)
        attributesMain.addAttributes([.foregroundColor: UIColor.primaryBlue, .font: AppFont.medium.font(size: 16)], range: rang)
        
        lblDescription.attributedText = attributesMain
        
        otpField.setOTPTheme()
        otpField.delegate = self
        btnResend.setTheme(LocalStrings.C_RESEND.rawValue.addLocalizableString(), color: .primaryBlue, font: .medium)
        btnNext.appButton(screenType == .fromUpdateProfile ? LocalStrings.V_VERIFY.rawValue.addLocalizableString() : LocalStrings.C_NEXT.rawValue.addLocalizableString())
        
        btnResend.isHidden = false
    }
    
    // action
    @IBAction private func click_resend(){
        if screenType == .fromSignup {
            resendOTP()
        }
        else if screenType == .fromUpdateProfile {
            resendUpdateProfileOTP()
        }
        else if screenType == .fromForgotPassword {
            resendForgotOTP()
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
            else if screenType == .fromUpdateProfile {
                verifyUpdateProfileOTP()
            }
        }
    }
    
    private func registerWithVerify() {
        showLoader()
        vmObject.registerWithVerify(complition: { result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                let vc = ProfileCoverVC()
                self.navigationController?.pushViewController(vc, animated: true)
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
            showToast(message: result.message)
        })
    }
    
    private func resendUpdateProfileOTP() {
        showLoader()
        vmProfileObject?.updateProfile { result in
            hideLoader()
            showToast(message: result.message)
        }
    }
    
    private func resendForgotOTP() {
        showLoader()
        vmObject.forgotPassword(email: vmObject.signupJson?.email ?? "") { result in
            hideLoader()
            showToast(message: result.message)
        }
    }
}
extension VerificationCodeVC : OTLOTPViewDelegate {
    func otlOTP(_ otpView: OTLContaner.OTLOTPView, didUpdateValue string: String, at index: Int) {
    }
    
    func otlOTP(_ otpView:OTLOTPView, didFinish string: String ) {
        click_Next()
    }
}
