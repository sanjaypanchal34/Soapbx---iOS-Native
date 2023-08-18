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
        NotificationSettingModel(id: 1, title: "Push Notification", isSelected: false),
        NotificationSettingModel(id: 2, title: "Direct Notification", isSelected: false),
        NotificationSettingModel(id: 3, title: "Posts", isSelected: false),
        NotificationSettingModel(id: 4, title: "New Connection", isSelected: false),
    ]
    private let vmObject = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getProfile()
    }

    private func setupUI() {
        viewHeader.lblTitle.setHeader("Saved Post")
        
        tblList.register(["NotificationSettingItemCell"], delegate: self, dataSource: self)
    }
    
    // API call
    private func getProfile() {
        showLoader()
        vmObject.getProfile { result in
            hideLoader()
            if result.status {
                self.arrList[0].isSelected = self.vmObject.notificationModel.push == 1 ? true : false
                self.arrList[1].isSelected = self.vmObject.notificationModel.direct == 1 ? true : false
                self.arrList[2].isSelected = self.vmObject.notificationModel.like == 1 ? true : false
                self.arrList[3].isSelected = self.vmObject.notificationModel.connection == 1 ? true : false
                self.tblList.reloadData()
            }
        }
    }
    
    private func updateNotification(_ row: Int) {
        showLoader()
        vmObject.updateNotification(self.arrList[row]) { result in
            hideLoader()
            showToast(message: result.message)
            if result.status ==  false{
                var oldNoti = self.arrList[row]
                oldNoti.isSelected = !oldNoti.isSelected
                if let cell = self.tblList.dequeueReusableCell(withIdentifier: "NotificationSettingItemCell") as? NotificationSettingItemCell {
                    cell.updateData(oldNoti)
                }
            }
        }
    }
}
extension NotificationSettingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationSettingItemCell") as? NotificationSettingItemCell {
            cell.indexPath = indexPath
            cell.setData(arrList[indexPath.row], indexPath: indexPath, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
}

extension NotificationSettingVC: NotificationSettingDelegate {
    func notificationSetting(_ cell: NotificationSettingItemCell, switch togale: Bool) {
        self.arrList[cell.indexPath.row].isSelected = togale
        updateNotification(cell.indexPath.row)
    }
}
