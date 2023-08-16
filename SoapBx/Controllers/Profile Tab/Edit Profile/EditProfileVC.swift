//
//  EditProfileVC.swift
//  SoapBx
//
//  Created by Mac on 17/07/23.
//

import UIKit
import OTLContaner
import Photos

class EditProfileVC: UIViewController {

    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    
    @IBOutlet private weak var imgCoverView:UIImageView!
    @IBOutlet private weak var btnEditCover:OTLImageButton!
    @IBOutlet private weak var btnProfile:OTLImageButton!
    
    @IBOutlet private weak var txtFirstName: OTLTextField!
    @IBOutlet private weak var txtLastName: OTLTextField!
    @IBOutlet private weak var txtPhoneNo: OTLCountryCode!
    @IBOutlet private weak var txtEmail: OTLTextField!
    @IBOutlet private weak var txtLocation: OTLTextField!
    
    @IBOutlet private weak var btnUpdate: OTLTextButton!
    
    private let vmObject = EditProfileViewModel()
    private let imagePicker = UIImagePickerController()
    private var imgProfile: UIImage? = nil {
        didSet {
            btnProfile.image = imgProfile
            vmObject.profileImage = imgProfile
        }
    }
    private var imgCover: UIImage? = nil {
        didSet {
            imgCoverView.image = imgCover
            vmObject.coverImage = imgCover
        }
    }
    private var isProfile = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        viewHeader.lblTitle.setHeader("Edit Profile")
        
        viewBody.backgroundColor = .white
        
        imgCoverView.image = UIImage(named: "")
        imgCoverView.backgroundColor = .lightGrey
        imgCoverView.contentMode = .scaleAspectFill
        btnEditCover.image = UIImage(named: "ic_edit")
        btnEditCover.backgroundColor = .clear
        btnEditCover.height = 25
        
        btnProfile.image = UIImage(named: "profileOne")
        btnProfile.contentMode = .scaleAspectFill
        btnProfile.layer.cornerRadius = btnProfile.frame.height/2
        btnProfile.backgroundColor = .lightGrey
        btnProfile.height = btnProfile.frame.height
        
        
        txtFirstName.setTheme(placeholder: "First name",
                          leftIcon: UIImage(named: "ic_user"))
        txtLastName.setTheme(placeholder: "Last name",
                             leftIcon: UIImage(named: "ic_user"))
        txtPhoneNo.setTheme(placeholder: "Phone Number",
                          leftIcon: UIImage(named: "ic_phone"))
        txtEmail.setTheme(placeholder: "Email",
                          leftIcon: UIImage(named: "ic_email"))
        txtLocation.setTheme(placeholder: "Location",
                             leftIcon: UIImage(named: "ic_location_grey"))
        txtLocation.delegate = self
        
        btnUpdate.appButton("Update")
        setData()
    }

    private func setData() {
        imgCoverView.setImage(authUser?.user?.cover_photo_url)
        btnProfile.setImage(authUser?.user?.profile_photo_url)
        
        txtFirstName.text = authUser?.user?.first_name ?? ""
        txtLastName.text = authUser?.user?.last_name ?? ""
        txtPhoneNo.text = authUser?.user?.phone_number ?? ""
        txtEmail.text = authUser?.user?.email ?? ""
        txtLocation.text = authUser?.user?.location ?? ""
        let loca = GMapLocation(lat: authUser?.user?.latitude ?? 0, lng: authUser?.user?.longitude ?? 0)
        vmObject.selectedSearch = GMapResult(formattedAddress: authUser?.user?.location ?? "", geometry: GMapGeometry(loca))
    }
    
    //Actions
    @IBAction private func click_update() {
        let validateFirst = txtFirstName.text.validateFirst()
        let validateLast = txtLastName.text.validateLast()
        let validateEmail = txtEmail.text.validateEmail()
        let validatePhone = txtPhoneNo.text.validatePhone()
        
        if validateFirst.status == false {
            showToast(message: validateFirst.message)
        }
        else if validateLast.status == false {
            showToast(message: validateLast.message)
        }
        else if validatePhone.status == false, txtPhoneNo.text.count > 0 {
            showToast(message: validatePhone.message)
        }
        else if validateEmail.status == false {
            showToast(message: validateEmail.message)
        }
        else {
            vmObject.requestObj = SignupRequestModel(
                first_name: self.txtFirstName.text,
                last_name: self.txtLastName.text,
                email: self.txtEmail.text,
                phone_number: self.txtPhoneNo.text,
                password: "",
                confirm_password: "",
                country_code: "+1",
                location: self.vmObject.selectedSearch?.formattedAddress ?? "",
                longitude: self.vmObject.selectedSearch?.geometry?.location?.lng ?? 0,
                latitude: self.vmObject.selectedSearch?.geometry?.location?.lat ?? 0,
                verified_by: authUser?.user?.verified_by ?? 0
            )
            updateProfile()
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
    private func updateProfile() {
        showLoader()
        vmObject.updateProfile { result in
            hideLoader()
            if result.status {
                if (self.vmObject.requestObj?.canVerifyUpdate ?? false) {
                    let vc = VerificationCodeVC()
                    vc.navigateUpdateProfile(self.vmObject)
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    mackRootView(ProfileVC())
                }
            }else {
                showToast(message: result.message)
            }
        }
    }
}

extension EditProfileVC:  UIImagePickerControllerDelegate , UINavigationControllerDelegate{
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


extension EditProfileVC: OTLTextFieldDelegate {
    
    func otlTextField(_ textField: OTLTextField, willStartEditing: Bool) {
        if textField == txtLocation {
            self.view.endEditing(true)
            let vc = LocationSearchVC()
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
    
}
extension EditProfileVC: LocationSearchDelegate {
    func locationSearch(_ controller: LocationSearchVC, didSelect: GMapResult) {
        vmObject.selectedSearch = didSelect
        txtLocation.text = didSelect.formattedAddress
    }
    
    
}
