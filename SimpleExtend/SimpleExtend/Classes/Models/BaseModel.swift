//
//  BaseModel.swift
//  SimpleExtend
//
//  Created by Quan on 29/11/2022.
//
import Foundation
import IGListKit

open class BaseModel: NSObject, ListDiffable ,DiffBaseModel{
    
    
    public var id : String?
    public var diffID: String = Random.stringKey()
    public var cellDiffID: String?
    public var needUpdate = false
    
    public func diffIdentifier() -> NSObjectProtocol {
        return getDiffID() as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let obj = object as? BaseModel {
            return self.id  == obj.id
        }
        return false
    }
    
    open func getDiffID() -> String{
        return self.id ?? self.diffID
    }
    
    open func isNeedUpdate() -> Bool {
        return self.needUpdate
    }
}
