//
//  ConnectionVC.swift
//  SoapBx
//
//  Created by Mac on 20/07/23.
//

import UIKit
import OTLContaner

enum ConnectionScreenType {
    case fromConnection, fromFriends
}

class ConnectionVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var viewTabaction: UIView!
    @IBOutlet private weak var btnBlock: OTLTextButton!
    @IBOutlet private weak var btnUnfollow: OTLTextButton!
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var lblNoData: UILabel!
    
    var screenType = ConnectionScreenType.fromConnection
    private let vmSearch = SearchViewModel()
    private let vmObject = ConnectionViewModel()
    private let vmProfile = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if screenType == .fromFriends{
            getList()
        } else {
            vmObject.selectedTab = .blocked
        }
        
    }

    private func setupUI() {
        viewHeader.lblTitle.setHeader(screenType == .fromConnection ? LocalStrings.CONNECTIONS.rawValue.addLocalizableString() : LocalStrings.CONN_FRIEND.rawValue.addLocalizableString())
        
        viewTabaction.layer.cornerRadius = 10
        viewTabaction.clipsToBounds = true
        
        btnBlock.setTheme(screenType == .fromConnection ? LocalStrings.CONN_BLOCK.rawValue.addLocalizableString() : LocalStrings.CONN_REQUEST.rawValue.addLocalizableString(),
                          color: .white,
                          font: .semibold)
        
        btnUnfollow.setTheme(screenType == .fromConnection ? LocalStrings.CONN_UNFOLLOW_ACCOUNT.rawValue.addLocalizableString() : LocalStrings.CONN_MY_FRIEND.rawValue.addLocalizableString(),
                             color: .white,
                             font: .semibold)
        tblList.register(["PublicFiguresItemCell"], delegate: self, dataSource: self)
        lblNoData.noDataTitle(LocalStrings.C_NO_DATA.rawValue.addLocalizableString())
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullupRefresh(_:)), for: .valueChanged)
        tblList.refreshControl = refreshControl
        
        updateList()
        click_TabBar(btnBlock)
    }
    
    // actions
    @objc private func pullupRefresh(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        if screenType == .fromFriends{
            let oldValue = vmSearch.type
            vmSearch.type = oldValue
        } else {
            let oldValue = vmObject.selectedTab
            vmObject.selectedTab = oldValue
        }
    }
    
    @IBAction private func click_TabBar(_ sender: OTLTextButton) {
        if sender == btnBlock {
            if screenType == .fromFriends{
                vmSearch.type = .friends
            } else {
                vmObject.selectedTab = .blocked
            }
            btnBlock.backgroundColor = .primaryBlue
            btnBlock.textColor = .white
            btnUnfollow.backgroundColor = .lightGrey
            btnUnfollow.textColor = .titleGray
        } else {
            if screenType == .fromFriends{
                vmSearch.type = .myFriends
            } else {
                vmObject.selectedTab = .unfollowed
            }
            btnBlock.backgroundColor = .lightGrey
            btnBlock.textColor = .titleGray
            btnUnfollow.backgroundColor = .primaryBlue
            btnUnfollow.textColor = .white
        }
        
    }
    
    private func updateList() {
        vmSearch.updateViewComplition = { [self] in
            hideLoader()
            tblList.reloadData()
            lblNoData.isHidden = vmSearch.arrList.count > 0
        }
        vmObject.updateViewComplition = { [self] in
            hideLoader()
            tblList.reloadData()
            lblNoData.isHidden = vmObject.arrList.count > 0
        }
    }
    
    private func getList() {
        showLoader()
        vmSearch.getPolitician {[self] result in
            hideLoader()
            tblList.reloadData()
            lblNoData.isHidden = vmSearch.arrList.count > 0
        }
    }
    
    private func unbockedUser(_ indexPath: IndexPath) {
        showLoader()
        vmObject.unbockedUser(user: vmObject.arrList[indexPath.row].id ?? 0 ) {[self] result in
            hideLoader()
            vmObject.arrList.remove(at: indexPath.row)
            tblList.reloadData()
            lblNoData.isHidden = vmObject.arrList.count > 0
            showToast(message: result.message)
        }
    }
    
    private func follow(_ indexPath: IndexPath) {
        showLoader()
        vmProfile.follow(user: vmObject.arrList[indexPath.row].id ?? 0,
                         user: vmObject.arrList[indexPath.row].roleID ?? 3) {[self] result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                click_TabBar(btnUnfollow)
            }
        }
    }
    
    private func acceptRequest(_ indexPath: IndexPath) {
        showLoader()
        vmSearch.acceptRequest(user: vmSearch.arrList[indexPath.row].id ?? 0) {[self] result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                vmSearch.arrList.remove(at: indexPath.row)
                if vmSearch.arrList.count > 0 {
                    tblList.deleteRows(at: [indexPath], with: .fade)
                } else {
                    tblList.reloadData()
                }
                lblNoData.isHidden = vmSearch.arrList.count > 0
            }
        }
    }
    
    
    private func deleteRequest(_ indexPath: IndexPath) {
        showLoader()
        vmSearch.deleteRequest(user: vmSearch.arrList[indexPath.row].id ?? 0) {[self] result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                vmSearch.arrList.remove(at: indexPath.row)
                if vmSearch.arrList.count > 0 {
                    tblList.deleteRows(at: [indexPath], with: .fade)
                } else {
                    tblList.reloadData()
                }
                lblNoData.isHidden = vmSearch.arrList.count > 0
            }
        }
    }
}

extension ConnectionVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if screenType == .fromConnection{
            return self.vmObject.arrList.count
        }
        else if screenType == .fromFriends {
            return self.vmSearch.arrList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PublicFiguresItemCell") as? PublicFiguresItemCell {
            cell.indexPath = indexPath
            if screenType == .fromConnection {
                if vmObject.selectedTab == .blocked {
                    cell.setDataUnblock(self.vmObject.arrList[indexPath.row], indexPath: indexPath, delegate: self)
                } else {
                    cell.setDataUnfollow(self.vmObject.arrList[indexPath.row], indexPath: indexPath, delegate: self)
                }
            }
            else if screenType == .fromFriends {
                if vmSearch.type == .friends {
                    cell.setDataFriend(self.vmSearch.arrList[indexPath.row], indexPath: indexPath, delegate: self)
                } else {
                    cell.setDataMyFriend(self.vmSearch.arrList[indexPath.row], indexPath: indexPath, delegate: self)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if screenType == .fromFriends {
            if vmSearch.type == .myFriends {
                let vc = ProfileVC()
                vc.navigateForOtherUser(self.vmSearch.arrList[indexPath.row])
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension ConnectionVC: PublicFiguresItemDelegate {
    func publicFigures(_ cell: PublicFiguresItemCell, didSelectActionButton object: PostUser) {
        if screenType == .fromConnection {
            if vmObject.selectedTab == .blocked {
                unbockedUser(cell.indexPath)
            } else {
                follow(cell.indexPath)
            }
        } else {
            if vmSearch.type == .friends {
                acceptRequest(cell.indexPath)
            } else {
                
            }
        }
    }
    
    func publicFigures(_ cell: PublicFiguresItemCell, didSelectAction2Button object: PostUser) {
        if screenType == .fromFriends {
            if vmSearch.type == .friends {
                deleteRequest(cell.indexPath)
            }
        }
    }
}
