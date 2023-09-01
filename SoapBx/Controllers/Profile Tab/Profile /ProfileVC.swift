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
    private let vmLikeDislikeObj = LikeDislikeViewModel()
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
        
        viewProfile.setupUIWithData(screenType: screenType, delegate: self)
        viewTradPost.regiter(viewType: screenType == .fromOtherUserProfile ? .fromOtherUserProfile : .fromProfile, delegate: self)
        
        if screenType == .profileTab {
            viewHeader.lblTitle.setHeader(LocalStrings.PROFILE.rawValue.addLocalizableString())
            viewHeader.btnBack.isHidden = true
            btnNotification.isHidden = false
            btnManu.isHidden = false
        } else {
            if let obj = vmObject.userObj {
                viewHeader.lblTitle.setHeader(obj.name ?? "")
            }
            viewHeader.btnBack.isHidden = false
            btnNotification.isHidden = true
            btnManu.isHidden = true
        }
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullupRefresh(_:)), for: .valueChanged)
        scrollBody.refreshControl = refreshControl
        scrollBody.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateList), name: .homePostUpdate, object: nil)
    }

    private func setData() {
        if let obj = vmObject.userObj, screenType == .fromOtherUserProfile {
            viewHeader.lblTitle.text = obj.name
            viewProfile.updateOtherUserProfileData(obj)
        } else if let obj = authUser?.user{
            viewProfile.updateSelfProfileData(obj)
        }
    }
    
    @IBAction private func click_menu() {
        if authUser?.loginType == .userLogin {
            showSideMenu()
        } else {
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    
    @objc private func updateList() {
        getUserPostWithProfile()
    }
    
    @objc private func pullupRefresh(_ sender:UIRefreshControl ) {
        vmObject.currentPage = 1
        getUserPostWithProfile()
        sender.endRefreshing()
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
        vmObject.getProfile {[self] result in
            hideLoader()
            if let user = vmObject.userObj {
                viewProfile.updateProfileData(user)
            }
            viewTradPost.updatePostObject(posts: vmObject.arrPosts)
            viewTradPost.updateTerndsObject(ternds: vmObject.arrTernds)
        }
    }
    
    private func getOtherProfile() {
        showLoader()
        vmObject.getOtherProfile {[self] result in
            hideLoader()
            if let user = vmObject.userObj {
                viewProfile.updateProfileData(user)
            }
            viewTradPost.updatePostObject(posts: vmObject.arrPosts)
            viewTradPost.updateTerndsObject(ternds: vmObject.arrTernds)
        }
    }
    
    private func follow() {
        showLoader()
        vmObject.follow(user: vmObject.userObj?.id ?? 0,
                         user: vmObject.userObj?.roleID ?? 3) {[self] result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                vmObject.userObj?.statusUser = 1
                if let user = vmObject.userObj {
                    viewProfile.updateProfileData(user)
                }
            }
        }
    }
    
    private func unfollow() {
        showLoader()
        vmObject.unfollow(user: vmObject.userObj?.id ?? 0) {[self] result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                vmObject.userObj?.statusUser = 0
                if let user = vmObject.userObj {
                    viewProfile.updateProfileData(user)
                }
            }
        }
    }
    
    private func message() {
        showLoader()
        vmObject.message(user: vmObject.userObj?.id ?? 0) {[self] result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                let vc = ChatVC()
                if let obj = vmObject.userObj {
                    vc.userName = (vmObject.userObj?.fullName)!
                    vc.userId = vmObject.userObj?.id
                    vc.uniqueID = vmObject.uniqueId
                    vc.relationID = vmObject.relationId
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func hidePost(post id:Int) {
        showLoader()
        vmLikeDislikeObj.blockPost(post: id) { result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                self.vmObject.currentPage = 1
                mackRootView(HomeVC())
            }
        }
    }
    
    private func cancelRequest() {
        showLoader()
        vmObject.cancelRequest(user: vmObject.userObj?.id ?? 0){[self] result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                vmObject.userObj?.statusUser = 0
                if let object = vmObject.userObj {
                    viewProfile.updateProfileData(object)
                }
            }
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
                navigationController?.pushViewController(CreatePostVC(), animated: true)
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
extension ProfileVC: ProfileUserInfoDelegate {
    func profileUser(follow user: PostUser) {
        if user.statusUser == 0{
            follow()
        } else if user.statusUser == 1{
            cancelRequest()
        }
        else if user.statusUser == 2{
            unfollow()
        }
    }
    
    func profileUser(block user: PostUser) {
        hidePost(post: user.id ?? 0)
    }
    
    func profileUserMessage(message user: PostUser) {
        message()
    }
}
