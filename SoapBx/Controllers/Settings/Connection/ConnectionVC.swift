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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        viewHeader.lblTitle.setHeader(screenType == .fromConnection ? "Connections" : "Friends")
        
        viewTabaction.layer.cornerRadius = 10
        viewTabaction.clipsToBounds = true
        
        btnBlock.setTheme(screenType == .fromConnection ? "Blocked account" : "Request",
                          color: .white,
                          font: .semibold)
        
        btnUnfollow.setTheme(screenType == .fromConnection ? "Unfollowed account" : "My Friends",
                             color: .white,
                             font: .semibold)
        click_TabBar(btnBlock)
        
        tblList.register(["PublicFiguresItemCell"], delegate: self, dataSource: self)
        lblNoData.noDataTitle("No Data Found")
    }
    
    
    @IBAction private func click_TabBar(_ sender: OTLTextButton) {
        if sender == btnBlock {
            btnBlock.backgroundColor = .primaryBlue
            btnBlock.textColor = .white
            btnUnfollow.backgroundColor = .lightGrey
            btnUnfollow.textColor = .titleGrey
        } else {
            btnBlock.backgroundColor = .lightGrey
            btnBlock.textColor = .titleGrey
            btnUnfollow.backgroundColor = .primaryBlue
            btnUnfollow.textColor = .white
        }
    }
}
extension ConnectionVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if screenType == .fromConnection{
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PublicFiguresItemCell") as? PublicFiguresItemCell {
            cell.indexPath = indexPath
            cell.setDataBlock()
            return cell
        }
        return UITableViewCell()
    }
}


