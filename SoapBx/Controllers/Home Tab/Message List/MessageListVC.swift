//
//  MessageListVC.swift
//  SoapBx
//
//  Created by Mac on 22/07/23.
//

import UIKit
import OTLContaner

class MessageListVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var searchView: OTLPTButton!
    @IBOutlet private weak var txtSearch: UITextField!
    @IBOutlet private weak var btnMessageRequest: OTLTextButton!
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var lblNoData: UILabel!
    private let vmObject = MessageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getChatUserList()
    }

    private func setupUI() {
        
        viewHeader.lblTitle.setHeader(LocalStrings.SEARCH_TITLE.rawValue.addLocalizableString())
        
        searchView.backgroundColor = .lightGrey
        searchView.layer.cornerRadius = searchView.frame.height/2
        searchView.imageView?.image = UIImage(named: "ic_search")?.withRenderingMode(.alwaysTemplate)
        searchView.imageView?.tintColor = .titleBlack
        txtSearch.font = AppFont.regular.font(size: 16)
        
        btnMessageRequest.setTheme(LocalStrings.CHAT_REQUEST.rawValue.addLocalizableString(), color: .primaryBlue, size: 10)
        
        tblList.register(["MessageListCell"], delegate: self, dataSource: self)
        lblNoData.noDataTitle(LocalStrings.CHAT_NO_DATA.rawValue.addLocalizableString())
    }

    func getChatUserList() {
        showLoader()
        vmObject.getUserChatList() { [self] result in
            hideLoader()
            if result.status {
                DispatchQueue.main.async {
                    if self.vmObject.arrList.count > 0 {
                        self.lblNoData.isHidden = true
                        self.tblList.reloadData {
                        }
                    }
                }
            }
        }
    }
    
    //
    @IBAction private func click_messageRequest() {
        
    }
    
    private func message(rName: String, rId: Int) {
        showLoader()
        vmObject.message(user: rId) {[self] result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                let vc = ChatVC()
                    vc.userName = rName
                    vc.userId = rId
                    vc.uniqueID = vmObject.uniqueId
                    vc.relationID = vmObject.relationId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}



extension MessageListVC: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vmObject.arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item: MessageModel = vmObject.arrList[indexPath.row] as! MessageModel
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageListCell") as! MessageListCell
        cell.lblMessage.text = item.message
        cell.vwMessage.roundedViewCorner(radius: 5)
        cell.lblUName.text = item.rName
        cell.imgUser.setImage(item.rImage)
        cell.lblTime.setTheme(OTLDateConvert.instance.convert(date: item.created_at ?? "", set: .yyyyMMdd_T_HHmmssDotssZ, getFormat: .mmmDDyyyyAthhmma), size: 11)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1) >= (vmObject.arrList.count - 3){
            if vmObject.currentPage < vmObject.totalPage {
                vmObject.currentPage = vmObject.currentPage + 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: MessageModel = vmObject.arrList[indexPath.row] as! MessageModel
        message(rName: item.rName!, rId: item.receiver_id!)
    }
}
