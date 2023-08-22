//
//  CreatePostVC.swift
//  SoapBx
//
//  Created by Mac on 16/07/23.
//

import UIKit
import OTLContaner
import Photos

enum CreatePostScreenType {
    case createPost, editPost
}
protocol CreatePostDelegate {
    func createPost(deletePostImages at:IndexPath, with postId: Int, imageId: Int)
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
    private let imagePicker = UIImagePickerController()
    private let vmObject = CreatePostViewModel()
    // public
    private var screenType = CreatePostScreenType.createPost
    private var indexPath = IndexPath()
    private var delegate: CreatePostDelegate?
    
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
    
    func navigateFromEdit(post object: PostModel, indexPath: IndexPath, delegate: CreatePostDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        vmObject.postObj = object
        screenType = .editPost
        vmObject.arrImages = object.images ?? []
        
        let politions = object.politicianTags?.compactMap({ postTag in
            return postTag.politician
        }) ?? []
        
        let trends = object.trendTags?.compactMap({ postTag in
            return postTag.trend
        }) ?? []
        
        vmObject.arrPolitions = politions + [PostUser.object(name: vmObject.addPolitician)!]
        vmObject.arrTrends = trends + [TrendsModel(name: vmObject.addTrends)]
    }
    
    
    private func setupUI() {
        viewHeader.lblTitle.setHeader(screenType == .editPost ? "Edit Post" : "Create Post")
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.setImage(authUser?.user?.profile_photo_url)
        imgProfile.contentMode = .scaleAspectFill
        lblProfileName.setTheme(authUser?.user?.name ?? "")
        lblLocation.setTheme(getValueOrDefult(authUser?.user?.location, defaultValue: "N/A"),size: 10)
        lblTime.setTheme("",size: 12)
        lblTime.text = OTLDateConvert.instance.convert(date: Date(), toString: .mmmDDyyyyAthhmma)
        
        lblTitle.setTheme("Add Title", color: .primaryBlue, font: .bold)
        txtTitle.placeholder = "What is your post aboit?"
        txtTitle.font = AppFont.regular.font(size: 18)
        txtTitle.maxLength = 50
        
        lblDescription.setTheme("Add Description", color: .primaryBlue, font: .bold)
        lblDescriptionPlaceholder.setTheme("What is on your mind?", color: .titleGray, size: 18)
        txtDescription.font = AppFont.regular.font(size: 18)
        txtDescription.delegate = self
        
        lblImage.setTheme("Add Image", color: .primaryBlue, font: .bold)
        collImage.register(["PostImageItemCell"], delegate: self, dataSource: self)
        let layoutForImage = UICollectionViewFlowLayout()
        layoutForImage.scrollDirection = .horizontal
        collImage.collectionViewLayout = layoutForImage
        
        lblPolitician.setTheme("Politician Involved", color: .primaryBlue, font: .bold)
        collPolitician.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        let layout = OTLTagFlowLayout()
        layout.estimatedItemSize = CGSize(width: 140, height: 40)
        collPolitician.collectionViewLayout = layout
//        collPolitician.collectionViewLayout = politicianFlowLayout
        
        lblSoapbxTrends.setTheme("Soapbx trends", color: .primaryBlue, font: .bold)
        collSoapbxTrends.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        let layout1 = OTLTagFlowLayout()
        layout1.estimatedItemSize = CGSize(width: 140, height: 40)
        collSoapbxTrends.collectionViewLayout = layout1
        
        for view in [viewTitle, viewDescription, viewImage] {
            view?.backgroundColor = .white
            view?.layer.cornerRadius = 10
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.lightGrey.cgColor
        }
        
        btnPost.appButton("Post")
        if screenType == .editPost {
            btnPost.text = "Update"
            txtTitle.text = vmObject.postObj?.title
            txtDescription.text = vmObject.postObj?.description
            lblDescriptionPlaceholder.isHidden = (vmObject.postObj?.description?.count ?? 0) > 0
        }
    }
    
    
    //Actins
    @IBAction private func click_post() {
        self.view.endEditing(true)
        if let validateTitle = txtTitle.text?.validateTitle(), validateTitle.status == false {
            showToast(message: validateTitle.message)
        }
        else if let validateLast = txtDescription.text?.validateDescription(), validateLast.status == false {
            showToast(message: validateLast.message)
        }
        else {
            if screenType == .editPost {
                updatePost()
            }
            else {
                createPost()
            }
        }
    }
    
    
    
    private func addImageAlert() {
        PHPhotoLibrary.execute(controller: self, onAccessHasBeenGranted: {
            DispatchQueue.main.async {
                let camera = OTLAlertModel(title: "Camera", id: 0)
                let gallary = OTLAlertModel(title: "Gallary", id: 1)
                let cancel = OTLAlertModel(title: "Cancel", id: 2, style: .destructive)
                
                showAlert(title: "Media Type", message: "", buttons: [camera, gallary, cancel]) { alert in
                    if alert.id == 0 {
                        self.openCamera()
                    } else if alert.id == 1 {
                        self.openGallary()
                    }
                }
            }
        })
    }
    
        //MARK:-
    private func openCamera()  {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.modalTransitionStyle = .coverVertical
            imagePicker.modalPresentationStyle = .overFullScreen
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            openGallary()
        }
    }
    
    private func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.modalTransitionStyle = .coverVertical
        imagePicker.modalPresentationStyle = .overFullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
  
    
    //API calls
    private func createPost() {
        showLoader()
        vmObject.addPost(title: txtTitle.text ?? "", description: txtDescription.text ?? "" ) { result in
            hideLoader()
            if result.status {
                mackRootView(HomeVC())
            }
            showToast(message: result.message)
        }
    }
    
    private func updatePost() {
        var lblProgress: UILabel?
        showLoader()
        vmObject.updatePost(title: txtTitle.text ?? "", description: txtDescription.text ?? "" ) { result in
            showToast(message: result.message)
            if result.status {
                NotificationCenter.default.post(name: .homePostUpdate, object: nil)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            hideLoader()
        }
    }
    
    private func deleteImage(image id: Int) {
        showLoader()
        vmObject.deleteImage(image: id) { result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                self.delegate?.createPost(deletePostImages: self.indexPath, with: self.vmObject.postObj?.id ?? 0, imageId: id)
                self.collImage.reloadData()
            }
        }
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
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collImage {
            return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
        } else  if collectionView == collSoapbxTrends,
                   vmObject.arrTrends.count > 0{
            let text = vmObject.arrTrends[indexPath.row].name ?? ""
            let width = text.size(OfFont: AppFont.regular.font(size: 16)).width + 20
            if width < 55 {
                return CGSize(width: 55, height: 35)
            }
            else {
                return CGSize(width: width, height: 35)
            }
        }else if collectionView == collPolitician,
                 vmObject.arrPolitions.count > 0{
            let text = vmObject.arrPolitions[indexPath.row].name ?? ""
            let width = text.size(OfFont: AppFont.regular.font(size: 16)).width + 20
            if width < 55 {
                return CGSize(width: 55, height: 35)
            }
            else {
                return CGSize(width: width, height: 35)
            }
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collImage {
            if vmObject.arrImages.count < vmObject.maxImage {
                if indexPath.row == vmObject.arrImages.count{
                    addImageAlert()
                }
            }
        }
        else if collectionView == collPolitician,
                vmObject.arrPolitions[indexPath.row].name == vmObject.addPolitician
        {
            let vc = SearchVC()
            vc.navigateFromCreatePost(selected: vmObject.arrPolitions, delegate: self)
            navigationController?.pushViewController(vc, animated: true)
        }
        else if collectionView == collSoapbxTrends,
                    vmObject.arrTrends[indexPath.row].name == vmObject.addTrends{
            let vc = YouInterestedVC()
            vc.navigateFromCreatePost(vmObject.arrTrends, delegate: self)
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
extension CreatePostVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collImage {
            if vmObject.arrImages.count < vmObject.maxImage {
                return vmObject.arrImages.count + 1
            }
            else {
                return vmObject.arrImages.count
            }
        }
        else if collectionView == collPolitician {
            return vmObject.arrPolitions.count
        }
        else {
            return vmObject.arrTrends.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collImage,
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageItemCell", for: indexPath) as? PostImageItemCell{
            cell.clipsToBounds = false
            if vmObject.arrImages.count < vmObject.maxImage {
                if indexPath.row < vmObject.arrImages.count{
                    cell.setDataCreatePostImage(vmObject.arrImages[indexPath.row], indexPath: indexPath, delegate: self)
                } else {
                    cell.setDataCreatePostImageAddImage()
                }
            } else {
                cell.setDataCreatePostImage(vmObject.arrImages[indexPath.row], indexPath: indexPath, delegate: self)
            }
           
            return cell
        }
        else if collectionView == collPolitician,
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell{
            cell.setCreatePostPolitician(vmObject.arrPolitions[indexPath.row])
            return cell
        }
        else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell{
            cell.setCreatePostTreds(vmObject.arrTrends[indexPath.row])
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
extension CreatePostVC : SearchDelegate, YouInterestedDelegate {
    func search(selectedUserForCreatePost users: [PostUser]) {
        vmObject.arrPolitions = users + [PostUser.object(name: vmObject.addPolitician)!]
        collPolitician.reloadData()
    }
    
    func youInterested(didSelected trends: [TrendsModel]) {
        vmObject.arrTrends = trends + [TrendsModel(name: vmObject.addTrends)]
        collSoapbxTrends.reloadData()
    }
}
extension CreatePostVC:  UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let pickedImage = info[.editedImage] as? UIImage {
            vmObject.arrImages.append(PostImage(image: pickedImage))
        } else if let pickedImage = info[.originalImage] as? UIImage {
            vmObject.arrImages.append(PostImage(image: pickedImage))
        }
        dismiss(animated: true, completion: {
            DispatchQueue.main.async {
                self.collImage.reloadData()
            }
        })
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
extension CreatePostVC: PostImageItemDelegate {
    func postImageItem(_ cell: PostImageItemCell, didSelectDelete: Void) {
        showAlert(message: "Are you sure you want to delete this image?", buttons: ["Yes", "No"]) { alert in
            if alert.title == "Yes" {
                if self.screenType == .editPost {
                    if let id = self.vmObject.arrImages[cell.indexPath.row].id {
                        self.deleteImage(image: id)
                    }
                    self.vmObject.arrImages.remove(at: cell.indexPath.row)
                    self.collImage.reloadData()
                } else {
                    self.vmObject.arrImages.remove(at: cell.indexPath.row)
                    self.collImage.reloadData()
                }
            }
        }
    }
}
