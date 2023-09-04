//
//  ChatVC.swift
//  SoapBx
//
//  Created by Mac on 23/07/23.
//

import UIKit
import OTLContaner
import PusherSwift

var channel: PusherChannel!
var eventName: String!
    

let pusher = Pusher(key: kPusherKey, options: PusherClientOptions(
    authMethod: AuthMethod.inline(secret: kPusherSecret),
    autoReconnect: true,
    host: .cluster(kCluster)
    ))

class ChatVC: UIViewController , PusherDelegate{
    
    var uniqueID: Int!
    var relationID: Int!
    @IBOutlet private weak var viewHeader: OTLHeader!
    @IBOutlet private weak var btnDotMenu: OTLImageButton!
    
    @IBOutlet private weak var viewBody: UIView!
    
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var lblNoData: UILabel!
    
    @IBOutlet private weak var viewMessage: UIView!
    @IBOutlet private weak var txtMessage: UITextField!
    @IBOutlet private weak var btnAddMedia: OTLImageButton!
    @IBOutlet private weak var btnSendMessage: OTLImageButton!
    
    var userName: String = ""
    var userId: Int?
    private let vmObject = ChatViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getChatList()
    }

    override func viewDidDisappear(_ animated: Bool) {
        pusher.disconnect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupPusher()
    }
    private func updateList() {
        vmObject.updateViewComplition = {
            DispatchQueue.main.async {
                if self.vmObject.arrList.count > 0 {
                    DispatchQueue.main.async {
                        if self.vmObject.arrList.count > 0 {
                            self.tblList.reloadData {
                                self.tblList.scrollToBottom()
                            }
                        }
                    }
                }
            }
            hideLoader()
        }
    }
    
    func getChatList() {
        showLoader()
        vmObject.getMessage(relationId : relationID) { [self] result in
            hideLoader()
            if result.status {
                DispatchQueue.main.async {
                    if self.vmObject.arrList.count > 0 {
                        self.tblList.reloadData {
                            self.tblList.scrollToBottom()
                        }
                    }
                }
            }
        }
    }
    
    private func setupUI() {
        viewHeader.lblTitle.setHeader(self.userName)
        
        btnDotMenu.image = UIImage(named: "ic_dots")
        btnDotMenu.height = 30
        btnDotMenu.isHidden = true
        
        tblList.register(["ChatRCell"], delegate: self, dataSource: self)
        tblList.register(["ChatSCell"], delegate: self, dataSource: self)
        updateList()
        lblNoData.noDataTitle("")
        
        viewMessage.backgroundColor = .lightGrey
        viewMessage.layer.cornerRadius = 10
        viewMessage.layer.borderWidth = 1
        viewMessage.layer.borderColor = UIColor.titleGray.cgColor
        
        btnAddMedia.image = UIImage(named: "ic_paymentAdd")
        btnAddMedia.height = 25
        btnAddMedia.backgroundColor = .clear
        btnDotMenu.isHidden = true
        
        txtMessage.font = AppFont.regular.font(size: 16)
        txtMessage.backgroundColor = .clear
        btnSendMessage.image = UIImage(named: "ic_chatSend")
        btnSendMessage.height = 25
        btnSendMessage.backgroundColor = .white
        
    }

    //
    @IBAction private func click_btnDotMenu() {
        view.showThreeDotMenu(array: [
            ThreeDotItemModel(title: .clearChat, icon: "ic_clearChat"),
            ThreeDotItemModel(title: .starredMessage, icon: "ic_starChat"),
            ThreeDotItemModel(title: .block, icon: "ic_shield"),
        ])
        { obj in
            
        }
    }
    @IBAction private func click_btnAddMedia() {
        let camera = OTLAlertModel(title: LocalStrings.C_CAMERA.rawValue.addLocalizableString(), id: 0)
        let gellary = OTLAlertModel(title: LocalStrings.C_GALLERY.rawValue.addLocalizableString(), id: 1)
        let cancel = OTLAlertModel(title: LocalStrings.C_CANCEL.rawValue.addLocalizableString(), id: 2)
        
        showAlert(message: LocalStrings.C_MEDIA_TYPE.rawValue.addLocalizableString(), buttons: [camera, gellary, cancel])
    }
    
    @IBAction private func click_btnSendMessage() {
        if self.txtMessage.text?.count ?? 0 > 0 {
            showLoader()
            vmObject.sendMessage(relationId : relationID, sender: authUser?.user?.id ?? 0, receiver: self.userId ?? 0, message: self.txtMessage.text ?? "") { [self] result in
                if result.status {
                    self.txtMessage.text = ""
                }
            }
        }
    }
    
}
extension ChatVC: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vmObject.arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id: Int = authUser?.user?.id ?? 0
        let item: ChatModel = vmObject.arrList[indexPath.row] as! ChatModel
        if id == item.sender_id {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatSCell") as! ChatSCell
            cell.lblMessage.text = item.message
            cell.lblMessage.sizeToFit()
            cell.vwMessage.roundedViewCorner(radius: 5)
            cell.lblUName.text = ""
            cell.lblUName.text = item.sName?.first?.uppercased()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRCell") as! ChatRCell
            cell.lblMessage.text = item.message
            cell.lblMessage.sizeToFit()
            cell.vwMessage.roundedViewCorner(radius: 5)
            cell.lblUName.text = ""
            cell.lblUName.text = item.sName?.first?.uppercased()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1) >= (vmObject.arrList.count - 3){
            if vmObject.currentPage < vmObject.totalPage {
                vmObject.currentPage = vmObject.currentPage + 1
            }
        }
    }
    
    func setupPusher() -> Void {
        print("kPusherKey: \(kPusherKey)")
        // subscribe to channel and bind to event
        
        if pusher.connection.connectionState == .disconnected
        {
            pusher.connect()
            pusher.connection.delegate = self
            
            channel = pusher.subscribe(getChannelName())
            
            print("channel: " + getChannelName())
            
            eventName = channel.bind(eventName:kPusherNotifEventMessage, callback: { data -> Void in
                print("notif_comment message received: \(data ?? "")")
                hideLoader()
                if let d = data as? JSON {
                    let chat_relation_id: String = d["chat_relation_id"] as! String
                    let id: Int = d["id"] as! Int
                    let receiver_id: String = d["receiver_id"] as! String
                    let sender_id: Int = d["sender_id"] as! Int
                    let message: String = d["message"] as! String
                    let receiver_name: String = d["receiver_name"] as! String
                    let sender_name: String = d["sender_name"] as! String
                    let model: ChatModel = .init(id: id, chat_relation_id: Int(chat_relation_id), sender_id: sender_id, receiver_id: Int(receiver_id), message: message, sName: sender_name, sImage: "", rName: receiver_name, rImage: "")
                    self.vmObject.arrList.append(model)
                }
                
                DispatchQueue.main.async {
                    if self.vmObject.arrList.count > 0 {
                        self.tblList.reloadData {
                            self.tblList.scrollToBottom()
                            self.txtMessage.text = ""
                        }
                    }
                }
            })

        }
    }
    
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        print("Connection state old = \(old.rawValue), new = \(new.rawValue)")
    }
    
    func subscribedToChannel(name: String) {
        print("subscribedToChannel \(name)")
    }
    
    func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?, error: NSError?) {
        print("failedToSubscribeToChannel = \(name), err = \(String(describing: error))")
    }
    
    func debugLog(message: String) {
        print("debugLog = \(message)")
    }

    func getChannelName() -> String {
        return String(format: "%@%d", channel_id, self.uniqueID )
    }
}

extension UITableView {
    
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: reloadData)
            { _ in completion() }
    }
    
    func scrollToBottom(isAnimated:Bool = true){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
            }
        }
    }
    
    func scrollToTop(isAnimated:Bool = true) {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
}

extension UIView {
    func roundedViewCorner(radius: Int){
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
}
