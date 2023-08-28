//
//  LoginVC.swift
//  SoapBx
//
//  Created by Mac on 03/07/23.
//

import UIKit
import OTLContaner

class LoginVC: UIViewController {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblSubtitle: UILabel!
    
    @IBOutlet private weak var txtEmail: OTLTextField!
    @IBOutlet private weak var txtPassword: OTLPasswordField!
    
    @IBOutlet private weak var imgRemamberMe: UIImageView!
    @IBOutlet private weak var lblRemamberMe: UILabel!
    @IBOutlet private weak var btnForgotPasswrod: UIButton!
    
    @IBOutlet private weak var btnSignin: OTLTextButton!
    
    @IBOutlet private weak var btnContinueGuest: UIButton!
    @IBOutlet private weak var lblNotAMamber: UILabel!
    @IBOutlet private weak var btnSignUp: OTLTextButton!
    
    private let vmObject = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        lblTitle.setTheme(LocalStrings.LOGIN_TITLE.rawValue.addLocalizableString(),
                          font: .bold,
                          size: 38)
        lblSubtitle.setTheme(LocalStrings.LOGIN_SUBTITLE.rawValue.addLocalizableString(),
                             color: .titleGray)
        txtEmail.setTheme(placeholder: LocalStrings.P_EMAIL.rawValue.addLocalizableString(),
                          leftIcon: UIImage(named: "ic_email"))
        txtEmail.keyboardType = .emailAddress
        
        txtPassword.setTheme(placeholder: LocalStrings.P_PASSWORD.rawValue.addLocalizableString())
        
        lblRemamberMe.setTheme(LocalStrings.BTN_REMEMBER.rawValue.addLocalizableString())
        
        btnForgotPasswrod.setTheme(LocalStrings.BTN_FORGOT_PASS.rawValue.addLocalizableString(), color: .titleRed)
        
        btnSignin.appButton(LocalStrings.BTN_SIGNIN.rawValue.addLocalizableString())
        
        btnContinueGuest.setTheme(LocalStrings.BTN_GUEST.rawValue.addLocalizableString(), color: .titleGray, font: .medium)
        lblNotAMamber.setTheme(LocalStrings.LBL_NOT_MEMBER.rawValue.addLocalizableString(), size: 16)
        btnSignUp.setTheme(LocalStrings.BTN_SIGNUP.rawValue.addLocalizableString(),color: .primaryBlue, font: .medium, size: 16)
        // STAGING
//        txtEmail.text = "sumitk.iih@yopmail.com"
//        txtPassword.text = "sumit@123"
        //LIVE
//        txtEmail.text = "hemanshu.iihglobal@gmail.com"
//        txtPassword.text = "Password@1"
        
        if let remembe = AuthorizedUser.rememberMe() {
            txtEmail.text = remembe.email
            txtPassword.text = remembe.password
            imgRemamberMe.image = UIImage(named: "ic_favChecked")?.withRenderingMode(.alwaysTemplate)
            imgRemamberMe.tintColor = .primaryBlue
            imgRemamberMe.backgroundColor = .clear
        }
    }
    
    
    //Actions
    @IBAction private func click_Singin() {
        let validateEmail = txtEmail.text.validateEmail()
        let validatePass = txtPassword.text.validatePassword()
        
        if validateEmail.status == false {
            showToast(message: validateEmail.message)
        }
        else if validatePass.status == false {
            showToast(message: validatePass.message)
        }
        else {
            login()
        }
    }
    
    @IBAction private func click_ForgotPassword() {
        let vc = ForgotPasswrodVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func click_IAccept() {
        if imgRemamberMe.image == UIImage(named: "ic_favChecked")?.withRenderingMode(.alwaysTemplate) {
            imgRemamberMe.image = UIImage(named: "ic_unCheckbox")?.withRenderingMode(.alwaysOriginal)
            imgRemamberMe.backgroundColor = .clear
            imgRemamberMe.layer.cornerRadius = 0
        } else { // selected
            imgRemamberMe.image = UIImage(named: "ic_favChecked")?.withRenderingMode(.alwaysTemplate)
            imgRemamberMe.tintColor = .primaryBlue
            imgRemamberMe.backgroundColor = .clear
        }
    }
    
    @IBAction private func click_guest() {
        let vc = HomeVC()
        mackRootView(vc)
    }
    
    @IBAction private func click_SignUp() {
        let vc = SignupVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //API Calls
    private func login() {
        showLoader()
        vmObject.login(email: txtEmail.text,
                       password: txtPassword.text,
                       complition:  {[self] result in
            hideLoader()
            if result.status{
                if imgRemamberMe.image == UIImage(named: "ic_favChecked")?.withRenderingMode(.alwaysTemplate) {
                    AuthorizedUser.updateRememberMe(email: txtEmail.text, password: txtPassword.text)
                }
                
                if authUser?.user?.step == 2 {
                    mackRootView(ProfileCoverVC())
                }
                else if authUser?.user?.step == 3 {
                    mackRootView(YouInterestedVC())
                }
                else if authUser?.user?.step == 4 {
                    mackRootView(SubscribeVC())
                }
                else {
                    mackRootView(HomeVC())
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                showToast(message: result.message)
            })
        })
    }
}
