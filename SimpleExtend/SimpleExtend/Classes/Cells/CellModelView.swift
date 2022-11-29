//
//  CellModelView.swift
//  SimpleExtend
//
//  Created by Quan on 29/11/2022.
//

import Foundation
import UIKit

public protocol CellModelViewInterface: class {
    func setCellModel(_ cellModel: Any?)
    func setSectionController(_ sectionController: SectionControllerInterface?)
    func update()
    func willDisplay()
    func didEndDisplaying()
    func setError(_ error: String?)
}


open class CellModelView<T:CellModelInterface>: UICollectionViewCell, CellModelViewInterface {
    
    
    var compactMode = false
    weak var bottomSeperatorLineView: UIView?
    weak var topSeperatorLineView: UIView?
    public weak var sectionController: SectionControllerInterface?
    
//    weak var cellModel:T?
    var cellModel:T?
    
    public var isDisplay: Bool = false
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc func _copyCellName(sender: UIButton!) {
        let name = String(describing: type(of: self))
        UIPasteboard.general.string = name
    }
    
    
    private var _errorButton: UIButton?
    public func setError(_ error: String?){
        guard let error = error else{
            _errorButton?.isHidden = true
            return
        }
        
        if _errorButton == nil{
            _errorButton = UIButton()
            _errorButton?.isUserInteractionEnabled = false
            self.addSubview(_errorButton!)
            _errorButton?.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            _errorButton?.setTitleColor(UIColor.red, for: [])
            let cellModel = self.cellModel as? BaseCellModel
            let side: CGFloat = (cellModel?.leftSpace ?? 0) + 16
            
            if cellModel?.errorMessageType == ErrorMessageType.centerText ||
                cellModel?.errorMessageType == ErrorMessageType.rightText{
                _errorButton?.pinTrailingToView(self, constant: -side)
            }
            
            if cellModel?.errorMessageType == ErrorMessageType.centerText ||
                cellModel?.errorMessageType == ErrorMessageType.leftText{
                _errorButton?.pinLeadingToView(self, constant: side)
            }
            _errorButton?.pinBottomToView(self)
            _errorButton?.pinHeightFixedTo(constant: 20)
        }
        _errorButton?.isHidden = false
        _errorButton?.setTitle(error, for: [])
    }
    open func bindCellModel(_ cellModel: T){
        cellModel.setCellView(self)
        self.contentView.alpha = cellModel.isDisable() ? 0.5 : 1
        self.isUserInteractionEnabled = !cellModel.isDisable()
        self.cellModel = cellModel
        self.setCompactMode(cellModel.getCompactMode())
        
        self.layoutIfNeeded()
        
        if cellModel.showBottomLine(){
            if self.bottomSeperatorLineView == nil{
                let line = UIView.init(frame: CGRect(x: 0, y: self.bounds.size.height - 1, width: self.bounds.size.width, height: 1))
                line.backgroundColor = .lightGray
                self.addSubview(line)
                line.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
                self.bottomSeperatorLineView = line
            }
        }else{
            self.bottomSeperatorLineView?.removeFromSuperview()
        }
        
        if cellModel.showTopLine(){
            if self.topSeperatorLineView == nil{
                let line = UIView.init(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 1))
                line.backgroundColor = .lightGray
                self.addSubview(line)
                line.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
                self.topSeperatorLineView = line
            }
        }else{
            self.topSeperatorLineView?.removeFromSuperview()
        }
        if cellModel.isDisableInteraction(){
            self.isUserInteractionEnabled = false
        }
        updateSideConstraint(cellModel)
        
        self.setError(cellModel.getError())
    }
    
    open func updateSideConstraint(_ cellModel: T){
        guard let cell = cellModel as? BaseCellModel else{
            return
        }
//        if !cell.enableSideConstraint{
//            return
//        }
        if let cst = self.getContainerLeftCst(){
            if cst.constant != cell.leftSpace{
                cst.constant = cell.leftSpace
            }
        }
        if let cst = self.getContainerRightCst(){
            if cst.constant != cell.rightSpace{
                cst.constant = cell.rightSpace
            }
        }
        if let cst = self.getContainerBottomCst(){
            if cst.constant != cell.bottomSpace{
                cst.constant = cell.bottomSpace
            }
        }
        if let cst = self.getContainerTopCst(){
            if cst.constant != cell.topSpace{
                cst.constant = cell.topSpace
            }
        }
    }
    
    open func setCellModel(_ cellModel: Any?) {
        if let cellModel = cellModel as? T {
            self.bindCellModel(cellModel)
        }
    }
    
    open func setSectionController(_ sectionController: SectionControllerInterface?) {
        self.sectionController = sectionController
        if let delegate = sectionController{
            self.setCustomDelegate(delegate)
        }
    }
    
    open func setCompactMode(_ mode: Bool){
        if mode != self.compactMode {
            self.compactMode = mode
            
            if let containerView = self.viewWithTag(119){
                if let containerSuperView = containerView.superview{
                    var trailing: NSLayoutConstraint?
                    var leading: NSLayoutConstraint?
                    for cts in containerSuperView.constraints{
                        if cts.identifier == "ctnl"{
                            leading = cts
                        }
                        if cts.identifier == "ctnt"{
                            trailing = cts
                        }
                        
                    }
                    if self.compactMode {
                        containerView.leftLineColor = UIColor.lightGray
                        containerView.rightLineColor = UIColor.lightGray
                        leading?.constant = 16
                        trailing?.constant = 16
                    }else{
                        
                        containerView.leftLineColor = UIColor.clear
                        containerView.rightLineColor = UIColor.clear
                        leading?.constant = 0
                        trailing?.constant = 0
                    }
                }
                
            }
        }
    }
    
    
    open func willDisplay() {
        self.isDisplay = true
    }
    
    open func didEndDisplaying() {
        self.isDisplay = false
        
    }
    
    open func getCellModel() -> T?{
        return self.cellModel
    }
    
    open func setCustomDelegate(_ section: Any){
        
    }
    open func update(){
        if let cellModel = self.cellModel{
            self.setCellModel(cellModel)
        }
    }
    
    
    open func getCellIndex(){
        
    }
    
    
    open func getContainerView() -> UIView?{
        return nil
    }
    
    
    weak var m_leftCst: NSLayoutConstraint?
    
    open func getContainerLeftCst() -> NSLayoutConstraint?{
        guard let view = self.subviews.first else{
            return nil
        }
        if m_leftCst == nil {
            m_leftCst =  view.constraints.first { (item) -> Bool in
                return item.identifier == "left"
            }
        }
        
        return m_leftCst
    }
    
    weak var m_rightCst: NSLayoutConstraint?
    
    open func getContainerRightCst() -> NSLayoutConstraint?{
        guard let view = self.subviews.first else{
            return nil
        }
        if m_rightCst == nil {
            m_rightCst = view.constraints.first { (item) -> Bool in
                return item.identifier == "right"
            }
        }
        
        return m_rightCst
    }
    
    weak var m_topCst: NSLayoutConstraint?
    
    open func getContainerTopCst() -> NSLayoutConstraint?{
        guard let view = self.subviews.first else{
            return nil
        }
        if m_topCst == nil {
            m_topCst = view.constraints.first { (item) -> Bool in
                return item.identifier == "top"
            }
        }
        
        return m_topCst
    }
    
    weak var m_bottomCst: NSLayoutConstraint?
    
    open func getContainerBottomCst() -> NSLayoutConstraint?{
        guard let view = self.subviews.first else{
            return nil
        }
        if m_bottomCst == nil {
            m_bottomCst =  view.constraints.first { (item) -> Bool in
                return item.identifier == "bottom"
            }
        }
        return m_bottomCst
    }
    
    open func didSelectedMe(){
        if let collection = self.getParentCollectionView(){
            if let index = collection.indexPath(for: self){
                collection.delegate?.collectionView?(collection, didSelectItemAt: index)
            }
        }
    }
    
    public func getCellIndexPath() -> IndexPath?{
        
        if let collection = self.getParentCollectionView(){
            
            if let index = collection.indexPath(for: self){
                return index
            }
        }
        
        return nil
    }
    public func getParentCollectionView() -> UICollectionView?{
        
        var superview = self.superview
        
        while true {
            if let collection = superview as? UICollectionView{
                return collection
            }
            superview = superview?.superview
            if superview == nil {
                break
            }
        }
        return nil
    }
}

