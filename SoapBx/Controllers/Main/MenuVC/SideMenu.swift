//
//  SideMenu.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import UIKit
import OTLContaner

class SideMenu: UIControl {
    
    @IBOutlet private weak var viewMain:UIView!
    @IBOutlet private weak var imgProfile:UIImageView!
    @IBOutlet private weak var lblProfileName:UILabel!
    @IBOutlet private weak var lblViewProfile:UILabel!
    @IBOutlet private weak var tblList:UITableView!
    
    private var arrMenu = [
        MenuModel(icon: "ic_upgrade", title: LocalStrings.S_SUPPORT.rawValue.addLocalizableString()),
        MenuModel(icon: "ic_blog", title: LocalStrings.S_BLOG.rawValue.addLocalizableString()),
        MenuModel(icon: "ic_home", title: LocalStrings.S_HOME.rawValue.addLocalizableString(), isSelected: true),
        MenuModel(icon: "ic_poll", title: LocalStrings.S_POLL.rawValue.addLocalizableString()),
        MenuModel(icon: "ic_friends", title: LocalStrings.S_FRIEND.rawValue.addLocalizableString()),
        MenuModel(icon: "insurance", title: LocalStrings.S_CONNECTION.rawValue.addLocalizableString()),
        MenuModel(icon: "ic_upgrade", title: LocalStrings.S_UPGRADE.rawValue.addLocalizableString()),
        MenuModel(icon: "ic_settings", title: LocalStrings.S_SETTING.rawValue.addLocalizableString()),
        MenuModel(icon: "faq", title: LocalStrings.S_FAQ.rawValue.addLocalizableString()),
        MenuModel(icon: "ic_help", title: LocalStrings.S_ABOUT.rawValue.addLocalizableString()),
        MenuModel(icon: "accept", title: LocalStrings.S_TERMS.rawValue.addLocalizableString()),
        MenuModel(icon: "insurance", title: LocalStrings.S_PRIVACY.rawValue.addLocalizableString()),
        MenuModel(icon: "logout", title: LocalStrings.S_LOGOUT.rawValue.addLocalizableString()),
    ]
    fileprivate var complition:(()->())?
    
    static func loadFromNib() -> Self {
        let nib = UINib(nibName: "SideMenu", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
    
    fileprivate func setupUI() {
        self.backgroundColor = .black.withAlphaComponent(0.3)
        
        viewMain.backgroundColor = .white
        
        imgProfile.setImage(authUser?.user?.profile_photo_url)
        imgProfile.contentMode = .scaleAspectFill
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        
        lblProfileName.setTheme(authUser?.user?.name ?? "", size: 22, lines: 1)
        lblViewProfile.setTheme("View Profile", size: 14)
        
        tblList.register(["MenuItemCell"], delegate: self, dataSource: self)
        
        self.addTarget(self, action: #selector(touchupOutSide), for: .touchUpInside)
    }
    
    fileprivate func startAnimation(_ frame: CGRect) {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.frame.origin.x = frame.width
        self.backgroundColor = .clear
        UIView.animate(withDuration: 0.5) {
            self.frame.origin.x = 0
        } completion: { status in
            if status {
                self.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.4) {
            self.backgroundColor = .black.withAlphaComponent(0.3)
        } completion: { status in
        }
    }
    
    fileprivate func stopAnimation() {
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = true
        self.frame.origin.x = 0
        UIView.animate(withDuration: 0.5) {
            self.frame.origin.x = self.frame.width
        } completion: { status in
            if status {
                self.removeFromSuperview()
            }
        }
        
        
    }
    
    //
    @objc private func touchupOutSide() {
        stopAnimation()
    }
    
    @IBAction private func click_openProfile() {
        stopAnimation()
        mackRootView(ProfileVC())
    }
}
extension SideMenu: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell") as? MenuItemCell {
            cell.setData(arrMenu[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
extension SideMenu: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        stopAnimation()
        switch arrMenu[indexPath.row].title {
        case LocalStrings.S_SUPPORT.rawValue.addLocalizableString():
                let url = URL(string: "https://soapbx.net/donate_mobile?auth_token=\(authUser?.user?.auth_token ?? "")")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            break
        case LocalStrings.S_BLOG.rawValue.addLocalizableString():
            let url = URL(string: "https://soapbx.net/blog")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            break
        case LocalStrings.S_HOME.rawValue.addLocalizableString():
                if ((rootViewController.topViewController as? HomeVC) != nil) {
                    
                } else {
                    mackRootView(HomeVC())
                }
            break
        case LocalStrings.S_POLL.rawValue.addLocalizableString():
            let vc = PollsListVC()
            rootViewController.pushViewController(vc, animated: true)
            break
        case LocalStrings.S_FRIEND.rawValue.addLocalizableString():
            let vc = ConnectionVC()
            vc.screenType = .fromFriends
            rootViewController.pushViewController(vc, animated: true)
            break
        case LocalStrings.S_CONNECTION.rawValue.addLocalizableString():
            let vc = ConnectionVC()
            rootViewController.pushViewController(vc, animated: true)
            break
        case LocalStrings.S_UPGRADE.rawValue.addLocalizableString():
            let vc = SubscribeVC()
            vc.screenType = .fromSetting
            rootViewController.pushViewController(vc, animated: true)
            break
        case LocalStrings.S_SETTING.rawValue.addLocalizableString():
            let vc = SettingVC()
            rootViewController.pushViewController(vc, animated: true)
            break
        case LocalStrings.S_FAQ.rawValue.addLocalizableString():
            let vc = CMSPageVC()
            vc.screenType = .faq
            rootViewController.pushViewController(vc, animated: true)
            break
        case LocalStrings.S_ABOUT.rawValue.addLocalizableString():
            let vc = CMSPageVC()
            vc.screenType = .about
            rootViewController.pushViewController(vc, animated: true)
            break
        case LocalStrings.S_TERMS.rawValue.addLocalizableString():
            let vc = CMSPageVC()
            vc.screenType = .termsCondition
            rootViewController.pushViewController(vc, animated: true)
            
            break
        case LocalStrings.S_PRIVACY.rawValue.addLocalizableString():
            let vc = CMSPageVC()
            vc.screenType = .policy
            rootViewController.pushViewController(vc, animated: true)
            
            break
        case LocalStrings.S_LOGOUT.rawValue.addLocalizableString():
            let cancel = OTLAlertModel(title: LocalStrings.C_CANCEL.rawValue.addLocalizableString(), id: 0)
            let okay = OTLAlertModel(title: LocalStrings.C_OK.rawValue.addLocalizableString(), id: 1, style: .destructive)
            showAlert(message: LocalStrings.A_LOGOUT.rawValue.addLocalizableString(),  buttons: [cancel,okay]) { alert in
                if alert.id == 1 {
                    if authUser?.loginType == .userLogin {
                        let vmObject = LoginViewModel()
                        showLoader()
                        vmObject.logout { result in
                            hideLoader()
                            if result.status {
                                mackRootView(LoginVC())
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                                SoapBx.showToast(message: result.message)
                            })
                        }
                    }
                    else {
                        mackRootView(LoginVC())
                    }
                    
                }
            }
            break
        default:
            break
        }
    }
}

func showSideMenu() {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
       let window = appDelegate.window{
        let view = SideMenu.loadFromNib()
        view.frame = window.bounds
        view.translatesAutoresizingMaskIntoConstraints = true
        window.addSubview(view)
        view.setupUI()
        view.startAnimation(window.bounds)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: window.topAnchor, constant: 0),
            view.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: 0),
        ])
        
    }
}

