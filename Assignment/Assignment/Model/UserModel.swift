//
//  UserModel.swift
//  Assignment
//
//  Created by PriyankaVithani on 28/04/21.
//

import Foundation

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}
struct User {
    
    var firstName: String
    var lastName: String
    var DOB : String
    var gender : String
    var country : String
    var state : String
    var homeTown : String
    var phoneNumber : String
    var telephoneNumber : String
    var profileImage : String
    var dictionary: [String: Any] {
        return ["firstName" : firstName,
                "lastName" : lastName,
                "DOB" : DOB,
                "gender" : gender,
                "country" : country,
                "state" : state,
                "homeTown" : homeTown,
                "phoneNumber" : phoneNumber,
                "telephoneNumber" : telephoneNumber,
                "profileImage" : profileImage]
    }
}

extension User: DocumentSerializable {

    init?(dictionary: [String : Any]) {
        
        guard let firstName = dictionary["firstName"] as? String,
              let lastName = dictionary["lastName"] as? String,
              let DOB = dictionary["DOB"] as? String,
              let gender = dictionary["gender"] as? String,
              let country = dictionary["country"] as? String,
              let state = dictionary["state"] as? String,
              let homeTown = dictionary["homeTown"] as? String,
              let phoneNumber = dictionary["phoneNumber"] as? String,
              let telephoneNumber = dictionary["telephoneNumber"] as? String,
              let profileImage = dictionary["profileImage"] as? String else{return nil}
        
        self.init(firstName: firstName, lastName: lastName, DOB: DOB, gender: gender, country: country, state: state, homeTown: homeTown, phoneNumber: phoneNumber, telephoneNumber: telephoneNumber, profileImage: profileImage)
    }
}


struct UserListViewData {
    var users: [User]
    var userListWithKey: [userDT]
}
struct userDT {
    var key: String
    var val:User
    var dict:[String:Any]{
        return["key":key, "val":val]
    }
}
extension userDT: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let key = dictionary["key"] as? String, let val = dictionary["val"] as? User else{return nil}
        self.init(key: key, val: val)
    }
}
