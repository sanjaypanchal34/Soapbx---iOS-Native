//
//  EditProfileVC.swift
//  SoapBx
//
//  Created by Mac on 17/07/23.
//

import UIKit
import OTLContaner

class EditProfileVC: UIViewController {

    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    
    @IBOutlet private weak var imgCover:UIImageView!
    @IBOutlet private weak var btnEditCover:OTLImageButton!
    @IBOutlet private weak var btnProfile:OTLImageButton!
    
    @IBOutlet private weak var txtFirstName: OTLTextField!
    @IBOutlet private weak var txtLastName: OTLTextField!
    @IBOutlet private weak var txtPhoneNo: OTLTextField!
    @IBOutlet private weak var txtEmail: OTLTextField!
    @IBOutlet private weak var txtLocation: OTLTextField!
    
    @IBOutlet private weak var btnUpdate: OTLTextButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        viewHeader.lblTitle.setHeader("Edit Profile")
        
        viewBody.backgroundColor = .white
        
        imgCover.image = UIImage(named: "")
        imgCover.backgroundColor = .lightGrey
        btnEditCover.image = UIImage(named: "ic_edit")
        btnEditCover.backgroundColor = .clear
        
        btnProfile.image = UIImage(named: "profileOne")
        btnProfile.contentMode = .scaleAspectFill
        btnProfile.layer.cornerRadius = btnProfile.frame.height/2
        btnProfile.backgroundColor = .lightGrey
        btnProfile.height = btnProfile.frame.height
        
        
        txtFirstName.setTheme(placeholder: "First name",
                          leftIcon: UIImage(named: "ic_user"))
        txtLastName.setTheme(placeholder: "Last name",
                             leftIcon: UIImage(named: "ic_user"))
        txtPhoneNo.setTheme(placeholder: "Phone Number",
                          leftIcon: UIImage(named: "ic_phone"))
        txtEmail.setTheme(placeholder: "Email",
                          leftIcon: UIImage(named: "ic_email"))
        txtLocation.setTheme(placeholder: "Location",
                             leftIcon: UIImage(named: "ic_location_grey"))
        
        btnUpdate.appButton("Update")
    }

}
