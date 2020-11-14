//
//  DatePickerTableViewCell.swift
//  Vade
//
//  Created by Egor on 13.11.2020.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {

    let birthdayPicker = UIDatePicker()
    let pickerToolbar = UIToolbar()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        birthdayPicker.preferredDatePickerStyle = .wheels
        birthdayPicker.datePickerMode = .date
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.doneTapped))
        pickerToolbar.sizeToFit()
        pickerToolbar.setItems([doneButton], animated: true)
    }
    
    @objc func doneTapped() {
        print("Done Tapped")
    }
    
    override var inputAccessoryView: UIView? {
        return pickerToolbar
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
