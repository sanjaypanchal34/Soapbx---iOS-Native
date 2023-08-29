//
//  ViewBasicDetails.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 15/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import UIKit
import OTLContaner

class ViewBasicDetails: UIView {
    
    @IBOutlet private weak var lblViewTitle: UILabel!
    
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblTitleValue: UILabel!
    @IBOutlet private weak var lblLeadership: UILabel!
    @IBOutlet private weak var lblLeadershipValue: UILabel!
    @IBOutlet private weak var lblState: UILabel!
    @IBOutlet private weak var lblStateValue: UILabel!
    @IBOutlet private weak var lblStateRank: UILabel!
    @IBOutlet private weak var lblStateRankValue: UILabel!
    @IBOutlet private weak var lblDOB: UILabel!
    @IBOutlet private weak var lblDOBValue: UILabel!
    @IBOutlet private weak var lblInOffice: UILabel!
    @IBOutlet private weak var lblInOfficeValue: UILabel!
    @IBOutlet private weak var lblSeniority: UILabel!
    @IBOutlet private weak var         lblSeniorityValue: UILabel!
    @IBOutlet private weak var lblSenateClass: UILabel!
    @IBOutlet private weak var lblSenateClassValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 10
        
        lblViewTitle.setTheme(LocalStrings.P_BASIC_HEADER.rawValue.addLocalizableString(), font: .bold,size: 20)
        
        lblTitle.setTheme(LocalStrings.P_BASIC_TITLE.rawValue.addLocalizableString(), font: .semibold)
        lblTitleValue.setTheme("", color: .primaryBlue, font: .semibold)
        lblLeadership.setTheme(LocalStrings.P_BASIC_L_ROLE.rawValue.addLocalizableString(), font: .semibold)
        lblLeadershipValue.setTheme("", color: .primaryBlue, font: .semibold)
        lblState.setTheme(LocalStrings.P_BASIC_STATE.rawValue.addLocalizableString(), font: .semibold)
        lblStateValue.setTheme("", color: .primaryBlue, font: .semibold)
        lblStateRank.setTheme(LocalStrings.P_BASIC_STATE_RANK.rawValue.addLocalizableString(), font: .semibold)
        lblStateRankValue.setTheme("", color: .primaryBlue, font: .semibold)
        lblDOB.setTheme(LocalStrings.P_BASIC_DOB.rawValue.addLocalizableString(), font: .semibold)
        lblDOBValue.setTheme("", color: .primaryBlue, font: .semibold)
        lblInOffice.setTheme(LocalStrings.P_BASIC_IN_OFFICE.rawValue.addLocalizableString(), font: .semibold)
        lblInOfficeValue.setTheme("", color: .primaryBlue, font: .semibold)
        lblSeniority.setTheme(LocalStrings.P_BASIC_SENIOR.rawValue.addLocalizableString(), font: .semibold)
        lblSeniorityValue.setTheme("", color: .primaryBlue, font: .semibold)
        lblSenateClass.setTheme(LocalStrings.P_BASIC_SENATE.rawValue.addLocalizableString(), font: .semibold)
        lblSenateClassValue.setTheme("", color: .primaryBlue, font: .semibold)
    }
    
    
    func setData(_ user: PostUser){
        lblTitleValue.text = getValueOrDefult(user.title, defaultValue: "--")
        lblLeadershipValue.text = getValueOrDefult(user.leadershipRole, defaultValue: "--")
        lblStateValue.text = getValueOrDefult(user.state, defaultValue: "--")
        lblStateRankValue.text = getValueOrDefult(user.stateRank, defaultValue: "--")
        lblDOBValue.text = getValueOrDefult(user.dateOfBirth, defaultValue: "--")
        lblInOfficeValue.text = getValueOrDefult(user.inOffice, defaultValue: "--")
        lblSeniorityValue.text = getValueOrDefult(user.seniority, defaultValue: "--")
        lblSenateClassValue.text = getValueOrDefult(user.senateClass, defaultValue: "--")
    }
}
