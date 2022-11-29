//
//  BaseSectionModel.swift
//  SimpleExtend
//
//  Created by Quan on 29/11/2022.
//
import Foundation
import UIKit

open class BaseSectionModel: BaseModel {
    public weak var sectionController: SectionControllerInterface?
    open func getSectionInit() -> SectionControllerInterface?{
        return nil
    }
    
    deinit {
//        print("\(String(describing: self)) section model deinit")
    }

}
