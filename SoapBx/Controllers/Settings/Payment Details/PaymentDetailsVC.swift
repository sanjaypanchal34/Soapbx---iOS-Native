//
//  PaymentDetailsVC.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 15/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import UIKit
import OTLContaner

class PaymentDetailsVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var lblNoDataFound: UILabel!
    @IBOutlet private weak var tblList: UITableView!
    
    private let vmObject = PaymentDetailsVIewModel()
    private let currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getTransaction()
    }
    
    private func setupUI() {
        viewHeader.lblTitle.setHeader(LocalStrings.PAYMENT_TITLE.rawValue.addLocalizableString())
        
        lblNoDataFound.noDataTitle(LocalStrings.C_NO_DATA.rawValue.addLocalizableString())
        
        viewBody.backgroundColor = .white
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullupRefresh(_:)), for: .valueChanged)
        tblList.refreshControl = refreshControl
        
        tblList.backgroundColor = .lightGrey
        tblList.register(["PaymentCell"], delegate: self, dataSource: self)
        updateList()
    }
    
    @objc private func pullupRefresh(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        for cell in tblList.visibleCells {
            if let cell = cell as? PollsListItemCell {
                cell.removeObserverItem()
            }
        }
        vmObject.setPage(1)
    }
    
    private func updateList() {
        vmObject.updateViewComplition = { [self] in
            hideLoader()
            tblList.reloadData()
            lblNoDataFound.isHidden = vmObject.arrList.count > 0
        }
    }
    
        //API Calls
    private func getTransaction() {
        showLoader()
        vmObject.getTransactions {[self] result in
            hideLoader()
            tblList.reloadData()
            lblNoDataFound.isHidden = vmObject.arrList.count > 0
        }
    }
    
}
extension PaymentDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vmObject.arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell") as? PaymentCell {
            let item: PaymentModel = vmObject.arrList[indexPath.row] as! PaymentModel
            cell.lblTitle.text = String(format: "Subscription (%@)", item.duration!)
            cell.lblAmount.text = String(format: "%.2f USD", item.amount ?? 0.0)
            cell.lblTime.setTheme(OTLDateConvert.instance.convert(date: item.created_at ?? "", set: .yyyyMMdd_T_HHmmssDotssZ, getFormat: .mmmDDyyyyAthhmma), color: UIColor.lightGray, size: 11)
            return cell
        }
        return UITableViewCell()
    }
    
}
