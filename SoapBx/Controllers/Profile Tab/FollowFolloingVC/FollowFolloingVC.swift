//
//  FollowFolloingVC.swift
//  SoapBx
//
//  Created by Mac on 12/07/23.
//

import UIKit
import OTLContaner

enum FollowFolloingType {
    case followers, following, politicians
}

class FollowFolloingVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var viewButtons: UIView!
    @IBOutlet private weak var btnFollowers: OTLTextButton!
    @IBOutlet private weak var btnFollowing: OTLTextButton!
    @IBOutlet private weak var btnPoliticians: OTLTextButton!
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var lblNodata: UILabel!
    
    private var refreshControl:UIRefreshControl!
    private let vmObject = FollowFolloingViewModel()
    private let vmProfile = ProfileViewModel()
    private var screenType = ProfileScreenType.profileTab
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if vmObject.userObj == nil  {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func navigate(_ user: PostUser, tab: FollowFolloingType, screenType: ProfileScreenType) {
        vmObject.userObj = user
        vmObject.userObj = user
        vmObject.currentTabIndex = tab
        
        self.screenType = screenType
    }
    
    //
    private func setupUI() {
        viewHeader.lblTitle.setHeader(vmObject.userObj?.name ?? "")
        
        viewButtons.backgroundColor = .lightGrey
        viewButtons.layer.cornerRadius = 10
        btnFollowers.setTheme("Followers")
        btnFollowers.layer.cornerRadius = 10
        btnFollowing.setTheme("Following")
        btnFollowing.layer.cornerRadius = 10
        btnPoliticians.setTheme("Politicians")
        btnPoliticians.layer.cornerRadius = 10
        
        tblList.register(["PublicFiguresItemCell"], delegate: self, dataSource: self)
        
        lblNodata.setTheme("No Data Found",font: .bold, size: 22)
        lblNodata.isHidden = true
        
        if vmObject.currentTabIndex == .followers {
            click_btnFollowers()
        }
        else if vmObject.currentTabIndex == .following {
            click_btnFollowing()
        }
        else if vmObject.currentTabIndex == .politicians {
            click_btnPoliticians()
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullupRefresh(_:)), for: .valueChanged)
        tblList.refreshControl = refreshControl
        
        updateList()
    }
    
    
    // Actions
    @objc private func pullupRefresh(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        let oldValue = vmObject.currentTabIndex
        vmObject.currentTabIndex = oldValue
    }
    
    @IBAction private func click_btnFollowers() {
        vmObject.currentTabIndex = .followers
        btnFollowers.backgroundColor = .primaryBlue
        btnFollowers.textColor = .white
        btnFollowing.backgroundColor = .clear
        btnFollowing.textColor = .titleBlack
        btnPoliticians.backgroundColor = .clear
        btnPoliticians.textColor = .titleBlack
    }
    @IBAction private func click_btnFollowing() {
        vmObject.currentTabIndex = .following
        btnFollowers.backgroundColor = .clear
        btnFollowers.textColor = .titleBlack
        btnFollowing.backgroundColor = .primaryBlue
        btnFollowing.textColor = .white
        btnPoliticians.backgroundColor = .clear
        btnPoliticians.textColor = .titleBlack
    }
    @IBAction private func click_btnPoliticians() {
        vmObject.currentTabIndex = .politicians
        btnFollowers.backgroundColor = .clear
        btnFollowers.textColor = .titleBlack
        btnFollowing.backgroundColor = .clear
        btnFollowing.textColor = .titleBlack
        btnPoliticians.backgroundColor = .primaryBlue
        btnPoliticians.textColor = .white
    }
    
    private func updateList() {
        vmObject.updateViewComplition = {
            hideLoader()
            self.tblList.reloadData()
            self.tblList.isHidden = !(self.vmObject.arrList.count > 0)
            self.lblNodata.isHidden = self.vmObject.arrList.count > 0
        }
    }
    
    // API Calls
    
    private func unfollowRemoveUser(indexPath: IndexPath, isRemove: Bool = false) {
        showLoader()
        vmProfile.unfollow(user: vmObject.arrList[indexPath.row].id ?? 0, isRemove: isRemove) {[self] result in
            hideLoader()
            showToast(message: result.message)
            vmObject.arrList.remove(at: indexPath.row)
            tblList.reloadData()
            
        }
    }
    
    private func follow(user id: Int, roleID: Int) {
        showLoader()
        vmProfile.follow(user: id,
                        user: roleID) {[self] result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                pullupRefresh(refreshControl)
            }
        }
    }
    
    private func cancelRequest(user id: Int) {
        showLoader()
        vmProfile.cancelRequest(user: id){[self] result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                pullupRefresh(refreshControl)
            }
        }
    }
}
extension FollowFolloingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vmObject.arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PublicFiguresItemCell") as? PublicFiguresItemCell {
            if vmObject.currentTabIndex == .followers {
                cell.setDataFollowers(self.vmObject.arrList[indexPath.row], indexPath: indexPath, delegate: self)
            }
            else  if vmObject.currentTabIndex == .following {
                cell.setDataFollowing(self.vmObject.arrList[indexPath.row], indexPath: indexPath, delegate: self)
            }
            else if vmObject.currentTabIndex == .politicians {
                cell.setDataPoliticians(self.vmObject.arrList[indexPath.row], indexPath: indexPath, delegate: self)
            }
            if screenType != .profileTab || authUser?.loginType != .userLogin {
                cell.hideButtonsForOtherUser()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.vmObject.arrList[indexPath.row].id != authUser?.user?.id else { return }
        
        if vmObject.currentTabIndex == .followers || vmObject.currentTabIndex == .following {
            let vc = ProfileVC()
            vc.navigateForOtherUser(self.vmObject.arrList[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if vmObject.currentTabIndex == .politicians {
            let vc = PoliticianProfileVC()
            vc.navigation(self.vmObject.arrList[indexPath.row], indexPath: indexPath, delegate: self)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension FollowFolloingVC: PublicFiguresItemDelegate {
    func publicFigures(_ cell: PublicFiguresItemCell, didSelectActionButton object: PostUser) {
        if vmObject.currentTabIndex == .followers {
            if object.statusUser == 0 {
                follow(user: object.id ?? 0, roleID: object.roleID ?? 0)
            } else if object.statusUser == 1 {
                cancelRequest(user: object.id ?? 0)
            }
        }
        else if vmObject.currentTabIndex == .following {
            unfollowRemoveUser(indexPath: cell.indexPath)
        }
        else if vmObject.currentTabIndex == .politicians {
            unfollowRemoveUser(indexPath: cell.indexPath)
        }
    }
    
    func publicFigures(_ cell: PublicFiguresItemCell, didSelectAction2Button object: PostUser) {
        if vmObject.currentTabIndex == .followers {
            unfollowRemoveUser(indexPath: cell.indexPath, isRemove: true)
        }
    }
}
extension FollowFolloingVC: PoliticianProfileDelegate {
    func politicianProfile(didUpadate user: PostUser, at indexPath: IndexPath) {
        
    }
}
