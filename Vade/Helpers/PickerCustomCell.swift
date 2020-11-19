//
//  PickerCustomCell.swift
//  Vade
//
//  Created by Egor on 16.11.2020.
//

import UIKit
import Foundation

class PickerCustomCell: CustomDetailCell, UIPickerViewDataSource {
    
    private let picker = UIPickerView()
    private let pickerToolbar = UIToolbar()
    private var data: [String] = []
    private var currentRow = 0
    
    override func initCell() {
        // configure picker
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        
        // configure toolbar in picker
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneTapped))
        doneBtn.tintColor = UIColor.systemOrange
        pickerToolbar.backgroundColor = UIColor.white
        pickerToolbar.setItems([flexButton, doneBtn], animated: true)
        pickerToolbar.sizeToFit()
    }
    
    @objc func doneTapped() {
        self.detailTextLabel?.text = data[currentRow]
        self.resignFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return pickerToolbar
    }
    
    func setPickerData(pickerData: [String]) {
        data = pickerData
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
}

extension PickerCustomCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentRow = row
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
