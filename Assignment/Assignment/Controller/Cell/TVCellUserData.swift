//
//  TVCellUserData.swift
//  Assignment
//
//  Created by PriyankaVithani on 29/04/21.
//

import Foundation
import UIKit


protocol btnDeleteDelegate {
    func deleteDatafromFIR(Key: String)
}

class CellUserData: UITableViewCell{
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    var delegate : btnDeleteDelegate? = nil
    
    var obj : userDT!{
        didSet{
            let objUSer = obj.val
            let age = ageCounter(dob: objUSer.DOB)
            if let url = URL(string: objUSer.profileImage){
                downloadImage(from: url)
            }
            lblBio.text = "\(objUSer.gender) | \(age) | \(objUSer.homeTown)"
            lblUserName.text = objUSer.firstName + " " + objUSer.lastName
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnDelete.addTarget(self, action: #selector(btnDeleteTapped), for: .touchUpInside)
    }
    @objc func btnDeleteTapped(){
        delegate?.deleteDatafromFIR(Key: obj.key)
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func ageCounter(dob:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date = dateFormatter.date(from: dob) {
            let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year!
            return "\(age)"
        }
        return ""
    }
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                if let img = UIImage(data: data){
                    self?.imgProfile.image = img
                }
            }
        }
    }
}
