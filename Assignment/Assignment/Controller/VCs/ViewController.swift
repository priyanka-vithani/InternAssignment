//
//  ViewController.swift
//  Assignment
//
//  Created by PriyankaVithani on 28/04/21.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    //MARK:- IBOutlets
    
    //Header
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblDemoApplication: UILabel!
    @IBOutlet weak var btnEnroll: UIButton!
    @IBOutlet weak var lblEnroll: UILabel!
    @IBOutlet weak var btnUsers: UIButton!
    @IBOutlet weak var lblUsers: UILabel!
    
    //Enroll
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnSelectProfileImage: UIButton!
    @IBOutlet weak var lblSelectProfileImage: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtHomeTown: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtTelephoneNumber: UITextField!
    @IBOutlet weak var btnAddUser: UIButton!
    //Users
    
    @IBOutlet weak var nslcTblUserBottom: NSLayoutConstraint!
    @IBOutlet weak var tblUsers: UITableView!
    
    //MARK:- variables and constants
    
    var ref: DatabaseReference!
    let datePicker = UIDatePicker()
    var strgender = ["Male","Female"]
    var selectedGender: String?
    var arrUserList = [userDT]()
    
    //MARK:- View life cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        selectedTabSetup()
        self.choosGender()
        self.txtDOB.datePicker(target: self,doneAction: #selector(doneAction),cancelAction: #selector(cancelAction),datePickerMode: .date)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.tblUsers.tableFooterView = UIView(frame: .zero)
    }
    
    //MARK:- IBAction
    @IBAction func btnCancelClick(_ sender: Any) {
        btnUsers.isSelected = true
        btnEnroll.isSelected = false
        selectedTabSetup()
        self.tblUsers.reloadData()
    }
    
    @IBAction func btnUsersClick(_ sender: UIButton) {
        btnUsers.isSelected = true
        btnEnroll.isSelected = false
        selectedTabSetup()
        self.tblUsers.reloadData()
    }
    @IBAction func btnEnrollClick(_ sender: UIButton) {
        btnUsers.isSelected = false
        btnEnroll.isSelected = true
        selectedTabSetup()
        self.tblUsers.reloadData()
    }
    @IBAction func btnSelectProfileClick(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
            self.btnSelectProfileImage.setImage(image, for: .normal)
        }
    }
    @IBAction func btnAddUSerClick(_ sender: UIButton) {
        validateUserDetail()
    }
    @objc func cancelAction() {
        self.txtDOB.resignFirstResponder()
    }
    
    @objc func doneAction() {
        if let datePickerView = self.txtDOB.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.txtDOB.text = dateString
            self.txtDOB.resignFirstResponder()
        }
    }
    @objc func keyboardWillShow(notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            var newHeight: CGFloat
            let duration:TimeInterval = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if #available(iOS 11.0, *) {
                newHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
            } else {
                newHeight = keyboardFrame.cgRectValue.height
            }
            let keyboardHeight = newHeight  + 10
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            self.nslcTblUserBottom.constant = keyboardHeight //**//Here you can manage your view constraints for animated show**
                            self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
            let duration:TimeInterval = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            self.nslcTblUserBottom.constant = 0
                            self.view.layoutIfNeeded() },
                           completion: nil)
        
    }
    //MARK:- Custom methods
    
    func validateUserDetail(){
        if validateTxtFieldLength(txtFirstName, message: "Please enter your firstname") && validateTxtFieldLength(txtLastName, message: "Please enter your lastname") && validateTxtFieldLength(txtDOB, message: "Please select your date of birth") &&
            validateTxtFieldLength(txtGender, message: "Please select your gender") &&
            validateTxtFieldLength(txtCountry, message: "Please enter your country") &&
            validateTxtFieldLength(txtState, message: "Please enter your state") &&
            validateTxtFieldLength(txtHomeTown, message: "Please enter your hometown") &&
            validateTxtFieldLength(txtPhoneNumber, message: "Please enter your phone number") && validateMobileNo(txtPhoneNumber, withMessage: "Please enter 10 digit phone number") &&
            validateTxtFieldLength(txtTelephoneNumber, message: "Please enter your telephone number") && validateMobileNo(txtTelephoneNumber, withMessage: "Please enter valid telephone number") {
            LoadingHud.showHUD()
            uploadMedia { (urlString) in
                let userData = User.init(
                    firstName: self.txtFirstName.text ?? "",
                    lastName: self.txtLastName.text ?? "",
                    DOB: self.txtDOB.text ?? "",
                    gender: self.txtGender.text ?? "",
                    country:self.txtCountry.text ?? "",
                    state: self.txtState.text ?? "",
                    homeTown: self.txtHomeTown.text ?? "",
                    phoneNumber: self.txtPhoneNumber.text ?? "",
                    telephoneNumber: self.txtTelephoneNumber.text ?? "",
                    profileImage: urlString ?? "")
                self.storeDataIntoFirebase(userData: userData)
            }
            
        }
    }
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        var imgName = ""
        if let txtFname = txtFirstName.text, let txtLname = txtLastName.text{
            imgName = txtFname + " " + txtLname
        }
        
        let storageRef = Storage.storage().reference().child("\(imgName).png")
        
        if let uploadData = self.btnSelectProfileImage.imageView?.image?.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    completion(nil)
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        completion(url?.absoluteString)
                    })
                }
            }
        }
    }
    func deleteData(key:String){
        self.ref.child("users").child(key).removeValue()
        UIView.performWithoutAnimation {
            self.tblUsers.reloadData()
        }
    }
    func storeDataIntoFirebase(userData: User){
        self.ref.child("users").childByAutoId().setValue(userData.dictionary )
        LoadingHud.hideHUD()
        btnUsers.isSelected = true
        btnEnroll.isSelected = false
        selectedTabSetup()
        self.tblUsers.reloadData()
    }
    func getDataFromFirebase(){
        LoadingHud.showHUD()
        self.ref.child("users").queryOrderedByKey().observe(.value){(snapshot) in
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                self.arrUserList.removeAll()
                LoadingHud.hideHUD()
                for snap in snapShot.reversed(){
                    if let mainDict = snap.value as? [String:Any]{
                        if let objuser = User.init(dictionary: mainDict){
                            var dic = [String:Any]()
                            dic["key"] = snap.key
                            dic["val"] = objuser
                            if let obj = userDT.init(dictionary: dic){
                                self.arrUserList.append(obj)
                            }
                            self.tblUsers.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func TRIM(string: Any) -> String
    {
        return (string as AnyObject).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    func validateTxtFieldLength(_ txtVal: UITextField, message:String) -> Bool {
        if TRIM(string: txtVal.text ?? "").count == 0
        {
            txtVal.shake()
            showAlert(message: message)
            return false
        }
        return true
    }
    func validateMobileNo(_ txtVal: UITextField, withMessage msg: String) -> Bool {
        if TRIM(string: txtVal.text ?? "").count > 10 || TRIM(string: txtVal.text ?? "").count < 10
        {
            txtVal.shake()
            showAlert(message: msg)
            return false
        }
        return true
    }
    func showAlert(message: String){
        let alert = UIAlertController.init(title: "Alert", message: message, preferredStyle: .alert)
        let dismiss = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
    }
    func selectedTabSetup(){
        if btnUsers.isSelected{
            lblUsers.isHidden = false
            lblEnroll.isHidden = true
            headerView.frame = CGRect.zero
            headerView.isHidden = true
            getDataFromFirebase()
        }else{
            lblUsers.isHidden = true
            lblEnroll.isHidden = false
            headerView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 800)
            headerView.isHidden = false
            clearTextfieldData()
        }
    }
    func clearTextfieldData(){
        txtFirstName.text = ""
        txtLastName.text = ""
        txtDOB.text = ""
        txtGender.text = ""
        txtCountry.text = ""
        txtState.text = ""
        txtHomeTown.text = ""
        txtPhoneNumber.text = ""
        txtTelephoneNumber.text = ""
    }
    func choosGender() {
        let gender1 = UIPickerView()
        gender1.delegate = self
        self.txtGender.inputView = gender1
    }
}
extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}


extension ViewController: btnDeleteDelegate{
    func deleteDatafromFIR(Key: String) {
        if self.arrUserList.contains(where: { $0.key == Key}){
            self.arrUserList = arrUserList.filter{ $0.key == Key}
        }
        
        deleteData(key: Key)
    }
}



