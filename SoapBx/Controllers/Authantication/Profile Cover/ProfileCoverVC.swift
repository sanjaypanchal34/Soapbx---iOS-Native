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
    
    @IBOutlet private weak var btnProfile: OTLImageButton!
    
    @IBOutlet private weak var btnNext: OTLTextButton!
    
    @IBOutlet private weak var lblDescription: UILabel!
    @IBOutlet private weak var lblNotes: UILabel!
    
    private let imagePicker = UIImagePickerController()
    private var imgProfile: UIImage? = nil {
        didSet {
            btnProfile.image = imgProfile
        }
    }
    private var imgCover: UIImage? = nil {
        didSet {
            imgCoverView.image = imgCover
            viewButtonAddCover.isHidden = true
        }
    }
    private var isProfile = true
    private let vmObject = ProfileCoverViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        lblTitle.setTheme("Set Profile Picture and Cover Photo",
                          font: .bold,
                          size: 40)
        
        lblAddCover.setTheme("Add cover phote\n(Optional)", color: .titleGrey, font: .regular, size: 12)
        
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
        
        btnNext.appButton("Next")
        
        lblDescription.setTheme("Add a profile picture so that you and your friend can identifv each other", color: .titleBlack)
        lblNotes.setTheme("*Cover photo is optional and can be added later.", color: .titleGrey)
    }
    
    //Actions
    @IBAction private func click_btnNext() {
        if imgProfile == nil {
            showToast(message: "Select profile photo.")
        } else {
            uploadProfile()
        }
    }
    
    @IBAction private func click_btnProfile() {
        PHPhotoLibrary.execute(controller: self, onAccessHasBeenGranted: {
            DispatchQueue.main.async {
                let camera = OTLAlertModel(title: "Camera", id: 0)
                let gallary = OTLAlertModel(title: "Gallary", id: 1)
                let cancel = OTLAlertModel(title: "Cancel", id: 2, style: .destructive)
                
                showAlert(title: "Media Type", message: "", buttons: [camera, gallary, cancel]) { alert in
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
    @IBAction private func click_btnCover() {
        PHPhotoLibrary.execute(controller: self, onAccessHasBeenGranted: {
            DispatchQueue.main.async {
                let camera = OTLAlertModel(title: "Camera", id: 0)
                let gallary = OTLAlertModel(title: "Gallary", id: 1)
                let cancel = OTLAlertModel(title: "Cancel", id: 2, style: .destructive)
                
                showAlert(title: "Media Type", message: "", buttons: [camera, gallary, cancel]) { alert in
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
            if result.status {
                let vc = YouInterestedVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                showToast(message: result.message)
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
