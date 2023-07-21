//
//  ProfileVC.swift
//  SoapBx
//
//  Created by Mac on 10/07/23.
//

import UIKit
import OTLContaner

enum ProfileScreenType {
    case profileTab, fromOtherUserProfile
}

class ProfileVC: UIViewController {

    @IBOutlet private weak var viewHeader: OTLHeader!
    @IBOutlet private weak var btnNotification: OTLImageButton!
    @IBOutlet private weak var btnManu: OTLImageButton!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var viewProfile: ProfileUserInfoView!
    @IBOutlet private weak var viewTradPost: TradPostListView!
    
    @IBOutlet private weak var bottomTab: OTLBottomTabBar!
    
    var screenType = ProfileScreenType.profileTab
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if screenType == .profileTab {
            bottomTab.selectedTab = .profile
        } else {
            bottomTab.isHidden = true
        }
        viewTradPost.addHeightListener()
    }
    override func viewDidDisappear(_ animated: Bool) {
        viewTradPost.removeHeightListener()
    }

    private func setupUI() {
        bottomTab.setTabTheme()
        bottomTab.delegate = self
        
        btnNotification.image = UIImage(named: "ic_bellIcon")
        btnManu.image = UIImage(named: "ic_drawer")
        
        viewProfile.setupUIWithData(screenType: screenType)
        viewTradPost.regiter(viewType: .fromProfile)
        
        if screenType == .profileTab {
            viewHeader.lblTitle.setHeader("Profile")
            viewHeader.btnBack.isHidden = true
            btnNotification.isHidden = false
            btnManu.isHidden = false
        } else {
            viewHeader.lblTitle.setHeader("Robert Watson")
            viewHeader.btnBack.isHidden = false
            btnNotification.isHidden = true
            btnManu.isHidden = true
        }
    }

    
    @IBAction private func click_menu() {
        showSideMenu()
    }
}
extension ProfileVC: OTLBottomTabBarDelegate {
    
    func didChangeTab(old: OTLContaner.OTLBottomTabBarItem, new: OTLContaner.OTLBottomTabBarItem) {
        
        switch new {
            
        case .home:
            mackRootView(HomeVC())
            break
        case .publicFigures:
            mackRootView(PublicFiguresVC())
            break
        case .addPost:
            break
        case .search:
            mackRootView(SearchVC())
            break
        case .profile:
            break
        }
    }
    
    
}
