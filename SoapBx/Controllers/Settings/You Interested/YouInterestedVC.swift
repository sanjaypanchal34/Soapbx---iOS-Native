//
//  YouInterestedVC.swift
//  SoapBx
//
//  Created by Mac on 08/07/23.
//

import UIKit
import OTLContaner

enum ScreenType {
    case fromSignup, fromSetting, fromCreatePost
}

protocol YouInterestedDelegate {
    func youInterested(didSelected trends: [TrendsModel])
}

class YouInterestedVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var btnNext: OTLTextButton!
    
    private let vmObject = YouInterestedViewModel()
    private var delegate:YouInterestedDelegate?
    
    var screenType = ScreenType.fromSignup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getTrends()
        // Do any additional setup after loading the view.
    }
    
    func navigateFromCreatePost(_ selected: [TrendsModel], delegate:YouInterestedDelegate) {
        screenType = .fromCreatePost
        self.delegate = delegate
        vmObject.arrSelectedId = selected.compactMap({ element in
            return element.id
        })
    }

    //MARK: - Setup view
    private func setupUI() {
        viewHeader.btnBack.isHidden = screenType == .fromSignup
        
        lblTitle.setTheme(screenType == .fromSignup ? "What are you interested in?" : "",
                          font: .bold,
                          size: 38)
        tblList.register(["YouInterestCell"], delegate: self, dataSource: self)
        
        btnNext.appButton("Next")
        switch screenType {
            case .fromSignup:
                btnNext.text = "Next"
                lblTitle.text = "What are you interested in?"
            case .fromSetting:
                btnNext.text = "Update"
                lblTitle.text = "What are you interested in?"
            case .fromCreatePost:
                btnNext.text = "Done"
                lblTitle.text = "Choose Relevant Trends"
        }
        
        tblList.reloadData()
    }
    
    //Actions
    @IBAction private func click_btnNext() {
        if vmObject.arrSelectedId.count == 0, screenType != .fromCreatePost {
            showToast(message: "Please select atleast one trend")
        } else {
            if screenType == .fromCreatePost {
                let array = vmObject.arrList.compactMap { element in
                    if vmObject.arrSelectedId.contains(element.id ?? 0) {
                        return element
                    }
                    return nil
                }
                delegate?.youInterested(didSelected: array)
                navigationController?.popViewController(animated: true)
            } else {
                updateTrends()
            }
        }
    }
    
    // API CAllS
    
    private func getUserTrends() {
        showLoader()
        vmObject.getUserTrends { result in
            hideLoader()
            if result.status {
                self.tblList.reloadData()
            }
        }
    }
    
    private func getTrends() {
        showLoader()
        vmObject.getTrends { result in
            hideLoader()
            if result.status {
                if self.screenType == .fromSetting {
                    self.getUserTrends()
                } else {
                    self.tblList.reloadData()
                }
            }
        }
    }
    
    private func updateTrends() {
        showLoader()
        vmObject.updateTrends { result in
            hideLoader()
            if result.status {
                if self.screenType == .fromSignup {
                    let vc = SubscribeVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
//                    self.navigationController?.popViewController(animated: true)
                }
            }
            showToast(message: result.message)
        }
    }
}

extension YouInterestedVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vmObject.arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "YouInterestCell") as? YouInterestCell {
            cell.setData(vmObject.arrList[indexPath.row],isSelcted: vmObject.arrSelectedId.contains(vmObject.arrList[indexPath.row].id ?? 0))
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if vmObject.arrSelectedId.contains(vmObject.arrList[indexPath.row].id ?? 0) {
            vmObject.arrSelectedId = vmObject.arrSelectedId.filter { id in
                if id != (vmObject.arrList[indexPath.row].id ?? 0) {
                    return true
                }
                return false
            }
        } else {
            if vmObject.arrSelectedId.count > vmObject.maxSelection {
                showToast(message: "You can choose a maximum of \(vmObject.maxSelection) trends.")
            } else {
                vmObject.arrSelectedId.append(vmObject.arrList[indexPath.row].id ?? 0)
            }
            
        }
        tblList.reloadData()
    }
    
}
