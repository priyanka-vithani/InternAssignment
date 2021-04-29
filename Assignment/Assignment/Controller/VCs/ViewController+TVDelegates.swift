//
//  ViewController+TVDelegates.swift
//  Assignment
//
//  Created by PriyankaVithani on 29/04/21.
//

import Foundation
import UIKit
//MARK:- UITableView dlegate and data source

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if btnUsers.isSelected{
            if arrUserList.count == 0{
                self.tblUsers.setEmptyMessage("No data found")
            } else {
                self.tblUsers.restore()
            }
            
            return arrUserList.count
            
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellUserData", for: indexPath) as! CellUserData
        cell.delegate = self
        cell.obj = arrUserList[indexPath.row]
        
        return cell
    }
    
    
}
