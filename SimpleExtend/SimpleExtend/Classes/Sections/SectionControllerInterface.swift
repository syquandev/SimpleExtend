//
//  SectionControllerInterface.swift
//  IGListDiffKit
//
//  Created by Quan on 29/11/2022.
//

import Foundation
import UIKit
import IGListKit

public protocol SectionControllerInterface: class {
    func setPresenter(_ presenter: AnyObject?)
    func getPresenter() -> AnyObject?
    func getSectionController() -> ListSectionController
    func indexOf(cellModel: CellModelInterface?) -> Int?
    func indexOf(dataModel: BaseModel?) -> Int?
    
    func reloadCell(index: Int, animated: Bool)
    func reloadCell(index: Int, animated: Bool, completion: ((Bool) -> Void)?)
    func reloadCells(indexs: [Int], animated: Bool)
    func reloadCells(indexs: [Int], animated: Bool, completion: ((Bool) -> Void)?)
    
    func reloadCell(cellModel: CellModelInterface?, animated: Bool)
    func reloadCell(cellModel: CellModelInterface?, animated: Bool, completion: ((Bool) -> Void)?)
    func reloadCells(cellModels: [CellModelInterface], animated: Bool)
    func reloadCells(cellModels: [CellModelInterface], animated: Bool, completion: ((Bool) -> Void)?)
    
    func reloadCellByDIffID(_ diffID: String?, animated: Bool)
    func cellModelAtIndex(_ index: Int) -> CellModelInterface?
    func cellModelByDiffID(_ diffID: String?) -> CellModelInterface?
    func cellModelIndexByDiffID(_ diffID: String?) -> Int?
    func getCellModels() -> [CellModelInterface]
    
    func reloadSection(animated: Bool)
    func reloadSection(animated: Bool, completion: ((Bool) -> Void)?)
    
    func refreshSection(animated: Bool)
    func refreshSection(animated: Bool, completion: ((Bool) -> Void)?)
    
    func updateSection(animated: Bool)
    func updateSection(animated: Bool, completion: ((Bool) -> Void)?)
    func updateSection()
    func invalidateSection()
    func getSectionModel() -> Any?
}
