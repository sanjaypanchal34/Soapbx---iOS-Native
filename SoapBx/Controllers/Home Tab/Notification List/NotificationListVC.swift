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
    private let vmObject = NotificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getNotificationList()
    }

    private func setupUI() {
        viewHeader.lblTitle.setHeader(LocalStrings.NOTI_TITLE.rawValue.addLocalizableString())
        
        lblNoDataFound.noDataTitle(LocalStrings.NOTI_NO_DATA.rawValue.addLocalizableString())
        lblNoDataFound.isHidden = true
        
        tblList.register(["NotificationListItemCell"], delegate: self, dataSource: self)
    }
    
    func getNotificationList() {
        showLoader()
        vmObject.getNotifications() { [self] result in
            hideLoader()
            if result.status {
                DispatchQueue.main.async {
                    if self.vmObject.arrList.count > 0 {
                        self.tblList.reloadData {
                        }
                    }
                }
            }
        }
    }
}

extension NotificationListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vmObject.arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationListItemCell") as? NotificationListItemCell {
            let item: NotificationModel = vmObject.arrList[indexPath.row] as! NotificationModel
            cell.lblTitle.setTheme(item.description ?? "", size: 14)
            cell.lblTime.setTheme(OTLDateConvert.instance.convert(date: item.created_at ?? "", set: .yyyyMMdd_T_HHmmssDotssZ, getFormat: .mmmDDyyyyAthhmma), size: 11)
            return cell
        }
        return UITableViewCell()
    }
}



