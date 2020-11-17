//
//  DatePickerTableCellBuilder.swift
//  Vade
//
//  Created by Egor on 15.11.2020.
//

import Foundation

class DatePickerTableCellBuilder: CustomDetailCellBuilder<DatePickerCustomCell> {
    
    init() {
        super.init(object: DatePickerCustomCell())
    }
    
    func initCell() -> Self {
        targetObject.initCell()
        return self
    }
}
