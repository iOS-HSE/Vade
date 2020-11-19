//
//  CellBuildersManager.swift
//  Vade
//
//  Created by Egor on 15.11.2020.
//

import Foundation

class CellBuildersManager {
    
    static func buildDatePickerTableCellBirthday() -> DatePickerCustomCell {
        let builder = DatePickerTableCellBuilder()
        builder.initCell()
            .setTitle(title: "Birthday")
            .setDetail(detail: "...")
        
        return builder.build()
    }
    
    static func buildPickerTableCellGender() -> PickerCustomCell {
        let builder = PickerTableCellBuilder()
        builder.initCell()
            .setTitle(title: "Sex")
            .setDetail(detail: "...")
            .setPickerData(data: ["Male", "Female"])
        
        return builder.build()
    }
    
    static func buildPickerTableCellWeight() -> PickerCustomCell {
        let builder = PickerTableCellBuilder()
        let data = ([Int](30...200)).map { String($0) }
        
        builder.initCell()
            .setTitle(title: "Weight")
            .setDetail(detail: "...")
            .setPickerData(data: data)
        
        return builder.build()
    }
    
    static func buildPickerTableCellGrowth() -> PickerCustomCell {
        let builder = PickerTableCellBuilder()
        let data = ([Int](100...250)).map { String($0) }
        builder.initCell()
            .setTitle(title: "Growth")
            .setDetail(detail: "...")
            .setPickerData(data: data)
        
        return builder.build()
    }
}
