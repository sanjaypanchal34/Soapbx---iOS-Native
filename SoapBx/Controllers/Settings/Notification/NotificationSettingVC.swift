//
//  NotificationSettingVC.swift
//  SoapBx
//
//  Created by Mac on 19/07/23.
//

import UIKit
import OTLContaner

class NotificationSettingVC: UIViewController {
    
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var tblList: UITableView!
    
    private var arrList = [
        NotificationSettingModel(title: "Push Notification", isSelected: true),
        NotificationSettingModel(title: "Direct Notification", isSelected: true),
        NotificationSettingModel(title: "Posts", isSelected: true),
        NotificationSettingModel(title: "New Connection", isSelected: true),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        viewHeader.lblTitle.setHeader("Saved Post")
        
        tblList.register(["NotificationSettingItemCell"], delegate: self, dataSource: self)
    }
}
extension NotificationSettingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationSettingItemCell") as? NotificationSettingItemCell {
            cell.indexPath = indexPath
            cell.setData(arrList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

