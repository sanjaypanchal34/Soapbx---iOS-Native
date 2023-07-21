//
//  CreatePostVC.swift
//  SoapBx
//
//  Created by Mac on 16/07/23.
//

import UIKit
import OTLContaner

enum CreatePostScreenType {
    case createPost, editPost
}

class CreatePostVC: UIViewController {

    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    
    @IBOutlet private weak var imgProfile: UIImageView!
    @IBOutlet private weak var lblProfileName: UILabel!
    @IBOutlet private weak var lblLocation: UILabel!
    @IBOutlet private weak var lblTime: UILabel!
    
    @IBOutlet private weak var viewTitle: UIView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var txtTitle: UITextField!
    
    @IBOutlet private weak var viewDescription: UIView!
    @IBOutlet private weak var lblDescription: UILabel!
    @IBOutlet private weak var lblDescriptionPlaceholder: UILabel!
    @IBOutlet private weak var txtDescription: UITextView!
    
    @IBOutlet private weak var viewImage: UIView!
    @IBOutlet private weak var lblImage: UILabel!
    @IBOutlet private weak var collImage: UICollectionView!
    
    @IBOutlet private weak var viewPolitician: UIView!
    @IBOutlet private weak var lblPolitician: UILabel!
    @IBOutlet private weak var collPolitician: UICollectionView!
    @IBOutlet private weak var constCollPolitician: NSLayoutConstraint!
    
    @IBOutlet private weak var viewSoapbxTrends: UIView!
    @IBOutlet private weak var lblSoapbxTrends: UILabel!
    @IBOutlet private weak var collSoapbxTrends: UICollectionView!
    @IBOutlet private weak var constCollSoapbxTrends: NSLayoutConstraint!
    
    @IBOutlet private weak var btnPost: OTLTextButton!
    
    // private
    private var arrSoapbxTrends = [ "Add Politician +", "Think Talk", "Circular Economy", "Global Affairs"]
    private var arrPolitician = ["Add Trends +","Roger Wicker", "Narendra Modi", "Putin"]
    private var arrImage = ["ic_add", "profileOne"]
    
    // public
    var screenType = CreatePostScreenType.createPost
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        collPolitician.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        collSoapbxTrends.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        collPolitician.removeObserver(self, forKeyPath: "contentSize")
        collSoapbxTrends.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let object = object as? UICollectionView{
                if object == collPolitician {
                    if let newvalue = change?[.newKey], let newsize  = newvalue as? CGSize{
                        if constCollPolitician != nil {
                            constCollPolitician?.constant = newsize.height
                        }
                    }
                } else if  object == collSoapbxTrends{
                    if let newvalue = change?[.newKey], let newsize  = newvalue as? CGSize{
                        if constCollSoapbxTrends != nil {
                            constCollSoapbxTrends?.constant = newsize.height
                        }
                    }
                }
            }
        }
    }
    
    private func setupUI() {
        viewHeader.lblTitle.setHeader(screenType == .editPost ? "Edit Post" : "Create Post")
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.image = UIImage(named: "profile_Three")
        imgProfile.contentMode = .scaleAspectFill
        lblProfileName.setTheme("Robert Watson")
        lblLocation.setTheme("Ahmedabad, Gujarat, India",size: 12)
        lblTime.setTheme("Jul 16 2023 @ 09:02 PM",size: 12)
        
        lblTitle.setTheme("Add Title", color: .primaryBlue, font: .bold)
        txtTitle.placeholder = "What is your post aboit?"
        txtTitle.font = AppFont.regular.font(size: 18)
        
        lblDescription.setTheme("Add Description", color: .primaryBlue, font: .bold)
        lblDescriptionPlaceholder.setTheme("What is on your mind?", color: .titleGrey, size: 18)
        txtDescription.font = AppFont.regular.font(size: 18)
        txtDescription.delegate = self
        
        lblImage.setTheme("Add Image", color: .primaryBlue, font: .bold)
        collImage.register(["PostImageItemCell"], delegate: self, dataSource: self)
        
        
        lblPolitician.setTheme("Politician Involved", color: .primaryBlue, font: .bold)
        collPolitician.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        collPolitician.collectionViewLayout = createLeftAlignedLayout()
        
        lblSoapbxTrends.setTheme("Soapbx trends", color: .primaryBlue, font: .bold)
        collSoapbxTrends.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        collSoapbxTrends.collectionViewLayout = createLeftAlignedLayout()
        
        for view in [viewTitle, viewDescription, viewImage] {
            view?.backgroundColor = .white
            view?.layer.cornerRadius = 10
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.lightGrey.cgColor
        }
        
        btnPost.appButton(screenType == .editPost ? "Update" : "Post")
    }
    
    private func createLeftAlignedLayout() -> UICollectionViewLayout {
      let item = NSCollectionLayoutItem(          // this is your cell
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .estimated(70),         // variable width
          heightDimension: .absolute(40)          // fixed height
        )
      )
      
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: .init(
          widthDimension: .fractionalWidth(1.0),  // 100% width as inset by its Section
          heightDimension: .estimated(50)         // variable height; allows for multiple rows of items
        ),
        subitems: [item]
      )
      group.contentInsets = .init(top: 5, leading: 0, bottom: 5, trailing: 0)
      group.interItemSpacing = .fixed(10)         // horizontal spacing between cells
        group.edgeSpacing = .init(leading: .fixed(0), top: .fixed(2), trailing: .fixed(0), bottom: .fixed(2))
      return UICollectionViewCompositionalLayout(section: .init(group: group))
    }
}
extension CreatePostVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collImage {
            return CGSize(width: collectionView.frame.height - 10, height: collectionView.frame.height - 10)
        } else {
            let text = collectionView == collPolitician ? arrPolitician[indexPath.row] : arrSoapbxTrends[indexPath.row]
            let width = text.size(OfFont: AppFont.regular.font(size: 14)).width
            return CGSize(width: width + 20, height: collectionView.frame.height)
        }
        
    }
}
extension CreatePostVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collImage {
            return arrImage.count
        }
        else if collectionView == collPolitician {
            return arrPolitician.count
        }
        else {
            return arrSoapbxTrends.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collImage,
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageItemCell", for: indexPath) as? PostImageItemCell{
            if indexPath.row == 0 {
                cell.setDataCreatePostImageAddImage()
            } else {
                cell.setDataCreatePostImage(arrImage[indexPath.row])
            }
            return cell
        }
        else if collectionView == collPolitician,
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell{
            cell.setCreatePost(arrPolitician[indexPath.row])
            return cell
        }
        else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell{
            cell.setCreatePost(arrSoapbxTrends[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}
extension CreatePostVC : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count > 0 {
            lblDescriptionPlaceholder.isHidden = true
        } else {
            lblDescriptionPlaceholder.isHidden = false
        }
        return true
    }
}
