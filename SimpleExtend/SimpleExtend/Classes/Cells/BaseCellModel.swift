//
//  BaseCellModel.swift
//  SimpleExtend
//
//  Created by Quan on 29/11/2022.
//
import Foundation
import UIKit
import IGListKit

public enum ErrorMessageType{
    case leftText
    case centerText
    case rightText
}

public enum RoundCornerType{
    case none
    case all
    case top
    case bottom
}

open class BaseCellModel: NSObject, CellModelInterface, DiffBaseModel {
    
    private weak var sectionControler: SectionControllerInterface?
    public var compactMode = false
    public var disable = false
    public var disableInteraction = false
    public var needUpdate = false
    public var tag = 0
    public var index = 0
    public var diffID: String!
    public var enableBottomLine = false
    public var enableTopLine = false
    public var diffExtension: String = ""
    public var diffExtensionIndex: Int = 0
    public weak var weakData: AnyObject?
    public static var minHeaderHeight: CGFloat = 56
    
    public var errorMessage: String?
    public var errorMessageType = ErrorMessageType.leftText
    
    public func getError() -> String? {
        return errorMessage
    }
    
    
    public var enableSideConstraint: Bool = false
    
    public func setAllSideSpace(_ val: CGFloat){
        self.topSpace = val
        self.leftSpace = val
        self.bottomSpace = val
        self.rightSpace = val
    }
    
    private var m_leftSpace: CGFloat = 0
    public var leftSpace: CGFloat{
        get{
            return m_leftSpace
        }
        
        set{
            m_leftSpace = newValue
            enableSideConstraint = true
        }
    }
    
    private var m_rightSpace: CGFloat = 0
    public var rightSpace: CGFloat{
        get{
            return m_rightSpace
        }
        
        set{
            m_rightSpace = newValue
            enableSideConstraint = true
        }
    }
    
    private var m_topSpace: CGFloat = 0
    public var topSpace: CGFloat{
        get{
            return m_topSpace
        }
        
        set{
            m_topSpace = newValue
            enableSideConstraint = true
        }
    }
    
    private var m_bottomSpace: CGFloat = 0
    public var bottomSpace: CGFloat{
        get{
            return m_bottomSpace
        }
        
        set{
            m_bottomSpace = newValue
            enableSideConstraint = true
        }
    }
    
    
    public var height: CGFloat = 44
    
    private var _mVersion: Int = 0
    private var _mDiffID = Random.stringKey()
    
//    public var bottomLinePadding: CGFloat = 0
//    public var topLinePadding: CGFloat = 0
    
    public override init() {
        super.init()
        self.initDiffID()
        self.generateDiffID()
    }
    
    public var finalHeight: CGFloat = -1
    
    public weak var cellView: CellModelViewInterface?
    
    open func setCellView(_ view: CellModelViewInterface?) {
        self.cellView = view
    }
    
    open func getCellView() -> CellModelViewInterface?{
        return self.cellView
    }
    
    open func setDiffObject(_ obj: DiffBaseModel?){
        guard let diffID = obj?.getDiffID() else{
            return
        }
        self.updateDiffID(diffID)
        
    }
    
    open func updateDiffID(_ diffID: String){
        self._mDiffID = diffID
        self.generateDiffID()
    }
    open func initDiffID(){
        
    }
    
    private func generateDiffID(){
        self.diffID = "\(_mDiffID)_\(diffExtension)_\(diffExtensionIndex)_v\(_mVersion)"
    }
    
    open func diffIdentifier() -> NSObjectProtocol {
        return self.getDiffID() as NSObjectProtocol
    }
    
    open func updateDataVersion(){
        _mVersion += 1
        self.generateDiffID()
    }
    
    open func clearData(){
        finalHeight = -1
    }
    
    open func isNeedUpdate() -> Bool {
        return self.needUpdate
    }
    
    public func showBottomLine() -> Bool {
        return self.enableBottomLine
    }
    
    public func showTopLine() -> Bool {
        return self.enableTopLine
    }
    
    open func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        
        if let object = object as? BaseCellModel {
            return self.getDiffID() == object.getDiffID()
        }
        return false
    }
    
    public func getTag() -> Int {
        return self.tag
    }
    
    open func getDiffID() -> String{
        return self.diffID
    }
    
    open func reloadCell(_ animated: Bool = false){
        self.sectionControler?.reloadCell(cellModel: self, animated: animated)
    }
    open func invalidateCell(){
        self.sectionControler?.invalidateSection()
    }
    
    open func updateCell(){
        self.cellView?.update()
    }
    
    open func updateSection(animated: Bool = true){
        self.sectionControler?.updateSection(animated: animated)
    }
    open func reloadSection(animated: Bool = true){
        self.sectionControler?.reloadSection(animated: animated)
    }
    open func refreshSection(animated: Bool = true){
        self.sectionControler?.refreshSection(animated: animated)
    }
    
    open func invalidateSection(){
        self.sectionControler?.invalidateSection()
    }
    
//    open func getCellView() -> UICollectionViewCell?{
//
//        if let model = self as? CellModelInterface{
//            return self.baseDelegate?.getCellView(model:model)
//        }
//        return nil
//    }
    
    open func getCompactFixedWidth() -> CGFloat{
        return self.compactMode ? 32 : 0
    }
    
    open func getCompactMode() -> Bool{
        return self.compactMode
    }
    
    open func setCompactMode(_ compact: Bool){
        self.compactMode = compact
    }
    
    
    open func getDataModel() -> Any?{
        return nil
    }
    
    open func setSectionController(_ section: Any?){
        self.sectionControler = section as? SectionControllerInterface
    }
    
    open func getSectionController() -> SectionControllerInterface?{
        return self.sectionControler
    }
    
    open func getCellHeight(maxWidth:CGFloat) -> CGFloat{
        return 0
    }
    
    open func getCellWidth(maxWidth:CGFloat) -> CGFloat{
        return -1
    }
    open func getCellName() -> String{
        let modelName = String(describing: type(of: self)).replacingOccurrences(of: "Model", with: "")
        
        return modelName
    }
    
    open func getBundle() -> Bundle? {
        return nil
    }
    
    open func getData() -> Any?{
        return nil
    }
    
    open func isDisable() -> Bool{
        return self.disable
    }
    
    open func setDisable(_ disable: Bool){
        self.disable = disable
        self.updateDataVersion()
    }
    
    public func isDisableInteraction() -> Bool {
        return disableInteraction
    }
    
    public func setDisableInteraction(_ disable: Bool) {
        disableInteraction = disable
    }
    
}

