//
//  VerificationCodeVC.swift
//  SoapBx
//
//  Created by Mac on 08/07/23.
//

import UIKit
import OTLContaner

class VerificationCodeVC: UIViewController {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblDescription: UILabel!
    
    @IBOutlet private weak var otpField: OTLOTPView!
    
    @IBOutlet private weak var btnResend: OTLTextButton!
    @IBOutlet private weak var btnNext: OTLTextButton!
    
    private var vmObject = SignupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    func navigate(_ data: SignupRequestModel) {
        vmObject.signupJson = data
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
        btnNext.appButton("Next")
    }
    
    // action
    @IBAction private func click_resend(){
        
    }
    
    @IBAction private func click_Next(){
        let validateOTP = otpField.text.validateOTP()
        
        if validateOTP.status == false {
            showToast(message: validateOTP.message)
        } else {
            vmObject.signupJson?.otp = otpField.text
            registerWithVerify()
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
}
