//
//  HomeTabVC.swift
//  SoapBx
//
//  Created by Mac on 08/07/23.
//

import UIKit
import OTLContaner

class HomeVC: UIViewController {
    
    @IBOutlet private weak var btnMessage:OTLImageButton!
    @IBOutlet private weak var btnNotification:OTLImageButton!
    @IBOutlet private weak var btnManu:OTLImageButton!
    
    @IBOutlet private weak var viewTradPost: TradPostListView!
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var bottomTab: OTLBottomTabBar!

    private var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomTab.selectedTab = .home
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewTradPost.removeCellObserver()
    }

    private func setupUI() {
        btnMessage.image = UIImage(named: "ic_sendRed")
        btnMessage.height = 20
        btnNotification.image = UIImage(named: "ic_bellIcon")
        btnNotification.height = 20
        
        btnManu.image = UIImage(named: "ic_drawer")
        btnManu.height = 20
        bottomTab.setTabTheme()
        bottomTab.delegate = self
        viewTradPost.regiter(viewType: .fromHome , delegate: nil)
    }
    
    @IBAction private func click_menu() {
        if authUser?.loginType == .userLogin {
            if let _ = authUser?.user {
                showSideMenu()
            }
        } else {
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                    mackRootView(LoginVC())
                }
            }
        }
        
    }
    
    @IBAction private func click_notification() {
        if authUser?.loginType == .userLogin {
            if let _ = authUser?.user {
                let vc = NotificationListVC()
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    @IBAction private func click_messageList() {
        if authUser?.loginType == .userLogin {
            if let _ = authUser?.user {
                let vc = MessageListVC()
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                    mackRootView(LoginVC())
                }
            }
        }
    }
}

extension HomeVC: OTLBottomTabBarDelegate {
    
    func didChangeTab(old: OTLContaner.OTLBottomTabBarItem, new: OTLContaner.OTLBottomTabBarItem) {
        switch new {
            case .home:
                break
            case .publicFigures:
                mackRootView(PublicFiguresVC())
                break
            case .addPost:
                if authUser?.loginType == .userLogin {
                    if let _ = authUser?.user {
                        navigationController?.pushViewController(CreatePostVC(), animated: true)
                    }
                } else {
                    bottomTab.selectedTab = .home
                    showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                        if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                            mackRootView(LoginVC())
                        }
                    }
                }
                
                break
            case .search:
                if authUser?.loginType == .userLogin {
                    if let _ = authUser?.user {
                        mackRootView(SearchVC())
                    }
                } else {
                    bottomTab.selectedTab = .home
                    showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                        if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                            mackRootView(LoginVC())
                        }
                    }
                }
                break
            case .profile:
                if authUser?.loginType == .userLogin {
                    if let _ = authUser?.user {
                        mackRootView(ProfileVC())
                    }
                } else {
                    bottomTab.selectedTab = .home
                    showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                        if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                            mackRootView(LoginVC())
                        }
                    }
                }
                break
        }
    }
}
