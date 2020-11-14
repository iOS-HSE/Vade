//
//  PickerTableViewCell.swift
//  Vade
//
//  Created by Egor on 13.11.2020.
//

import UIKit

class PickerTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let picker = UIPickerView()
    var data: [String]

    init(style: UITableViewCell.CellStyle, pickerData: [String], reuseIdentifier: String?) {
        self.data = pickerData
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        picker.delegate = self
        picker.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func awakeFromNib() {
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
        return picker
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.detailTextLabel?.text = data[row]
        self.resignFirstResponder()
    }
}
