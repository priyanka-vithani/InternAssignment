//
//  ViewController+PickerView.swift
//  Assignment
//
//  Created by PriyankaVithani on 29/04/21.
//

import Foundation
import UIKit
extension ViewController : UIPickerViewDelegate , UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if txtGender.isEditing{
            return strgender.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if txtGender.isEditing{
            return strgender[row]
        }
        return "Male"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
        if txtGender.isEditing{
            selectedGender = strgender[row]
            txtGender.text = selectedGender
        }
    }
}
