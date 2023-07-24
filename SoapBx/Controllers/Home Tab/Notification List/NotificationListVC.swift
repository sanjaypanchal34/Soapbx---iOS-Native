//
//  NotificationListVC.swift
//  SoapBx
//
//  Created by Mac on 22/07/23.
//

import UIKit
import OTLContaner

class NotificationListVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var lblNoDataFound: UILabel!
    @IBOutlet private weak var tblList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        viewHeader.lblTitle.setHeader("Notifications")
        
        lblNoDataFound.noDataTitle("No Polls Found")
        lblNoDataFound.isHidden = true
        
        tblList.register(["NotificationListItemCell"], delegate: self, dataSource: self)
    }
    
}
extension NotificationListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationListItemCell") as? NotificationListItemCell {
            return cell
        }
        return UITableViewCell()
    }
}



