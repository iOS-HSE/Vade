//
//  DatePickerCustomCell.swift
//  Vade
//
//  Created by Egor on 16.11.2020.
//

import UIKit
import Foundation

class DatePickerCustomCell: CustomDetailCell {
    
    private let birthdayPicker = UIDatePicker()
    private let pickerToolbar = UIToolbar()
    
    override func initCell() {
        // configure picker
        birthdayPicker.preferredDatePickerStyle = .wheels
        birthdayPicker.datePickerMode = .date
        birthdayPicker.backgroundColor = UIColor.white
        
        // configure toolbar in picker
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneTapped))
        doneBtn.tintColor = UIColor.systemOrange
        pickerToolbar.backgroundColor = UIColor.white
        pickerToolbar.setItems([flexButton, doneBtn], animated: true)
        pickerToolbar.sizeToFit()
    }
    
    @objc func doneTapped() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        
        self.detailTextLabel?.text = formatter.string(from: birthdayPicker.date)
        self.resignFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return pickerToolbar
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputView: UIView? {
        return birthdayPicker
    }
}
