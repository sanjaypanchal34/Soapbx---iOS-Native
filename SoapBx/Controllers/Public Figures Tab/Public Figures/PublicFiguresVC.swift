//
//  PublicFiguresVC.swift
//  SoapBx
//
//  Created by Mac on 10/07/23.
//

import UIKit
import OTLContaner

class PublicFiguresVC: UIViewController {

    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var searchView: OTLPTButton!
    @IBOutlet private weak var tblList: UITableView!
    
    @IBOutlet private weak var bottomTab: OTLBottomTabBar!
    
    private let vmObject = PublicFiguresViewModel()
    private let vmProfile = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        politicianList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomTab.selectedTab = .publicFigures
    }

    private func setupUI() {
        bottomTab.setTabTheme()
        bottomTab.delegate = self
        
        viewHeader.lblTitle.setHeader("Public Figures")
        
        searchView.backgroundColor = .lightGrey
        searchView.layer.cornerRadius = searchView.frame.height/2
        searchView.imageView?.image = UIImage(named: "ic_search")?.withRenderingMode(.alwaysTemplate)
        searchView.imageView?.tintColor = .titleGray
        
        tblList.register(["PublicFiguresItemCell"], delegate: self, dataSource: self)
        updateList()
    }

    //
    @IBAction private func click_search() {
        let vc = SearchVC()
        vc.navigateFromPublicFigures()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // API Calls
    private func updateList() {
        vmObject.updateViewComplition = {
            self.tblList.reloadData()
            hideLoader()
        }
    }
    
    private func politicianList() {
        showLoader()
        vmObject.politicianList{ result in
            hideLoader()
            self.tblList.reloadData()
        }
    }
    
    private func follow(_ row: Int) {
        showLoader()
        vmProfile.follow(user: vmObject.arrList[row].id ?? 0, user: vmObject.arrList[row].roleID ?? 3) { result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                self.vmObject.arrList[row].statusPoli = 1
                if let cell = self.tblList.cellForRow(at: IndexPath(row: row, section: 0)) as? PublicFiguresItemCell {
                    cell.updateDate(self.vmObject.arrList[row])
                }
            }
        }
    }
    
    private func unfollow(_ row: Int) {
        showLoader()
        vmProfile.unfollow(user: vmObject.arrList[row].id ?? 0) { result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                self.vmObject.arrList[row].statusPoli = 0
                if let cell = self.tblList.cellForRow(at: IndexPath(row: row, section: 0)) as? PublicFiguresItemCell {
                    cell.updateDate(self.vmObject.arrList[row])
                }
            }
        }
    }
}
extension PublicFiguresVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vmObject.arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PublicFiguresItemCell") as? PublicFiguresItemCell {
            cell.setPoliticianData(vmObject.arrList[indexPath.row], indexPath: indexPath, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1) >= (vmObject.arrList.count - 3){
            if vmObject.currentPage < vmObject.totalPage {
                vmObject.currentPage = vmObject.currentPage + 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if authUser?.loginType == .userLogin {
            if let _ = authUser?.user {
                let vc = PoliticianProfileVC()
                vc.navigation(vmObject.arrList[indexPath.row], indexPath: indexPath, delegate: self)
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            showAlert(message: "You must Login to access this feature",buttons: ["Cancel", "Login"]) { alert in
                if alert.title == "Login" {
                    mackRootView(LoginVC())
                }
            }
        }
    }
}
extension PublicFiguresVC: PublicFiguresItemDelegate {
    func publicFigures(_ cell: PublicFiguresItemCell, didSelectActionButton object: PostUser) {
        if object.statusPoli == 1 {
            unfollow(cell.indexPath.row)
        } else {
            follow(cell.indexPath.row)
        }
    }
}
extension PublicFiguresVC: PoliticianProfileDelegate {
    func politicianProfile(didUpadate user: PostUser, at indexPath: IndexPath) {
        self.vmObject.arrList[indexPath.row] = user
        if let cell = self.tblList.cellForRow(at: indexPath) as? PublicFiguresItemCell {
            cell.updateDate(self.vmObject.arrList[indexPath.row])
        }
    }
}
extension PublicFiguresVC: OTLBottomTabBarDelegate {
    
    func didChangeTab(old: OTLContaner.OTLBottomTabBarItem, new: OTLContaner.OTLBottomTabBarItem) {
        
        switch new {
            case .home:
                mackRootView(HomeVC())
                break
            case .publicFigures:
                break
            case .addPost:
                if authUser?.loginType == .userLogin {
                    if let _ = authUser?.user {
                        navigationController?.pushViewController(CreatePostVC(), animated: true)
                    }
                } else {
                    bottomTab.selectedTab = .publicFigures
                    showAlert(message: "You must Login to access this feature",buttons: ["Cancel", "Login"]) { alert in
                        if alert.title == "Login" {
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
                    bottomTab.selectedTab = .publicFigures
                    showAlert(message: "You must Login to access this feature",buttons: ["Cancel", "Login"]) { alert in
                        if alert.title == "Login" {
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
                    bottomTab.selectedTab = .publicFigures
                    showAlert(message: "You must Login to access this feature",buttons: ["Cancel", "Login"]) { alert in
                        if alert.title == "Login" {
                            mackRootView(LoginVC())
                        }
                    }
                }
                break
        }
    }
    
    
}
