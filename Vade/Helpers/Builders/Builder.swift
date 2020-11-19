//
//  Builder.swift
//  Vade
//
//  Created by Egor on 15.11.2020.
//

import Foundation

protocol SimplyInitializable {
    init()
}

protocol BuilderPtorocol {
    associatedtype T
    func reset()
    func build() -> T
}

// base Builder
class Builder<TargetType: SimplyInitializable>: BuilderPtorocol {
    var targetObject: TargetType
    
    init(object: TargetType) {
        targetObject = object
    }
    
    func reset() {
        targetObject = TargetType()
    }
    
    func build() -> T {
        let result = targetObject
        reset()
        return result
    }
    
    typealias T = TargetType
}
