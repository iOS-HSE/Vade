//
//  CustomDetailCellBuilder.swift
//  Vade
//
//  Created by Egor on 17.11.2020.
//

import Foundation

class CustomDetailCellBuilder<T: CustomDetailCell>: Builder<T> {
    
    func setTitle(title: String) -> Self {
        targetObject.setTitle(title: title)
        return self
    }
    
    func setDetail(detail: String) -> Self{
        targetObject.setDetailText(detail: detail)
        return self
    }
}
