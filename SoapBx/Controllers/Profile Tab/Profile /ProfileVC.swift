//
//  ProfileVC.swift
//  SoapBx
//
//  Created by Mac on 10/07/23.
//

import UIKit
import OTLContaner

enum ProfileScreenType {
    case profileTab, fromOtherUserProfile, fromSave
}

class ProfileVC: UIViewController {

    @IBOutlet private weak var viewHeader: OTLHeader!
    @IBOutlet private weak var btnNotification: OTLImageButton!
    @IBOutlet private weak var btnManu: OTLImageButton!
    
    @IBOutlet private weak var scrollBody: UIScrollView!
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var viewProfile: ProfileUserInfoView!
    @IBOutlet private weak var viewTradPost: TradPostListView!
    
    @IBOutlet private weak var bottomTab: OTLBottomTabBar!
    
    // Private variables
    private let vmObject = ProfileViewModel()
    private var screenType = ProfileScreenType.profileTab
    
    // Controllers lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setData()
        getUserPostWithProfile()
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
    
    // internal methods for passing data
    func navigateForOtherUser(_ userObj: PostUser) {
        screenType = .fromOtherUserProfile
        vmObject.userObj = userObj
    }
    
    // Setup UIUX
    private func setupUI() {
        bottomTab.setTabTheme()
        bottomTab.delegate = self
        
        btnNotification.image = UIImage(named: "ic_bellIcon")
        btnNotification.height = 20
        btnManu.image = UIImage(named: "ic_drawer")
        btnManu.height = 20
        
        viewProfile.setupUIWithData(screenType: screenType)
        viewTradPost.regiter(viewType: screenType == .fromOtherUserProfile ? .fromOtherUserProfile : .fromProfile, delegate: self)
        
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
        
        scrollBody.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateList), name: .homePostUpdate, object: nil)
    }

    private func setData() {
        if let obj = vmObject.userObj, screenType == .fromOtherUserProfile {
            viewProfile.updateOtherUserProfileData(obj)
        } else if let obj = authUser?.user{
            viewProfile.updateSelfProfileData(obj)
        }
    }
    
    @IBAction private func click_menu() {
        showSideMenu()
    }
    
    @objc private func updateList() {
        getUserPostWithProfile()
    }
    
    //API calls
    private func getUserPostWithProfile() {
        if screenType == .profileTab {
            getProfile()
        } else {
            getOtherProfile()
        }
    }
    
    
    private func getProfile() {
        showLoader()
        vmObject.getProfile { result in
            hideLoader()
            self.viewTradPost.updatePostObject(posts: self.vmObject.arrPosts)
            self.viewTradPost.updateTerndsObject(ternds: self.vmObject.arrTernds)
        }
    }
    
    private func getOtherProfile() {
        showLoader()
        vmObject.getOtherProfile { result in
            hideLoader()
            self.viewTradPost.updatePostObject(posts: self.vmObject.arrPosts)
            self.viewTradPost.updateTerndsObject(ternds: self.vmObject.arrTernds)
        }
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
extension ProfileVC: UIScrollViewDelegate{
    
   
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == scrollBody{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if vmObject.totalPage > vmObject.currentPage{
                    vmObject.currentPage = vmObject.currentPage + 1
                }
            }
        }
    }
}

extension ProfileVC: TradPostListDelegate {
    
    func tradPostList(didSelectTernd: TrendsModel) {
        vmObject.currentPage = 1
        getUserPostWithProfile()
    }
}
