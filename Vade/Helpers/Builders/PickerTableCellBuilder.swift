//
//  CustomTableCellBuilder.swift
//  Vade
//
//  Created by Egor on 15.11.2020.
//

import Foundation

class PickerTableCellBuilder: CustomDetailCellBuilder<PickerCustomCell> {
    
    init() {
        super.init(object: PickerCustomCell())
    }
    
    func initCell() -> Self {
        targetObject.initCell()
        return self
    }
    
    func setPickerData(data: [String]) -> Self {
        targetObject.setPickerData(pickerData: data)
        return self
    }
}
