//
//  ProfileCoverVC.swift
//  SoapBx
//
//  Created by Mac on 06/07/23.
//

import UIKit
import OTLContaner
import Photos

class ProfileCoverVC: UIViewController {

    @IBOutlet private weak var lblTitle: UILabel!
    
    @IBOutlet private weak var imgCoverView: UIImageView!
    @IBOutlet private weak var viewAddCover: OTLDashedView!
    @IBOutlet private weak var viewButtonAddCover: UIView!
    @IBOutlet private weak var lblAddCover: UILabel!
    @IBOutlet private weak var btnRemoveCover: OTLImageButton!
    @IBOutlet private weak var btnRemoveProfile: OTLImageButton!
    @IBOutlet private weak var btnProfile: OTLImageButton!
    
    @IBOutlet private weak var btnNext: OTLTextButton!
    
    @IBOutlet private weak var lblDescription: UILabel!
    @IBOutlet private weak var lblNotes: UILabel!
    
    private let imagePicker = UIImagePickerController()
    private var imgProfile: UIImage? = nil {
        didSet {
            btnRemoveProfile.isHidden = imgProfile == nil
            btnProfile.image = imgProfile == nil ? UIImage(named: "ic_addPhoto")?.withRenderingMode(.alwaysOriginal) : imgProfile
        }
    }
    private var imgCover: UIImage? = nil {
        didSet {
            imgCoverView.image = imgCover
            viewButtonAddCover.isHidden = imgCover != nil
            btnRemoveCover.isHidden = imgCover == nil
        }
    }
    private var isProfile = true
    private let vmObject = ProfileCoverViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        lblTitle.setTheme(LocalStrings.P_COVER_TITLE.rawValue.addLocalizableString(),
                          font: .bold,
                          size: 40)
        
        lblAddCover.setTheme(LocalStrings.P_COVER_ADD.rawValue.addLocalizableString(), color: .titleGray, font: .regular, size: 12)
        
        viewAddCover.addTarget(self, action: #selector(click_btnCover), for: .touchUpInside)
        
        viewAddCover.clipsToBounds = true
        
        imgCoverView.image = nil
        imgCoverView.contentMode = .scaleAspectFill
    
        
        btnProfile.image = UIImage(named: "ic_addPhoto")?.withRenderingMode(.alwaysOriginal)
        btnProfile.layer.cornerRadius = btnProfile.frame.height/2
        btnProfile.addTarget(self, action: #selector(click_btnProfile), for: .touchUpInside)
        btnProfile.contentMode = .scaleAspectFill
        btnProfile.height = btnProfile.frame.height
        
        viewAddCover.cornerRadius = 10
        viewAddCover.dashColor = UIColor.titleRed
        viewAddCover.dashWidth = 2
        viewAddCover.dashLength = 4
        viewAddCover.betweenDashesSpace = 4
        
        btnNext.appButton(LocalStrings.C_NEXT.rawValue.addLocalizableString())
        
        lblDescription.setTheme(LocalStrings.P_COVER_DESC.rawValue.addLocalizableString(), color: .titleBlack)
        lblNotes.setTheme(LocalStrings.P_COVER_NOTE.rawValue.addLocalizableString(), color: .titleGray)
        
        btnRemoveProfile.image = UIImage(named: "ic_cross")
        btnRemoveProfile.isHidden = true
        btnRemoveProfile.addTarget(self, action: #selector(click_btnRemoveProfile), for: .touchUpInside)
        btnRemoveProfile.backgroundColor = .clear
        btnRemoveProfile.height = 15
        
        btnRemoveCover.image = UIImage(named: "ic_cross")
        btnRemoveCover.isHidden = true
        btnRemoveCover.addTarget(self, action: #selector(click_btnRemoveCover), for: .touchUpInside)
        btnRemoveCover.backgroundColor = .clear
        btnRemoveCover.height = 15
    }
    
    //Actions
    @IBAction private func click_btnNext() {
        if imgProfile == nil {
            showToast(message: LocalStrings.P_COVER_ALERT.rawValue.addLocalizableString())
        } else {
            uploadProfile()
        }
    }
    
    @objc private func click_btnRemoveProfile() {
        imgProfile = nil
    }
    
    @objc private func click_btnRemoveCover() {
        imgCover = nil
    }
    
    @objc private func click_btnProfile() {
        PHPhotoLibrary.execute(controller: self, onAccessHasBeenGranted: {
            DispatchQueue.main.async {
                let camera = OTLAlertModel(title: LocalStrings.C_CAMERA.rawValue.addLocalizableString(), id: 0)
                let gallary = OTLAlertModel(title: LocalStrings.C_GALLERY.rawValue.addLocalizableString(), id: 1)
                let cancel = OTLAlertModel(title: LocalStrings.C_CANCEL.rawValue.addLocalizableString(), id: 2, style: .destructive)
                
                showAlert(title: LocalStrings.C_MEDIA_TYPE.rawValue.addLocalizableString(), message: "", buttons: [camera, gallary, cancel]) { alert in
                    self.isProfile = true
                    if alert.id == 0 {
                        self.openCamera()
                    } else if alert.id == 1 {
                        self.openGallary()
                    }
                }
            }
        })
        
    }
    
    @objc private func click_btnCover() {
        PHPhotoLibrary.execute(controller: self, onAccessHasBeenGranted: {
            DispatchQueue.main.async {
                let camera = OTLAlertModel(title: LocalStrings.C_CAMERA.rawValue.addLocalizableString(), id: 0)
                let gallary = OTLAlertModel(title: LocalStrings.C_GALLERY.rawValue.addLocalizableString(), id: 1)
                let cancel = OTLAlertModel(title: LocalStrings.C_CANCEL.rawValue.addLocalizableString(), id: 2, style: .destructive)
                
                showAlert(title: LocalStrings.C_MEDIA_TYPE.rawValue.addLocalizableString(), message: "", buttons: [camera, gallary, cancel]) { alert in
                    self.isProfile = false
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
    
    // API calls
    private func uploadProfile() {
        showLoader()
        vmObject.register(profile: imgProfile!, cover: imgCover) { result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                let vc = YouInterestedVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension ProfileCoverVC:  UIImagePickerControllerDelegate , UINavigationControllerDelegate{
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
      {
            if let pickedImage = info[.editedImage] as? UIImage {
                if self.isProfile {
                    imgProfile = pickedImage
                } else {
                    imgCover = pickedImage
                }
            } else if let pickedImage = info[.originalImage] as? UIImage {
                if self.isProfile {
                    imgProfile = pickedImage
                } else {
                    imgCover = pickedImage
                }
            }
            dismiss(animated: true, completion: nil)
      }
      
      func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
      }
}
