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
    @IBOutlet private weak var btnSignUp: UIButton!
    
    private let vmObject = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        lblTitle.setTheme("Sign in to Soapbx",
                          font: .bold,
                          size: 38)
        lblSubtitle.setTheme("Enter our details below",
                             color: .titleGrey)
        txtEmail.setTheme(placeholder: "Email",
                          leftIcon: UIImage(named: "ic_email"))
        
        txtPassword.setTheme(placeholder: "Password")
        
        lblRemamberMe.setTheme("Remember me")
        
        btnForgotPasswrod.setTheme("Forgot Password?", color: .titleRed)
        
        btnSignin.appButton("Sign in")
        
        btnContinueGuest.setTheme("Continue as a guest", color: .titleGrey, font: .medium)
        lblNotAMamber.setTheme("Not a member?", size: 16)
        btnSignUp.setTheme("Sign up now", color: .primaryBlue)
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
        if imgRemamberMe.image == nil {
            imgRemamberMe.image = UIImage(named: "ic_unCheckbox")
            imgRemamberMe.backgroundColor = .clear
            imgRemamberMe.layer.cornerRadius = 0
        } else { // selected
            imgRemamberMe.image = nil
            imgRemamberMe.backgroundColor = .primaryBlue
            imgRemamberMe.layer.cornerRadius = 2
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
                       complition:  { result in
            hideLoader()
            if result.status{
                
            } else {
                showToast(message: result.message)
            }
            
        })
    }
}
