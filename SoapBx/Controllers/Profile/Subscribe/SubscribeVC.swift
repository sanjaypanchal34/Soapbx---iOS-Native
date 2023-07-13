//
//  SubscribeVC.swift
//  SoapBx
//
//  Created by Mac on 08/07/23.
//

import UIKit

class SubscribeVC: UIViewController {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var btnNext: UIButton!
    
    //
    private var arrSubscribeNote: [SubscribeNotesModel] = []
    private var arrSubscribe: [SubscribeModel] = []
    private var isFreemiumSelected = true
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    //MARK: - Setup UI
    private func setupUI() {
        lblTitle.setTheme("Subscribe on Soapbx",
                          font: .bold,
                          size: 40)
        tblList.register(["SubscriptionNotesItemCell","SubscriptionNotesHeaderCell", "SubscriptionItemCell"], delegate: self, dataSource: self)
        
        btnNext.appButton("Next")
        
        arrSubscribeNote = [
            SubscribeNotesModel(title: "Blog and Report", freemium: "1/Month", premium: "1/Day",canSymbol: false),
            SubscribeNotesModel(title: "Conduct Polls", freemium: "1", premium: "1/Week",canSymbol: false),
            SubscribeNotesModel(title: "Priority Support", freemium: "n", premium: "y"),
            SubscribeNotesModel(title: "Choose Trends", freemium: "y", premium: "y"),
            SubscribeNotesModel(title: "Soapbx Initiatives", freemium: "n", premium: "y"),
            SubscribeNotesModel(title: "Featured Member", freemium: "n", premium: "y"),
            SubscribeNotesModel(title: "Rewards", freemium: "n", premium: "y"),
            SubscribeNotesModel(title: "Invite Friends", freemium: "y", premium: "y"),
            SubscribeNotesModel(title: "Featured Blog", freemium: "y", premium: "y"),
            SubscribeNotesModel(title: "Featured Poll", freemium: "n", premium: "y"),
        ]
        
        arrSubscribe = [
            SubscribeModel(title: "Freemium", subtitle: "This is free one", isSelected: true),
            SubscribeModel(title: "Premium", subtitle: "$3.99 / 1 Month"),
            SubscribeModel(title: "Premium", subtitle: "$12.00 / 6 Month"),
            SubscribeModel(title: "Premium", subtitle: "$22.00 / 1 Year"),
        ]
        tblList.reloadData()
    }
    
    @IBAction private func click_btnNext() {
        let vc = EnableLocationVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension SubscribeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrSubscribeNote.count
        }
        return arrSubscribe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0,
           let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionNotesItemCell") as? SubscriptionNotesItemCell {
            cell.setData(arrSubscribeNote[indexPath.row],
                         isFreemiumSelected: isFreemiumSelected,
                         isLastIndex: (arrSubscribeNote.count - 1) == indexPath.row )
            return cell
        } else if indexPath.section == 1,
                  let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionItemCell") as? SubscriptionItemCell {
            cell.setData(arrSubscribe[indexPath.row])
            return cell
                }
        return UITableViewCell()
    }
}
extension SubscribeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if let header = tableView.dequeueReusableCell(withIdentifier: "SubscriptionNotesHeaderCell") as? SubscriptionNotesHeaderCell {
                header.setData(SubscribeNotesModel(title: "", freemium: "Freemium", premium: "Premium"), isFreemiumSelected: isFreemiumSelected)
                return header
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return UITableView.automaticDimension
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                isFreemiumSelected = true
            }
            else {
                isFreemiumSelected = false
            }
            for index in 0..<arrSubscribe.count {
                arrSubscribe[index].isSelected = false
            }
            arrSubscribe[indexPath.row].isSelected = true
            tableView.reloadData()
        }
    }
}
