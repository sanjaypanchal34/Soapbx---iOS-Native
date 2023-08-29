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
    func homeItemCell(_ cell: HomeItemCell, didSelectShare object: PostModel?)
    func homeItemCell(_ cell: HomeItemCell, willOpenDotMenu object: PostModel?)
    func homeItemCell(_ cell: HomeItemCell, didSelectDotMenu: ThreeDotItemModel,  object: PostModel?)
    func homeItemCell(_ cell:HomeItemCell, didUpdateTable: Void)
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
    @IBOutlet private weak var constCollSoapbxTrends: NSLayoutConstraint!
    @IBOutlet private weak var collectionPolitician: UICollectionView!
    @IBOutlet private weak var constCollPolitician: NSLayoutConstraint!
    
    @IBOutlet private weak var lblPTitle: UILabel!
    @IBOutlet private weak var lblPDesc: UILabel!
    @IBOutlet private weak var btnDate: UIButton!
    
    @IBOutlet private weak var viewPostImage: UIView!
    @IBOutlet private weak var viewPostDetails: UIView!
    @IBOutlet private weak var stackViewDetail: UIStackView!
    @IBOutlet private weak var viewActionButtons: UIView!
    @IBOutlet private weak var btnLike: OTLPTButton!
    @IBOutlet private weak var btnDislike: OTLPTButton!
    @IBOutlet private weak var btnComment: OTLPTButton!
    @IBOutlet private weak var btnShare: OTLPTButton!
    
        //private
    private var object: PostModel?
    private var dotMenuView: ThreeDotMenuView?
    private var delegate:HomeItemCellDelegate?
    private var currentPage = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    func addCellObserver() {
        collectionPolitician.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        collectionSoapbx.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    func removeCellObserver() {
        if collectionPolitician.observationInfo != nil {
            collectionPolitician.removeObserver(self, forKeyPath: "contentSize")
        }
        if collectionSoapbx.observationInfo != nil {
            collectionSoapbx.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let object = object as? UICollectionView{
                if object == collectionPolitician {
                    if let newvalue = change?[.newKey], let newsize  = newvalue as? CGSize{
                        if constCollPolitician != nil {
                                constCollPolitician?.constant = newsize.height
                            delegate?.homeItemCell(self, didUpdateTable: Void())
                            collectionPolitician.updateFocusIfNeeded()
                            collectionPolitician.layoutIfNeeded()
                        }
                    }
                } else if  object == collectionSoapbx{
                    if let newvalue = change?[.newKey], let newsize  = newvalue as? CGSize{
                        if constCollSoapbxTrends != nil {
                                constCollSoapbxTrends?.constant = newsize.height
                            delegate?.homeItemCell(self, didUpdateTable: Void())
                            collectionSoapbx.updateFocusIfNeeded()
                            collectionSoapbx.layoutIfNeeded()
                        }
                    }
                }
            }
        }
    }
    
    
    private func setupUI(){
        viewMain.layer.cornerRadius = 10
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        lblProfileName.setTheme("", size: 18, lines: 1)
        lblPostLocation.setTheme("",size: 12)
        lblPostTime.setTheme("", size: 12)
        
        btnSave.title?.setTheme("0", size: 14)
        btnSave.imageView?.image = UIImage(named: "ic_save")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        let tapGestureRecognizerShare = UITapGestureRecognizer(target: self, action: #selector(didShareTap(_:)))
        viewPostDetails.addGestureRecognizer(tapGestureRecognizer)
        btnShare.addGestureRecognizer(tapGestureRecognizerShare)
        btnDotMenu.image = UIImage(named:"ic_dots")
        
        lblPostTitle.setTheme("", color: .primaryBlue, font: .semibold, lines: 5)
        lblPTitle.setTheme("", color: .white, font: .regular, size: 14, lines: 2)
        lblPDesc.setTheme("", color: .white, font: .regular, size: 10, lines: 3)
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
        
        let snappingLayout = UICollectionViewFlowLayout()
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
        layout1.scrollDirection = .vertical
        layout1.minimumInteritemSpacing = 0
        layout1.estimatedItemSize = CGSize(width: 140, height: 30)
        collectionSoapbx.collectionViewLayout = layout1
        collectionSoapbx.isScrollEnabled = false
        collectionSoapbx.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        let layout2 = OTLTagFlowLayout()
        layout2.spacing = 0
        layout2.padding = 0
        layout2.scrollDirection = .vertical
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
        
        btnShare.title?.setTheme(LocalStrings.DOT_SHARE.rawValue.addLocalizableString(), size: 14)
        btnShare.imageView?.image = UIImage(named: "ic_share")
        
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
        removeCellObserver()
        addCellObserver()
        self.object = object
        self.indexPath = indexPath
        imgProfile.setImage(object.user?.profilePhotoURL)
        lblProfileName.text = object.user?.name
        lblPostLocation.text = getValueOrDefult(object.user?.location, defaultValue: "N/A")
        lblPostTime.text = OTLDateConvert.instance.convert(date: object.createdAt ?? "", set: .yyyyMMdd_T_HHmmssDotssZ, getFormat: .mmmDDyyyyAthhmma)
        
        btnSave.title?.text = "\(object.savedsCount ?? 0)"
        btnSave.imageView?.image = object.saveStatus == 1 ? UIImage(named: "ic_redSave") : UIImage(named: "ic_save")
        
        lblPostTitle.text = object.title
        txtPostDescription.text = object.description
        
        lblPTitle.text = object.title
        lblPDesc.text = ""
        lblPDesc.sizeToFit()
        lblPDesc.text = object.description
        lblPDesc.sizeToFit()
        let numberOfLines = self.lblPDesc.numberOfVisibleLines
        if numberOfLines > 2 {
            let readmoreFont = UIFont(name: "Helvetica-Oblique", size: 11.0)
            let readmoreFontColor = UIColor.white
                self.lblPDesc.addTrailing(with: "... ", moreText: "read more", moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
        }
          

        
        let dateString = OTLDateConvert.instance.convert(date: object.createdAt ?? "", set: .yyyyMMdd_T_HHmmssDotssZ, getFormat: .mmmDDyyyyAthhmma)
        btnDate.setTitle(dateString, for: .normal)
        
        pageCounter.isHidden = !((object.images?.count ?? 0) > 1)
        
        if (object.images?.count ?? 0) > 0 {
            collectionPostImage.isHidden = false
            viewPostImage.isHidden = false
            stackViewDetail.isHidden = true
            lblPostTime.isHidden = true
            txtPostDescription.isHidden = true
            lblPostTitle.isHidden = true
            self.collectionPostImage.reloadData()
            pageCounter.numberOfPages = object.images?.count ?? 0
        } else {
            collectionPostImage.isHidden = true
            viewPostImage.isHidden = true
            stackViewDetail.isHidden = false
            lblPostTime.isHidden = false
            txtPostDescription.isHidden = false
            lblPostTitle.isHidden = false
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
        btnDislike.imageView?.tintColor = object.dislikeStatus == 1 ? .titleRed : .titleGray
        btnComment.title?.text = "\(object.commentsCount ?? 0)"
        btnShare.title?.text = LocalStrings.DOT_SHARE.rawValue.addLocalizableString()
    }
    
        //Actions
    @IBAction private func click_btnProfileActio() {
//        if authUser?.loginType == .userLogin {
            if authUser?.user?.id != object?.user?.id {
                delegate?.homeItemCell(self, didSelectProfile: object)
            }
//        } else {
//            showAlert(message: "You must Login to access this feature",buttons: ["Cancel", "Login"]) { alert in
//                if alert.title == "Login" {
//                    mackRootView(LoginVC())
//                }
//            }
//        }
    }
    
    @IBAction private func click_btnSave() {
        if authUser?.loginType == .userLogin {
            delegate?.homeItemCell(self, didSelectSave: object)
        } else {
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    
    @IBAction private func click_btnLike() {
        if authUser?.loginType == .userLogin {
            delegate?.homeItemCell(self, didSelectLike: object)
        } else {
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    
    @IBAction private func click_btnDislike() {
        if authUser?.loginType == .userLogin {
            delegate?.homeItemCell(self, didSelectDislike: object)
        } else {
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
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
    
    @objc func didShareTap(_ sender: UITapGestureRecognizer) {
        delegate?.homeItemCell(self, didSelectShare: object)
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        delegate?.homeItemCell(self, didSelect: object)
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
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    
    public func hideThreeDotMenu(){
        dotMenuView?.hideSelf()
    }
    
    func updateCellsLayout()  {
        
        let centerX = collectionPostImage.contentOffset.x + (collectionPostImage.frame.size.width )/2
        for cell in collectionPostImage.visibleCells {
            
            var offsetX = centerX - cell.center.x
            print("\(offsetX) = \(centerX) - \(cell.center.x)")
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

extension UILabel {

    var numberOfVisibleLines: Int {
           let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
           let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
           let charSize: Int = lroundf(Float(self.font.pointSize))
           return rHeight / charSize
       }
    
        func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
            let readMoreText: String = trailingText + moreText

            let lengthForVisibleString: Int = self.vissibleTextLength
            let mutableString: String = self.text!
            let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
            let readMoreLength: Int = (readMoreText.count)
            let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
            let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
            let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
            answerAttributed.append(readMoreAttributed)
            self.attributedText = answerAttributed
        }

        var vissibleTextLength: Int {
            let font: UIFont = self.font
            let mode: NSLineBreakMode = self.lineBreakMode
            let labelWidth: CGFloat = self.frame.size.width
            let labelHeight: CGFloat = self.frame.size.height
            let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

            let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
            let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
            let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

            if boundingRect.size.height > labelHeight {
                var index: Int = 0
                var prev: Int = 0
                let characterSet = CharacterSet.whitespacesAndNewlines
                repeat {
                    prev = index
                    if mode == NSLineBreakMode.byCharWrapping {
                        index += 1
                    } else {
                        index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                    }
                } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
                return prev
            }
            return self.text!.count
        }
    }
