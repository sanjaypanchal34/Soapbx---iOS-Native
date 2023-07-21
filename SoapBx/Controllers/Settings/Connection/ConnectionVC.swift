//
//  ConnectionVC.swift
//  SoapBx
//
//  Created by Mac on 20/07/23.
//

import UIKit
import OTLContaner

class ConnectionVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var viewTabaction: UIView!
    @IBOutlet private weak var btnBlock: OTLTextButton!
    @IBOutlet private weak var btnUnfollow: OTLTextButton!
    @IBOutlet private weak var tblList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        viewHeader.lblTitle.setHeader("Connections")
        
        viewTabaction.layer.cornerRadius = 10
        viewTabaction.clipsToBounds = true
        
        btnBlock.setTheme("Blocked account", color: .white)
        btnUnfollow.setTheme("Unfollowed account", color: .white)
        click_TabBar(btnBlock)
        
        tblList.register(["PublicFiguresItemCell"], delegate: self, dataSource: self)
    }
    
    
    @IBAction private func click_TabBar(_ sender: OTLTextButton) {
        if sender == btnBlock {
            btnBlock.backgroundColor = .primaryBlue
            btnBlock.textColor = .white
            btnUnfollow.backgroundColor = .lightGrey
            btnUnfollow.textColor = .black
        } else {
            btnBlock.backgroundColor = .lightGrey
            btnBlock.textColor = .black
            btnUnfollow.backgroundColor = .primaryBlue
            btnUnfollow.textColor = .white
        }
    }
}
extension ConnectionVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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


