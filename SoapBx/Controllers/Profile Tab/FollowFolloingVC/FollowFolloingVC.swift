//
//  FollowFolloingVC.swift
//  SoapBx
//
//  Created by Mac on 12/07/23.
//

import UIKit
import OTLContaner

class FollowFolloingVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var viewButtons: UIView!
    @IBOutlet private weak var btnFollowers: UIButton!
    @IBOutlet private weak var btnFollowing: UIButton!
    @IBOutlet private weak var btnPoliticians: UIButton!
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var lblNodata: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //
    private func setupUI() {
        viewHeader.lblTitle.setHeader("Robert Watson")
        
        viewButtons.backgroundColor = .lightGrey
        viewButtons.layer.cornerRadius = 10
        btnFollowers.setTheme("Followers")
        btnFollowers.layer.cornerRadius = 10
        btnFollowing.setTheme("Folloing")
        btnFollowing.layer.cornerRadius = 10
        btnPoliticians.setTheme("Politicians")
        btnPoliticians.layer.cornerRadius = 10
        
        tblList.register(["PublicFiguresItemCell"], delegate: self, dataSource: self)
        
        lblNodata.setTheme("No Data Found",font: .bold, size: 22)
        lblNodata.isHidden = true
        
        click_btnFollowers()
    }
    
    @IBAction private func click_btnFollowers() {
        btnFollowers.backgroundColor = .primaryBlue
        btnFollowers.setTitleColor(.white, for: .normal)
        btnFollowing.backgroundColor = .clear
        btnFollowing.setTitleColor(.titleBlack, for: .normal)
        btnPoliticians.backgroundColor = .clear
        btnPoliticians.setTitleColor(.titleBlack, for: .normal)
        lblNodata.isHidden = false
        tblList.isHidden = true
    }
    @IBAction private func click_btnFolloing() {
        btnFollowers.backgroundColor = .clear
        btnFollowers.setTitleColor(.titleBlack, for: .normal)
        btnFollowing.backgroundColor = .primaryBlue
        btnFollowing.setTitleColor(.white, for: .normal)
        btnPoliticians.backgroundColor = .clear
        btnPoliticians.setTitleColor(.titleBlack, for: .normal)
        lblNodata.isHidden = false
        tblList.isHidden = true
    }
    @IBAction private func click_btnPoliticians() {
        btnFollowers.backgroundColor = .clear
        btnFollowers.setTitleColor(.titleBlack, for: .normal)
        btnFollowing.backgroundColor = .clear
        btnFollowing.setTitleColor(.titleBlack, for: .normal)
        btnPoliticians.backgroundColor = .primaryBlue
        btnPoliticians.setTitleColor(.white, for: .normal)
        tblList.isHidden = false
        lblNodata.isHidden = true
        
    }
}
extension FollowFolloingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PublicFiguresItemCell") as? PublicFiguresItemCell {
            cell.setDataPoliticians()
            return cell
        }
        return UITableViewCell()
    }
    
    
}
