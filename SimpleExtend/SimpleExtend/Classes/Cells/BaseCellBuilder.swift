//
//  BaseCellBuilder.swift
//  SimpleExtend
//
//  Created by Quan on 29/11/2022.
//
import Foundation
import UIKit
import IGListKit

open class BaseCellBuilder: NSObject, CellBuilderInterface {
    public var cellModels:[CellModelInterface] = []
    public weak var sectionModel: BaseSectionModel?
    public weak var sectionController: SectionControllerInterface?
    
    public var isDisableAlpha = false
    public var isDisableInteraction = false
    
    
    open func setSectionModel(_ sectionModel: BaseSectionModel?, sectionController: SectionControllerInterface?){
        self.sectionModel = sectionModel
        self.sectionController = sectionController
    }
    open func parseCellModels(){
        
    }
    
    open func clearCellModels(){
        self.cellModels.removeAll()
    }
    
    open func getCellModels() ->  [CellModelInterface]{
        for item in cellModels{
            item.setSectionController(self.sectionController)
        }
        return self.cellModels
    }
    
    open func appendCell(_ cell: CellModelInterface?){
        self.cellModels.safeAppend(cell)
    }
    
    open func appendCells(_ cells: [CellModelInterface]?){
        self.cellModels.safeAppend(sequence: cells)
    }
    
    
//    public func addBlockShadow(_ height: CGFloat = 8){
//        let cellModel = BlockShadowCellModel()
//        cellModel.height = height
//        self.cellModels.safeAppend(cellModel)
//    }
    
//    @discardableResult
//    open func addBlankSpace(_ height: CGFloat = 8, color: UIColor = UIColor.clear) -> BlankSpaceCellModel{
//        let cellModel = BlankSpaceCellModel(height: height)
//        cellModel.color = color
//        self.cellModels.safeAppend(cellModel)
//        return cellModel
//    }
    
//    @discardableResult
//    public func addSingleLine(_ compactMode: Bool = false) -> SingleLineCellModel{
//        let cellModel = SingleLineCellModel()
//        cellModel.compactMode = compactMode
//        self.cellModels.safeAppend(cellModel)
//        return cellModel
//    }
    
//    public func addFullSingleLine(_ compactMode: Bool = false){
//        let cellModel = FullLineCellModel()
//        cellModel.compactMode = compactMode
//        self.cellModels.safeAppend(cellModel)
//    }
    
//    public func addLoading(){
//        let cellModel = LoadingCellModel()
//        self.cellModels.safeAppend(cellModel)
//    }
    
//    public func addManualLoading(){
//        let cellModel = ManualLoadingCellModel()
//        self.cellModels.safeAppend(cellModel)
//    }
    
//    public func addEmpyData(_ content: String = "", background:UIColor = UIColor.clear){
//        let cellModel = EmptyDataCellModel()
//        cellModel.content = content
//        cellModel.background = background
//        self.cellModels.safeAppend(cellModel)
//    }
    
    
    public func disableInteractionCells(){
        
        self.cellModels.forEach { (item) in
            item.setDisableInteraction(true)
        }
    }
    
    
    public func disableAlphaCells(){
        
        self.cellModels.forEach { (item) in
            item.setDisable(true)
        }
    }
    
    
//    @discardableResult
//    public func addCellTitle(_ title: NSAttributedString?, content: NSAttributedString?) -> TableCellModel{
//        guard let key = title,
//            let value = content else{
//                return TableCellModel(text: "---")
//        }
//        let cell = TableCellModel(key: key, value: value)
//        cell.enableBottomLine = true
//        self.appendCell(cell)
//        return cell
//    }
//
//    @discardableResult
//    open func addCellTitle(_ title: String, content: String, color: AppColor? = nil, bold: Bool = false) -> TableCellModel{
//
//        return self.addCellTitle(title, titleColor: nil, titleBold: false, content: content, contentColor: color, contentBold: bold)
//    }
//
//    @discardableResult
//    public func addCellTitle(_ title: String, content: NSAttributedString) -> TableCellModel{
//
//        return self.addCellTitle(StringBuilder().appendLight(title).value, content: content)
//    }
//
//    @discardableResult
//    public func addCellTitle(_ title: String, titleColor: AppColor? = nil, titleBold: Bool = false, content: String, contentColor: AppColor? = nil, contentBold: Bool = false) -> TableCellModel{
//        let builder = StringBuilder()
//        var leftAttr: NSAttributedString?
//        if true{
//
//            builder.clear()
//            let color = titleColor ?? AppColor.light
//            if titleBold{
//                builder.append(title, font: AppFont.bold_16, color: color)
//
//            }else{
//                builder.append(title, color: color)
//
//            }
//            leftAttr = builder.value
//        }
//
//        var rightAttr: NSAttributedString?
//        if true{
//            builder.clear()
//            let color = contentColor ?? AppColor.normal
//            if contentBold{
//                builder.append(content, font: AppFont.bold_16, color: color)
//
//            }else{
//                builder.append(content, color: color)
//
//            }
//            rightAttr = builder.value
//        }
//
//        return self.addCellTitle(leftAttr, content: rightAttr)
//    }
//
//    public func addSectionHeader(_ title: String){
//        let cell = TextCellModel(text: title, font: AppFont.bold_16)
//        cell.topSpace = 32
//        cell.bottomSpace = 16
//        self.appendCell(cell)
//    }
//
//    public func addExtraDetail(_ title: String, tag: Int, color: AppColor = AppColor.normal){
//
//        let cell = TableCellModel(text: title.localized, icon: TableCellBuildinIcon.right_dark, color: color)
//        cell.tag = tag
//        self.appendCell(cell)
//    }
    
}
