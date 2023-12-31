//
//  PollsListVC.swift
//  SoapBx
//
//  Created by Mac on 22/07/23.
//

import UIKit
import OTLContaner

class PollsListVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    @IBOutlet private weak var btnPostPolls: OTLImageButton!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var lblNoDataFound: UILabel!
    @IBOutlet private weak var tblList: UITableView!
    
    private let vmObject = PollsListViewModel()
    private let currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getPolls()
    }

    private func setupUI() {
        viewHeader.lblTitle.setHeader(LocalStrings.POLL_TITLE.rawValue.addLocalizableString())
        btnPostPolls.image = UIImage(named: "ic_paymentAdd")
        
        lblNoDataFound.noDataTitle(LocalStrings.POLL_NO_DATA.rawValue.addLocalizableString())
        
        viewBody.backgroundColor = .lightGrey
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullupRefresh(_:)), for: .valueChanged)
        tblList.refreshControl = refreshControl
        
        tblList.backgroundColor = .lightGrey
        tblList.register(["PollsListItemCell"], delegate: self, dataSource: self)
        updateList()
    }
    
    
    @IBAction private func click_postPoll(_ sender: OTLTextButton) {
        let vc = PostPollsVC()
        navigationController?.pushViewController(vc, animated: true)
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
    private func getPolls() {
        showLoader()
        vmObject.getPolls {[self] result in
            hideLoader()
            tblList.reloadData()
            lblNoDataFound.isHidden = vmObject.arrList.count > 0
        }
    }
    
    private func voteOnPoll(indexPath: IndexPath, pollId: Int, optionId: Int) {
        showLoader()
        vmObject.voteOnPoll(pollId: pollId, optionId: optionId) {[self] (result, json) in
            hideLoader()
            showToast(message: result.message)
            tblList.reloadData()
            lblNoDataFound.isHidden = vmObject.arrList.count > 0
            vmObject.arrList[indexPath.row].pollPercent = json
            vmObject.arrList[indexPath.row].options = vmObject.arrList[indexPath.row].options?.compactMap({ (option) in
                var copy = option
                if option.id == optionId , copy.selectStatus == 1{
                    copy.selectStatus = 0
                } else {
                    copy.selectStatus = option.id == optionId ? 1 : 0
                }
                return copy
            })
            
            if let cell = tblList.cellForRow(at: indexPath) as? PollsListItemCell {
                cell.updateValue(vmObject.arrList[indexPath.row])
            }
        }
    }
}
extension PollsListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vmObject.arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PollsListItemCell") as? PollsListItemCell {
            cell.indexPath = indexPath
            cell.setData(vmObject.arrList[indexPath.row], date: currentDate, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? PollsListItemCell {
            cell.removeObserverItem()
        }
    }
}
extension PollsListVC: PollsListItemDelegate {
    func pollsListItem(_ cell: AppTableViewCell, vote poll: PollModel, option: Option) {
        voteOnPoll(indexPath: cell.indexPath, pollId: poll.id ?? 0, optionId: option.id ?? 0)
    }
    
    func pollsListItem(_ cell: AppTableViewCell, updateHeight: Void) {
        self.tblList.beginUpdates()
        self.tblList.setNeedsDisplay()
        self.tblList.endUpdates()
    }
}
