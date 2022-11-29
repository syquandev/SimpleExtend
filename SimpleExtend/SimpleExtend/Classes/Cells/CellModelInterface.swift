//
//  CellModelInterface.swift
//  SimpleExtend
//
//  Created by Quan on 29/11/2022.
//
import UIKit
import IGListKit

public protocol CellModelInterface: ListDiffable, DiffBaseModel {
    func setSectionController(_ section: Any?)
    func getSectionController() -> SectionControllerInterface?
    func getCellHeight(maxWidth:CGFloat) -> CGFloat
    func getCellWidth(maxWidth:CGFloat) -> CGFloat
    func getCellName() -> String
    func getBundle() -> Bundle?
    func getDataModel() -> Any?
    func getCompactMode() -> Bool
    func setCompactMode(_ compact: Bool)
    func isDisable() -> Bool
    func setDisable(_ disable: Bool)
    func isDisableInteraction() -> Bool
    func setDisableInteraction(_ disable: Bool)
    func setCellView(_ view: CellModelViewInterface?)
    func getCellView() -> CellModelViewInterface?
    func getTag() -> Int
    func showBottomLine() -> Bool
    func showTopLine() -> Bool
    func updateDataVersion()
    func reloadCell(_ animated: Bool)
    func clearData()
    func getError() -> String?
}

