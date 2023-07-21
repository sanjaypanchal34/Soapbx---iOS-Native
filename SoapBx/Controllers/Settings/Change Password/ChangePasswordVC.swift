//
//  ChangePasswordVC.swift
//  SoapBx
//
//  Created by Mac on 19/07/23.
//

import UIKit
import OTLContaner

class ChangePasswordVC: UIViewController {

    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var txtOldPassword: OTLPasswordField!
    @IBOutlet private weak var txtNewPassword: OTLPasswordField!
    @IBOutlet private weak var txtConfPassword: OTLPasswordField!
    @IBOutlet private weak var btnUpdate: OTLTextButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
 
        viewHeader.lblTitle.setHeader("Change Password")
        
        txtOldPassword.setTheme(placeholder: "Profile Name")
        txtNewPassword.setTheme(placeholder: "Email")
        txtConfPassword.setTheme(placeholder: "Location")
        
        btnUpdate.appButton("Update")
    }
    
    //actions
    @IBAction private func click_btnUpdate() {
        self.navigationController?.popViewController(animated: true)
    }
}
