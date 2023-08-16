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
    var arrData : [Any] = []
    @IBOutlet private weak var viewHeader: OTLHeader!
    @IBOutlet private weak var btnDotMenu: OTLImageButton!
    
    @IBOutlet private weak var viewBody: UIView!
    
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var lblNoData: UILabel!
    
    @IBOutlet private weak var viewMessage: UIView!
    @IBOutlet private weak var txtMessage: UITextField!
    @IBOutlet private weak var btnAddMedia: OTLImageButton!
    @IBOutlet private weak var btnSendMessage: OTLImageButton!
    
    var userObj: PostUser?
    private let vmObject = ChatViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPusher()
        
        getChatList()
    }

    private func updateList() {
        vmObject.updateViewComplition = {
            self.tblList.reloadData()
            hideLoader()
        }
    }
    
    func getChatList() {
        showLoader()
        vmObject.getMessage(relationId : relationID) { [self] result in
            hideLoader()
            if result.status {
                self.tblList.reloadData()
            }
        }
    }
    
    private func setupUI() {
        if let obj = userObj {
            viewHeader.lblTitle.setHeader(obj.fullName ?? "")
        }
        
        btnDotMenu.image = UIImage(named: "ic_dots")
        btnDotMenu.height = 30
        
        tblList.register(["PublicFiguresItemCell"], delegate: self, dataSource: self)
        updateList()
        lblNoData.noDataTitle("")
        
        viewMessage.backgroundColor = .lightGrey
        viewMessage.layer.cornerRadius = 10
        viewMessage.layer.borderWidth = 1
        viewMessage.layer.borderColor = UIColor.titleGrey.cgColor
        
        btnAddMedia.image = UIImage(named: "ic_paymentAdd")
        btnAddMedia.height = 25
        btnAddMedia.backgroundColor = .clear
        btnAddMedia.isHidden = true
        
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
        let camera = OTLAlertModel(title: "Camera", id: 0)
        let gellary = OTLAlertModel(title: "Gellary", id: 1)
        let cancel = OTLAlertModel(title: "Cancel", id: 2)
        
        showAlert(message: "Media Type", buttons: [camera, gellary, cancel])
    }
    @IBAction private func click_btnSendMessage() {
        if self.txtMessage.text?.count ?? 0 > 0 {
            showLoader()
            vmObject.sendMessage(relationId : "\(relationID)", sender: "\(userObj?.id)", receiver: "\(authUser?.user?.id)", message: self.txtMessage.text ?? "") { [self] result in
                hideLoader()
                if result.status {
                    self.txtMessage.text = ""
                    print("Message sent Successfully")
                }
            }
        }
    }
    
}
extension ChatVC: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vmObject.arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
//                let modelStat:MChatObject =  decodeResponseDataToModel(type: MChatObject.self, responseObj: data as Any)!
                
//                if modelStat.action_type == "chat" {
//                    let chat: Chat = .init(url: modelStat.file_url, message: modelStat.message, userID: modelStat.senderId, id: modelStat.module_id, pName: "", time: modelStat.msg_time, type: modelStat.msg_type, v_thumbnail_url: modelStat.thumbnail_presignedUrl, user_role: modelStat.user_role, jersey_number: modelStat.jersey_number)
//
//                    self.arrData.append(chat)
                    DispatchQueue.main.async {
                        if self.arrData.count > 0 {
                            self.tblList.reloadData {
                                self.tblList.scrollToBottom()
                            }
                        }
                        
                    }
//                }
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
        //ls.message.44080_ls.private.18659
    }
    
    func decodeResponseDataToModel<T:Codable>(type:T.Type,responseObj:Any) -> T? {
        let jsonDecoder = JSONDecoder()
        var model:T
        do {
            let data = try JSONSerialization.data(withJSONObject: responseObj, options: [])
            model = try jsonDecoder.decode(type, from: data)
            return model
        }
        catch {
            print(error.localizedDescription)
        }
        return nil
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
