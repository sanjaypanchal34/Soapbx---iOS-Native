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
    @IBOutlet private weak var collInterested: UICollectionView!
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
        collInterested.register(["YouInterestedItemCell"], delegate: self, dataSource: self)
        collInterested.delegate = self
        collInterested.dataSource = self
        
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
        
        collInterested.reloadData()
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
                self.collInterested.reloadData()
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
                    self.collInterested.reloadData()
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
extension YouInterestedVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vmObject.arrList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YouInterestedItemCell", for: indexPath) as? YouInterestedItemCell {
            cell.setData(vmObject.arrList[indexPath.row],isSelcted: vmObject.arrSelectedId.contains(vmObject.arrList[indexPath.row].id ?? 0))
            return cell
        }
        return UICollectionViewCell()
    }
    
}
extension YouInterestedVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
        collectionView.reloadData()
    }
}
extension YouInterestedVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (Int(collectionView.frame.width) / 3) - 20
        return CGSize(width: width, height: width + 30)
    }
}
