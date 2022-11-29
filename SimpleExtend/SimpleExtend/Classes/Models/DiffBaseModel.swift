//
//  DiffBaseModel.swift
//  SimpleExtend
//
//  Created by Quan on 29/11/2022.
//

import Foundation
import IGListKit

public protocol DiffBaseModel: AnyObject{
    func getDiffID() -> String
    func isNeedUpdate() -> Bool
}
