//
//  HomeItemCell.swift
//  SoapBx
//
//  Created by Mac on 09/07/23.
//

import UIKit
import OTLContaner

protocol HomeItemCellDelegate {
    func homeItemCell(_ cell: HomeItemCell, didSelectProfile: Void)
    func homeItemCell(_ cell: HomeItemCell, didSelectComment: Void)
    func homeItemCell(_ cell: HomeItemCell, willOpenDotMenu: Bool)
    func homeItemCell(_ cell: HomeItemCell, didSelectDotMenu: ThreeDotItemModel)
}

class HomeItemCell: AppTableViewCell {

    @IBOutlet private weak var btnProfileActio: UIControl!
    @IBOutlet private weak var imgProfile: UIImageView!
    
    @IBOutlet private weak var lblProfileName: UILabel!
    @IBOutlet private weak var lblPostLocation: UILabel!
    @IBOutlet private weak var lblPostTime: UILabel!
    
    @IBOutlet private weak var btnSave: OTLPTButton!
    @IBOutlet private weak var btnDotMenu: OTLImageButton!
    
    @IBOutlet private weak var lblPostTitle: UILabel!
    @IBOutlet private weak var lblPostDescription: UILabel!
    @IBOutlet private weak var collectionPostImage: UICollectionView!
    @IBOutlet private weak var collectionSoapbx: UICollectionView!
    @IBOutlet private weak var collectionPolitician: UICollectionView!
    
    @IBOutlet private weak var viewActionButtons: UIView!
    @IBOutlet private weak var btnLike: OTLPTButton!
    @IBOutlet private weak var btnDislike: OTLPTButton!
    @IBOutlet private weak var btnComment: OTLPTButton!
    
    //private
    private var dotMenuView: ThreeDotMenuView?
    private var arrSoapbxTrends = ["Think Talk", "Circular Economy", "Global Affairs"]
    private var arrPolitician = ["Roger Wicker", "Narendra Modi", "Putin"]
    private var delegate:HomeItemCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    private func setupUI(){
        viewMain.layer.cornerRadius = 10
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        lblProfileName.setTheme("Soapbx Admin", size: 18)
        lblPostLocation.setTheme("San Jose. CA. USA",size: 12)
        lblPostTime.setTheme("Apr 11 2023 @ 10:13 PM", size: 12)
        
        btnSave.title?.setTheme("0", size: 14)
        btnSave.imageView?.image = UIImage(named: "ic_save")
        
        
        btnDotMenu.image = UIImage(named:"ic_dots")
        
        lblPostTitle.setTheme("Groundwater Gold Rush", color: .primaryBlue, font: .semibold)
        lblPostDescription.setTheme("Banks, pension funds and insurers have been turning California's scarce water into enormous profits, leaving people with less to drink. https://www.bloomberg.com/graphics/2023-wall-street -speeds-california-groundwater-depletion/?srnd=premium #xi4v7vzkg", size: 14)
        
        collectionPostImage.register(["PostImageItemCell"], delegate: self, dataSource: self)
        collectionSoapbx.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        collectionPolitician.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        
        viewActionButtons.layer.cornerRadius = viewActionButtons.frame.height/2
        viewActionButtons.layer.borderWidth = 0.5
        viewActionButtons.layer.borderColor = UIColor.titleGrey.cgColor
        btnLike.title?.setTheme("0", size: 14)
        btnLike.imageView?.image = UIImage(named: "ic_like_grey")
        
        btnDislike.title?.setTheme("0", size: 14)
        btnDislike.imageView?.image = UIImage(named: "ic_dislike_grey")
        
        btnComment.title?.setTheme("0", size: 14)
        btnComment.imageView?.image = UIImage(named: "ic_comments_grey")
                
    }

    func setData(delegate:HomeItemCellDelegate){
        self.delegate = delegate
        DispatchQueue.main.async {
            self.collectionPostImage.reloadData()
        }
    }
    
    //Actions
    @IBAction private func click_btnProfileActio() {
        delegate?.homeItemCell(self, didSelectProfile: Void())
    }
    
    @IBAction private func click_btnComment() {
        delegate?.homeItemCell(self, didSelectComment: Void())
    }
    
    @IBAction private func click_threeDotMenu() {
        self.delegate?.homeItemCell(self, willOpenDotMenu: true)
        dotMenuView = viewMain.showThreeDotMenu(array: [
            ThreeDotItemModel(title: .openProfile, icon: "ic_unfollow"),
            ThreeDotItemModel(title: .hidePost("Robert Watson"), icon: "ic_hidePost"),
            ThreeDotItemModel(title: .share, icon: "ic_share"),
            ThreeDotItemModel(title: .report, icon: "ic_info"),
            ThreeDotItemModel(title: .edit, icon: "ic_edit"),
            ThreeDotItemModel(title: .delete, icon: "delete"),
                                         ])
        { obj in
            self.delegate?.homeItemCell(self, didSelectDotMenu: obj)
        }
    }
    
    public func hideThreeDotMenu(){
        dotMenuView?.hideSelf()
    }
}

extension HomeItemCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionPostImage {
            return 3
        } else if collectionView == collectionPolitician {
            return arrPolitician.count
        } else {
            return arrSoapbxTrends.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionPostImage,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageItemCell", for: indexPath) as? PostImageItemCell {
            cell.setData(indexPath.row)
            return cell
        }
        else if collectionView == collectionSoapbx,
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell {
            cell.setDataSoapbx(arrSoapbxTrends[indexPath.row])
                return cell
            }
        else if collectionView == collectionPolitician,
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell {
            cell.setDataPolitician(arrPolitician[indexPath.row])
                return cell
            }
        return UICollectionViewCell()
    }
    
}
extension HomeItemCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionPostImage {
            return CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.width - 20)
        } else {
            let text = collectionView == collectionSoapbx ? arrSoapbxTrends[indexPath.row] : arrPolitician[indexPath.row]
            let width = text.size(OfFont: AppFont.regular.font(size: 14)).width
            return CGSize(width: width + 20, height: collectionView.frame.height - 10)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
