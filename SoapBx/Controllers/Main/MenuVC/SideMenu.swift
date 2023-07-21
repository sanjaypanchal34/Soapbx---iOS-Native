//
//  SideMenu.swift
//  SoapBx
//
//  Created by Mac on 17/07/23.
//

import UIKit

class SideMenu: UIControl {
    
    @IBOutlet private weak var viewMain:UIView!
    @IBOutlet private weak var imgProfile:UIImageView!
    @IBOutlet private weak var lblProfileName:UILabel!
    @IBOutlet private weak var lblViewProfile:UILabel!
    @IBOutlet private weak var tblList:UITableView!
    
    private var arrMenu = [
        MenuModel(icon: "ic_upgrade", title: "Support Soapbx"),
        MenuModel(icon: "ic_blog", title: "Blogs"),
        MenuModel(icon: "ic_home", title: "Home", isSelected: true),
        MenuModel(icon: "ic_poll", title: "Polls"),
        MenuModel(icon: "ic_friends", title: "Friends"),
        MenuModel(icon: "insurance", title: "Connections"),
        MenuModel(icon: "ic_upgrade", title: "Upgrade your Plan"),
        MenuModel(icon: "ic_settings", title: "Settings"),
        MenuModel(icon: "faq", title: "FAQs"),
        MenuModel(icon: "ic_help", title: "About Soapbx"),
        MenuModel(icon: "accept", title: "Terms of Service"),
        MenuModel(icon: "insurance", title: "Privacy Policy"),
        MenuModel(icon: "logout", title: "Logout"),
    ]
    fileprivate var complition:(()->())?
    
    static func loadFromNib() -> Self {
        let nib = UINib(nibName: "SideMenu", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
    
    fileprivate func setupUI() {
        self.backgroundColor = .black.withAlphaComponent(0.3)
        
        viewMain.backgroundColor = .white
        
        imgProfile.image = UIImage(named: "profile_Three")
        imgProfile.contentMode = .scaleAspectFill
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        
        lblProfileName.setTheme("Robert Watson", size: 22)
        lblViewProfile.setTheme("View Profile", size: 14)
        
        tblList.register(["MenuItemCell"], delegate: self, dataSource: self)
        
        self.addTarget(self, action: #selector(touchupOutSide), for: .touchUpInside)
    }
    
    fileprivate func startAnimation(_ frame: CGRect) {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.frame.origin.x = frame.width
        self.backgroundColor = .clear
        UIView.animate(withDuration: 0.8) {
            self.frame.origin.x = 0
            self.backgroundColor = .black.withAlphaComponent(0.3)
        } completion: { status in
            if status {
                self.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    }
    
    fileprivate func stopAnimation() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.frame.origin.x = 0
        self.backgroundColor = .black.withAlphaComponent(0.3)
        UIView.animate(withDuration: 0.8) {
            self.frame.origin.x = self.frame.width
            self.backgroundColor = .clear
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
        case "Support Soapbx":
            let url = URL(string: "https://soapbx.net/donate")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            break
        case "Blogs":
            let url = URL(string: "https://soapbx.net/blog")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            break
        case "Home":
            break
        case "Polls":
            break
        case "Friends":
            break
        case "Connections":
            let vc = ConnectionVC()
            rootViewController.pushViewController(vc, animated: true)
            break
        case "Upgrade your Plan":
            let vc = SubscribeVC()
            vc.screenType = .fromSetting
            rootViewController.pushViewController(vc, animated: true)
            break
        case "Settings":
            let vc = SettingVC()
            rootViewController.pushViewController(vc, animated: true)
            break
        case "FAQs":
            let vc = CMSPageVC()
            vc.screenType = .faq
            rootViewController.pushViewController(vc, animated: true)
            break
        case "About Soapbx":
            let vc = CMSPageVC()
            vc.screenType = .about
            rootViewController.pushViewController(vc, animated: true)
            break
        case "Terms of Service":
            let vc = CMSPageVC()
            vc.screenType = .termsCondition
            rootViewController.pushViewController(vc, animated: true)
            
            break
        case "Privacy Policy":
            let vc = CMSPageVC()
            vc.screenType = .policy
            rootViewController.pushViewController(vc, animated: true)
            
            break
        case "Logout":
            mackRootView(LoginVC())
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

