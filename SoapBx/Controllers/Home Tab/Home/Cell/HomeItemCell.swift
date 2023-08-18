    //
    //  HomeItemCell.swift
    //  SoapBx
    //
    //  Created by Mac on 09/07/23.
    //

import UIKit
import OTLContaner

protocol HomeItemCellDelegate {
    func homeItemCell(_ cell: HomeItemCell, didSelect object: PostModel?)
    func homeItemCell(_ cell: HomeItemCell, didSelectProfile object: PostModel?)
    func homeItemCell(_ cell: HomeItemCell, didSelectSave object: PostModel?)
    func homeItemCell(_ cell: HomeItemCell, didSelectLike object: PostModel?)
    func homeItemCell(_ cell: HomeItemCell, didSelectDislike object: PostModel?)
    func homeItemCell(_ cell: HomeItemCell, didSelectComment object: PostModel?)
    func homeItemCell(_ cell: HomeItemCell, willOpenDotMenu object: PostModel?)
    func homeItemCell(_ cell: HomeItemCell, didSelectDotMenu: ThreeDotItemModel,  object: PostModel?)
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
    @IBOutlet private weak var txtPostDescription: UITextView!
    @IBOutlet private weak var collectionPostImage: UICollectionView!
    @IBOutlet private weak var pageCounter: UIPageControl!
    @IBOutlet private weak var collectionSoapbx: UICollectionView!
    @IBOutlet private weak var collectionPolitician: UICollectionView!
    
    @IBOutlet private weak var viewActionButtons: UIView!
    @IBOutlet private weak var btnLike: OTLPTButton!
    @IBOutlet private weak var btnDislike: OTLPTButton!
    @IBOutlet private weak var btnComment: OTLPTButton!
    
        //private
    private var object: PostModel?
    private var dotMenuView: ThreeDotMenuView?
    private var delegate:HomeItemCellDelegate?
    private var currentPage = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    private func setupUI(){
        viewMain.layer.cornerRadius = 10
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        lblProfileName.setTheme("", size: 18)
        lblPostLocation.setTheme("",size: 12)
        lblPostTime.setTheme("", size: 12)
        
        btnSave.title?.setTheme("0", size: 14)
        btnSave.imageView?.image = UIImage(named: "ic_save")
        
        
        btnDotMenu.image = UIImage(named:"ic_dots")
        
        lblPostTitle.setTheme("", color: .primaryBlue, font: .semibold, lines: 5)
        txtPostDescription.text = ""
        txtPostDescription.font = AppFont.regular.font(size: 14)
            //        txtPostDescription.translatesAutoresizingMaskIntoConstraints = true
        txtPostDescription.sizeToFit()
        txtPostDescription.isScrollEnabled = false
        txtPostDescription.isEditable = false
        txtPostDescription.isSelectable = true
        txtPostDescription.dataDetectorTypes = .all
        txtPostDescription.linkTextAttributes = [.foregroundColor:UIColor.primaryBlue]
        txtPostDescription.delegate = self
        
        let snappingLayout = SnappingLayout()
        snappingLayout.snapPosition = .center
        snappingLayout.scrollDirection = .horizontal
        collectionPostImage.collectionViewLayout = snappingLayout
        collectionPostImage.isPagingEnabled = true
        collectionPostImage.decelerationRate = .normal
        collectionPostImage.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        collectionPostImage.register(["PostImageItemCell"], delegate: self, dataSource: self)
        let layout1 = OTLTagFlowLayout()
        layout1.spacing = 0
        layout1.padding = 0
        layout1.minimumLineSpacing = 0
        layout1.scrollDirection = .horizontal
        layout1.minimumInteritemSpacing = 0
        layout1.estimatedItemSize = CGSize(width: 140, height: 30)
        collectionSoapbx.collectionViewLayout = layout1
        collectionSoapbx.isScrollEnabled = false
        collectionSoapbx.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        let layout2 = OTLTagFlowLayout()
        layout2.spacing = 0
        layout2.padding = 0
        layout2.scrollDirection = .horizontal
        layout2.minimumLineSpacing = 0
        layout2.minimumInteritemSpacing = 0
        layout2.estimatedItemSize = CGSize(width: 140, height: 30)
        collectionPolitician.collectionViewLayout = layout2
        collectionPolitician.isScrollEnabled = false
        collectionPolitician.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        
        pageCounter.pageIndicatorTintColor = .titleGray
        pageCounter.currentPageIndicatorTintColor = .primaryBlue
        pageCounter.currentPage = 0
        pageCounter.numberOfPages = 0
        
        viewActionButtons.layer.cornerRadius = viewActionButtons.frame.height/2
        viewActionButtons.layer.borderWidth = 0.5
        viewActionButtons.layer.borderColor = UIColor.titleGray.cgColor
        btnLike.title?.setTheme("0", size: 14)
        btnLike.imageView?.image = UIImage(named: "ic_like_grey")?.withRenderingMode(.alwaysTemplate)
        
        btnDislike.title?.setTheme("0", size: 14)
        btnDislike.imageView?.image = UIImage(named: "ic_dislike_grey")?.withRenderingMode(.alwaysTemplate)
        
        btnComment.title?.setTheme("0", size: 14)
        btnComment.imageView?.image = UIImage(named: "ic_comments_grey")
        
    }
    
    func setData(_ object: PostModel, indexPath: IndexPath, delegate:HomeItemCellDelegate, isDotOptionsVisible: Bool = false, screenType: TradPostListViewType){
        self.object = object
        self.indexPath = indexPath
        self.delegate = delegate
        self.updateData(object)
        if isDotOptionsVisible  {
            click_threeDotMenu()
        } else {
            dotMenuView?.hideSelf()
        }
//        if screenType == .fromProfile, object.user?.id == authUser?.user?.id {
//            btnDotMenu.isHidden = true
//        } else {
//            btnDotMenu.isHidden = false
//        }
    }
    
    func updateData(_ object: PostModel){
        self.object = object
        self.indexPath = indexPath
        imgProfile.setImage(object.user?.profilePhotoURL)
        lblProfileName.text = object.user?.name
        lblPostLocation.text = getValueOrDefult(object.user?.location, defaultValue: "N/A")
        lblPostTime.text = OTLDateConvert.instance.convert(date: object.createdAt ?? "", set: .yyyyMMdd_T_HHmmssZ, getFormat: .mmmDDyyyyAthhmma)
        
        btnSave.title?.text = "\(object.savedsCount ?? 0)"
        btnSave.imageView?.image = object.saveStatus == 1 ? UIImage(named: "ic_redSave") : UIImage(named: "ic_save")
        
        lblPostTitle.text = object.title
        txtPostDescription.text = object.description
        
        pageCounter.isHidden = !((object.images?.count ?? 0) > 1)
        
        if (object.images?.count ?? 0) > 0 {
            collectionPostImage.isHidden = false
            self.collectionPostImage.reloadData()
            pageCounter.numberOfPages = object.images?.count ?? 0
        } else {
            collectionPostImage.isHidden = true
        }
        
        if (object.trendTags?.count ?? 0) > 0 {
            collectionSoapbx.isHidden = false
            self.collectionSoapbx.reloadData()
        } else {
            collectionSoapbx.isHidden = true
        }
        
        if (object.politicianTags?.count ?? 0) > 0 {
            collectionPolitician.isHidden = false
            self.collectionPolitician.reloadData()
        } else {
            collectionPolitician.isHidden = true
        }
        
        btnLike.title?.text = "\(object.likeCount ?? 0)"
        btnLike.imageView?.tintColor = object.likeStatus == 1 ? .primaryBlue : .titleGray
        btnDislike.title?.text = "\(object.dislikeCount ?? 0)"
        btnDislike.imageView?.tintColor = object.dislikeStatus == 1 ? .primaryBlue : .titleGray
        btnComment.title?.text = "\(object.commentsCount ?? 0)"
    }
    
        //Actions
    @IBAction private func click_btnProfileActio() {
        if authUser?.loginType == .userLogin {
            if authUser?.user?.id != object?.user?.id {
                delegate?.homeItemCell(self, didSelectProfile: object)
            }
        } else {
            showAlert(message: "You must Login to access this feature",buttons: ["Cancel", "Login"]) { alert in
                if alert.title == "Login" {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    
    @IBAction private func click_btnSave() {
        if authUser?.loginType == .userLogin {
            delegate?.homeItemCell(self, didSelectSave: object)
        } else {
            showAlert(message: "You must Login to access this feature",buttons: ["Cancel", "Login"]) { alert in
                if alert.title == "Login" {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    
    @IBAction private func click_btnLike() {
        if authUser?.loginType == .userLogin {
            delegate?.homeItemCell(self, didSelectLike: object)
        } else {
            showAlert(message: "You must Login to access this feature",buttons: ["Cancel", "Login"]) { alert in
                if alert.title == "Login" {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    
    @IBAction private func click_btnDislike() {
        if authUser?.loginType == .userLogin {
            delegate?.homeItemCell(self, didSelectDislike: object)
        } else {
            showAlert(message: "You must Login to access this feature",buttons: ["Cancel", "Login"]) { alert in
                if alert.title == "Login" {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    
    @IBAction private func click_btnComment() {
//        if authUser?.loginType == .userLogin {
            delegate?.homeItemCell(self, didSelectComment: object)
//        } else {
//            showAlert(message: "You must Login to access this feature",buttons: ["Cancel", "Login"]) { alert in
//                if alert.title == "Login" {
//                    mackRootView(LoginVC())
//                }
//            }
//        }
    }
    
    @IBAction private func click_threeDotMenu() {
        if authUser?.loginType == .userLogin {
            self.delegate?.homeItemCell(self, willOpenDotMenu: object)
            
            var dotMenuItem = [
                ThreeDotItemModel(title: .openProfile, icon: "ic_unfollow"),
                ThreeDotItemModel(title: .hidePost(object?.user?.name ?? ""), icon: "ic_hidePost"),
                ThreeDotItemModel(title: .share, icon: "ic_share"),
                ThreeDotItemModel(title: .report, icon: "ic_info"),
            ]
            
            if object?.user?.id == authUser?.user?.id {
                dotMenuItem = [
                    ThreeDotItemModel(title: .edit, icon: "ic_edit"),
                    ThreeDotItemModel(title: .delete, icon: "delete"),
                ]
            }
            
            dotMenuView = viewMain.showThreeDotMenu(array: dotMenuItem)
            { obj in
                self.delegate?.homeItemCell(self, didSelectDotMenu: obj, object: self.object)
            }
        } else {
            showAlert(message: "You must Login to access this feature",buttons: ["Cancel", "Login"]) { alert in
                if alert.title == "Login" {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    
    public func hideThreeDotMenu(){
        dotMenuView?.hideSelf()
    }
    
    func updateCellsLayout()  {
        
        let centerX = collectionPostImage.contentOffset.x + (collectionPostImage.frame.size.width - 10)/2
        for cell in collectionPostImage.visibleCells {
            
            var offsetX = centerX - cell.center.x
            if offsetX < 0 {
                offsetX *= -1
            }
            cell.transform = CGAffineTransform.identity
            let offsetPercentage = offsetX / (self.bounds.width * 2.9)
            let scaleX = 1-offsetPercentage
            cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
        }
    }
    
}

extension HomeItemCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCellsLayout()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionPostImage {
            let x = Int(scrollView.contentOffset.x) + 20 + (10*(object?.images?.count ?? 0))
            let w = Int(scrollView.bounds.size.width)
            pageCounter.currentPage = Int(x/w)
        }
    }
}
extension HomeItemCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionPostImage {
            return object?.images?.count ?? 0
        } else if collectionView == collectionPolitician {
            return object?.politicianTags?.count ?? 0
        } else {
            return object?.trendTags?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionPostImage,
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageItemCell", for: indexPath) as? PostImageItemCell {
            if (object?.images?.count ?? 0) > 0 , let obj = object?.images?[indexPath.row] {
                cell.setData(obj, indexPath: indexPath)
                return cell
            }
        }
        else if collectionView == collectionSoapbx,
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell {
            if let obj = object?.trendTags?[indexPath.row] {
                cell.setDataSoapbx(obj)
                return cell
            }
            
        }
        else if collectionView == collectionPolitician,
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell {
            if let obj = object?.politicianTags?[indexPath.row] {
                cell.setDataPolitician(obj)
                return cell
            }
            
            
        }
        return UICollectionViewCell()
    }
    
}
extension HomeItemCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.homeItemCell(self, didSelect: object)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionPostImage {
                return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
        }
        else if collectionView == collectionSoapbx,
                (object?.trendTags?.count ?? 0) > 0{
            let text = object?.trendTags?[indexPath.row].trend?.name ?? ""
            let width = text.size(OfFont: AppFont.regular.font(size: 10)).width + 20
            if width < 55 {
                return CGSize(width: 55, height: 30)
            }
            else {
                return CGSize(width: width, height: 30)
            }
        }else if collectionView == collectionPolitician,
                 (object?.politicianTags?.count ?? 0) > 0{
            let text = object?.politicianTags?[indexPath.row].politician?.name ?? ""
            let width = text.size(OfFont: AppFont.regular.font(size: 10)).width + 20
            if width < 55 {
                return CGSize(width: 55, height: 30)
            }
            else {
                return CGSize(width: width, height: 30)
            }
        }
        
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
extension HomeItemCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        printLog("[HomeItemCell] shouldInteractWith")
        return false
    }
}
