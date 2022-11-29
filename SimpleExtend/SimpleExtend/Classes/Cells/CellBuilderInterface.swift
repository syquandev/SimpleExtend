//
//  CellBuilderInterface.swift
//  SimpleExtend
//
//  Created by Quan on 29/11/2022.
//

import Foundation
import UIKit
import IGListKit

public protocol CellBuilderInterface: class{
    
    func setSectionModel(_ sectionModel: BaseSectionModel?, sectionController: SectionControllerInterface?)
    func getCellModels() -> [CellModelInterface]
    func parseCellModels()
    func clearCellModels()
}
