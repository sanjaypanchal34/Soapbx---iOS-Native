//
//  YouInterestedVC.swift
//  SoapBx
//
//  Created by Mac on 08/07/23.
//

import UIKit
import OTLContaner

enum ScreenType {
    case fromSignup, fromSetting
}

class YouInterestedVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var collInterested: UICollectionView!
    @IBOutlet private weak var btnNext: UIButton!
    
    private var arrTemp = ["Item 1", "Item 2", "Item 3"]
    private var arrSelectTemp: [String] = []
    var screenType = ScreenType.fromSignup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    //MARK: - Setup view
    private func setupUI() {
        viewHeader.btnBack.isHidden = screenType == .fromSignup
        
        lblTitle.setTheme(screenType == .fromSignup ? "What are you interested in?" : "",
                          font: .bold,
                          size: 40)
        collInterested.register(["YouInterestedItemCell"], delegate: self, dataSource: self)
        collInterested.delegate = self
        collInterested.dataSource = self
        
        btnNext.appButton(screenType == .fromSignup ? "Next" : "Update")
        collInterested.reloadData()
    }
    
    //Actions
    @IBAction private func click_btnNext() {
        if screenType == .fromSignup {
            let vc = SubscribeVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
extension YouInterestedVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTemp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YouInterestedItemCell", for: indexPath) as? YouInterestedItemCell {
            cell.setData(arrTemp[indexPath.row],isSelcted: arrSelectTemp.contains(arrTemp[indexPath.row]))
            return cell
        }
        return UICollectionViewCell()
    }
    
}
extension YouInterestedVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if arrSelectTemp.contains(arrTemp[indexPath.row]) {
            arrSelectTemp = arrSelectTemp.filter { str in
                if str != arrTemp[indexPath.row] {
                    return true
                }
                return false
            }
        } else {
            arrSelectTemp.append(arrTemp[indexPath.row])
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
        let width = (Int(collectionView.frame.width) / 3) - 10
        return CGSize(width: width, height: width + 30)
    }
}
