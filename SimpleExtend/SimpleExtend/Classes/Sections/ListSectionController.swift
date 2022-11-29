//
//  ListSectionController.swift
//  SimpleExtend
//
//  Created by Quan on 29/11/2022.
//

import Foundation
import UIKit
import IGListKit

extension ListSectionController{
    
    
    public func invalidateSection(){
        self.collectionContext?.invalidateLayout(for: self, completion: nil)
    }
    
    public func reloadSection(animated: Bool = true){
        if let section = self as? SectionControllerInterface{
            section.reloadSection(animated: animated, completion: nil)
        }else{
            self.collectionContext?.performBatch(animated: animated, updates: { (context) in
                context.reload(self)
            }, completion: nil)
        }
    }
    
    
    public func reloadCell(index: Int, animated: Bool) {
        self.reloadCell(index: index, animated: animated, completion: nil)
    }
    
    public func reloadCell(index: Int, animated: Bool = false, completion: ((Bool) -> Void)?){
        self.reloadCells(indexs: [index], animated: animated, completion: completion)
    }
    
    
    
    public func reloadCells(indexs: [Int], animated: Bool) {
        self.reloadCells(indexs: indexs, animated: animated, completion: nil)
    }
    
    
    public func reloadCells(indexs: [Int], animated: Bool = false, completion: ((Bool) -> Void)?){
        for index in indexs{
            if index < 0 {
                return
            }
        }
        if let section = self as? SectionControllerInterface{
            let cells = section.getCellModels()
            indexs.forEach { (index) in
                cells.objectAtIndex(index)?.clearData()
            }
        }
        let indexSet = IndexSet(indexs)
//        self.collectionContext?.performBatch(animated: animated, updates: { (context) in
//            context.reload(in: self, at: indexSet)
//        }, completion: nil)
        self.collectionContext?.performBatch(animated: animated, updates: { (context) in
            context.reload(in: self, at: indexSet)
        }, completion: completion)
    }
}


open class SectionController<T:BaseSectionModel>: ListSectionController, SectionControllerInterface, ListDisplayDelegate, ListSupplementaryViewSource{

    public var cellBuilder: CellBuilderInterface?
    public weak var sectionModel: T?
    public var cellModels: [CellModelInterface] = []
    public weak var presenter: AnyObject?
    public var updateObjectCountTrack = 0
    public var sectionDisplayCount = 0
    
    
    public override init() {
        super.init()
        self.cellBuilder = self.getCellBuilder()
        self.customInit()
        self.displayDelegate = self
        supplementaryViewSource = self
    }
    
//    func scrollToItem(to listSectonController: ListSectionController, position: UICollectionViewScrollPosition, animated: Bool, at: Int) {
//        collectionContext?.scroll(to: listSectonController, at: at, scrollPosition: position, animated: animated)
//    }
    
    open func customInit(){
        
    }
    
    
//    deinit {
//        Log.console("\(String(describing: self)) ===> deinit")
//    }

    
    open func getCellBuilder() -> CellBuilderInterface?{
        return BaseCellBuilder()
    }
    // MARK: - SectionControllerInterface
    // custom set prensenter delegate
    open func setPresenter(_ presenter: AnyObject?){
        self.presenter = presenter
    }
    
    public func getCellModels() -> [CellModelInterface] {
        return self.cellModels
    }
    
    public func getPresenter() -> AnyObject? {
        return self.presenter
    }
    open func getSectionController() -> ListSectionController{
        return self
    }
    
    open func getSectionModel() -> Any?{
        return self.sectionModel
    }
    
    public func cellModelAtIndex(_ index:Int) -> CellModelInterface? {
        return self.cellModels.objectAtIndex(index)
    }
    
    public func reloadCellByDIffID(_ diffID: String?, animated: Bool = false){
        if let index = self.cellModelIndexByDiffID(diffID){
            self.reloadCell(index: index, animated: animated)
        }
    }
    
    public func cellModelByDiffID(_ diffID: String?) -> CellModelInterface? {
        guard let diffID = diffID else{
            return nil
        }
        let cells = self.getCellModels()
        
        for cell in cells{
            if cell.getDiffID() == diffID{
                return cell
            }
        }
        
        return nil
    }
    public func cellModelIndexByDiffID(_ diffID: String?) -> Int? {
        guard let diffID = diffID else{
            return nil
        }
        let cells = self.getCellModels()
        var count = 0
        for cell in cells{
            if cell.getDiffID() == diffID{
                return count
            }
            count += 1
        }
        
        return nil
    }
    
    public func indexOf(cellModel: CellModelInterface?) -> Int? {
        guard let cellModel = cellModel else{
            return nil
        }
        return self.cellModels.indexOfObject(cellModel)
    }
    public func indexOf(dataModel: BaseModel?) -> Int? {
        guard let dataModel = dataModel else{
            return nil
        }
        var index = 0
        for item in self.cellModels{
            if let itemModel = item.getDataModel() as? BaseModel{
                if itemModel == dataModel {
                    return index
                }
            }
            index += 1
        }
        return nil
    }
    
    
    public func indexOf(diffID: String?) -> Int? {
        guard let diffID = diffID else{
            return nil
        }
        var index = 0
        for item in self.cellModels{
            if item.getDiffID() == diffID{
                return index
                
            }
            index += 1
        }
        return nil
    }
    
    public func reloadCellByDiffID(_ diffID: String?, animated: Bool = false) {
        if let index = self.cellModelIndexByDiffID(diffID){
            self.reloadCell(index: index, animated: animated)
        }
    }
    
    public func reloadCell(cellModel: CellModelInterface?, animated: Bool = false) {
        self.reloadCell(cellModel: cellModel, animated: animated, completion: nil)
    }
    
    
    public func reloadCell(cellModel: CellModelInterface?, animated: Bool, completion: ((Bool) -> Void)?) {
        if let index = self.indexOf(cellModel: cellModel){
            self.reloadCell(index: index, animated: animated, completion: completion)
        }
        
    }
    
    public func reloadCells(cellModels: [CellModelInterface], animated: Bool = false) {
        self.reloadCells(cellModels: cellModels, animated: animated, completion: nil)
        
    }
    public func reloadCells(cellModels: [CellModelInterface], animated: Bool, completion: ((Bool) -> Void)?) {
        
        var indexs = [Int]()
        
        cellModels.forEach { (item) in
            if let index = self.indexOf(cellModel: item){
                indexs.append(index)
            }
        }
        if indexs.count > 0 {
            self.reloadCells(indexs: indexs, animated: animated, completion: completion)
        }
    }
    
    
    public func reloadCell(diffID: String?){
        guard let diffID = diffID else{
            return
        }
        if let index = self.indexOf(diffID: diffID){
            self.collectionContext?.performBatch(animated: true, updates: { (context) in
                context.reload(in: self, at: IndexSet(integer: index))
            }, completion: nil)
        }
    }
    
    public func refreshSection(animated: Bool){
        self.refreshSection(animated: animated, completion: nil)
    }
    
    public func refreshSection(animated: Bool, completion: ((Bool) -> Void)?){
        
        self.reloadSection(animated: animated, completion: completion)
    }
    
    public func reloadSection(animated: Bool, completion: ((Bool) -> Void)?){
        
        self.parseCellModels()
        self.collectionContext?.performBatch(animated: animated, updates: { (context) in
            context.reload(self)
        }, completion: completion)
    }
    
    public func updateSection(){
        self.updateSection(animated: true)
    }
    
    public func insertLastCell(_ cell: CellModelInterface?, animated: Bool = false){
        let index = cellModels.count
        self.insertCell(cell, index: index, animated: animated)
    }
    
    public func insertCell(_ cell: CellModelInterface?, index: Int, animated: Bool = false){
        guard let cell = cell else{
            return
        }
        if index < 0 {
            return
        }
        
        if cellModels.count < index{
            return
        }
        cell.setSectionController(self)
        cellModels.insert(cell, at: index)
        let indxs = IndexSet([index])
        
        self.collectionContext?.performBatch(animated: animated, updates: { (context) in
            context.insert(in: self, at: indxs)
        }, completion: nil)
    }
    public func removeCell(_ cell: CellModelInterface?, animated: Bool = false){
        if cell == nil{
            return
        }
        
        for i in 0..<cellModels.count{
            
            if cellModels.objectAtIndex(i) === cell{
                removeCellIndex(i, animated: animated)
                return
            }
        }
    }
    
    public func removeCellIndex(_ index: Int, animated: Bool = false){
        if index < 0 || index >= cellModels.count {
            return
        }
        
        if cellModels.count < index{
            return
        }
        cellModels.remove(at: index)
        let indxs = IndexSet([index])
        
        self.collectionContext?.performBatch(animated: animated, updates: { (context) in
            context.delete(in: self, at: indxs)
        }, completion: nil)
    }
    
    public func updateSection(animated: Bool){
        self.updateSection(animated:animated, completion: nil)
    }
    
    public func updateSection(animated: Bool, completion: ((Bool) -> Void)?){
        
        var oldArray: [CellModelInterface] = []
        oldArray.safeAppend(sequence: self.cellBuilder?.getCellModels())
        
        self.parseCellModels()
        
        var newArray: [CellModelInterface] = []
        newArray.safeAppend(sequence: self.cellBuilder?.getCellModels())
//         Những cell model cũ vẫn phải giữ lại, vì nó đang được sử dụng để hiển thị ở section
        var merges: [CellModelInterface] = []
        for n in newArray{
            var add = true
            for o in oldArray{
                if n.getDiffID() == o.getDiffID(){
                    merges.append(o)
                    add = false
                    break
                }
            }
            if add{
                merges.append(n)
            }
        }
        self.cellModels = merges
        self.collectionContext?.performBatch(animated: animated, updates: { (context) in
            context.reload(self)
        }, completion: completion)
        
// Hiện tại function này không thể detect đc model nào là updates!!!
        /*
        let diff = ListDiff(oldArray: oldArray, newArray: self.cellModels, option: .equality)
        let deletes = diff.deletes
        let inserts = diff.inserts
        let updates = diff.updates
        let moves = diff.moves

        Log.console("collectionContext?.performBatch =================")
        Log.console("collectionContext?.performBatch OLD==============")
        oldArray.forEach { (cell) in
            Log.console("collectionContext?.performBatch \(cell.getDiffID())")
        }
        Log.console("collectionContext?.performBatch NEW==============")
        cellModels.forEach { (cell) in
            Log.console("collectionContext?.performBatch \(cell.getDiffID())")
        }

        Log.console("collectionContext?.performBatch updates \(updates.count)")
        Log.console("collectionContext?.performBatch deletes \(deletes.count)")
        Log.console("collectionContext?.performBatch inserts \(inserts.count)")
        Log.console("collectionContext?.performBatch moves \(moves.count)")
        
        self.collectionContext?.performBatch(animated: animated, updates: { (context) in
            context.reload(in: self, at: updates)
            context.delete(in: self, at: deletes)
            context.insert(in: self, at: inserts)
            moves.forEach({ (index) in
                context.move(in: self, from: index.from, to: index.to)
            })
        }, completion: completion)
 */
    }
    public func updateSectionOld(animated: Bool, completion: ((Bool) -> Void)?){
        var oldArray: [CellModelInterface] = []
        oldArray.safeAppend(sequence: self.cellBuilder?.getCellModels())
        
        var needUpdates: [Int] = []
        var count = 0
        for item in oldArray{
            if item.isNeedUpdate(){
                needUpdates.append(count)
            }
            count += 1
        }
        if needUpdates.count > 0{
            let indexset = IndexSet(needUpdates)
            self.collectionContext?.performBatch(animated: animated, updates: { (context) in
                context.reload(in: self, at: indexset)
            }, completion: { (finished) in
                self.updateSectionWithOutUpdate(animated: animated, completion: completion)
            })
        }else{
            self.updateSectionWithOutUpdate(animated: animated, completion: completion)
        }
    }
    
    func updateSectionWithOutUpdate(animated: Bool, completion: ((Bool) -> Void)? = nil){
        
        var oldArray: [CellModelInterface] = []
        oldArray.safeAppend(sequence: self.cellBuilder?.getCellModels())
        
        self.parseCellModels()
        
        var newArray: [CellModelInterface] = []
        newArray.safeAppend(sequence: self.cellBuilder?.getCellModels())
        
        var merges: [CellModelInterface] = []
        for n in newArray{
            var add = true
            for o in oldArray{
                if n.getDiffID() == o.getDiffID(){
                    merges.append(o)
                    add = false
                    break
                }
            }
            if add{
                merges.append(n)
            }
        }
        self.cellModels = merges
        
        
        let diff = ListDiff(oldArray: oldArray, newArray: self.cellModels, option: .equality)
        let deletes = diff.deletes//self.createIndexSetFromPaths(diff.deletes)
        let inserts = diff.inserts//self.createIndexSetFromPaths(diff.inserts)
        let updates = diff.updates//self.createIndexSetFromPaths(diff.updates)
        
        let deleteArray = Array(deletes)
        for item in deleteArray{
            if item > (oldArray.count - 1) || item < 0{
                return
            }
        }
        let updateArray = Array(updates)
        for item in updateArray{
            if item > (merges.count - 1) || item < 0{
                return
            }
        }
        
        self.collectionContext?.performBatch(animated: animated, updates: { (context) in
            //            context.reload(self)
            context.delete(in: self, at: deletes)
            context.insert(in: self, at: inserts)
            context.reload(in: self, at: updates)
        }, completion: completion)
    }
    
    public func createIndexSetFromPaths(_ paths: [IndexPath]) -> IndexSet{
        let cmp = paths.compactMap { (item) -> Int? in
            return item.item
        }
        let set = IndexSet(cmp)
        return set
    }
    
    public func parseCellModels(){
        self.cellBuilder?.clearCellModels()
        self.cellBuilder?.parseCellModels()
        if let cellModels = self.cellBuilder?.getCellModels(){
            self.cellModels = cellModels
        }
    }
    
    
    // MARK: - Datasources
    open override func didUpdate(to object: Any) {
        self.sectionModel = object as? T
        self.cellBuilder?.setSectionModel(self.sectionModel, sectionController: self)
        self.parseCellModels()
        if let obj = self.sectionModel{
            self.didUpdateSectionModel(obj)
            self.updateObjectCountTrack += 1
        }
    }
    
    open func didUpdateSectionModel(_ object: T){
        
    }
    
    open override func numberOfItems() -> Int {
        return cellModels.count;
    }
    
    open override func sizeForItem(at index: Int) -> CGSize {
        let inset = collectionContext!.containerInset
        let orgWidth = collectionContext!.containerSize.width - inset.left - inset.right
        guard let cellModel = self.cellModels.objectAtIndex(index) as? BaseCellModel else{
            return CGSize(width: orgWidth, height: 0)
        }
        let maxWidth = orgWidth - cellModel.leftSpace - cellModel.rightSpace
        
        let height = cellModel.getCellHeight(maxWidth: maxWidth) + cellModel.topSpace + cellModel.bottomSpace
        var width = cellModel.getCellWidth(maxWidth: maxWidth)
        if width < 0 {
            width = orgWidth
        }
        return CGSize(width: width, height: height)
    }
    
    open override func cellForItem(at index: Int) -> UICollectionViewCell {
//        Log.console("open override func cellForItem")
        let cellModel = self.cellModels.objectAtIndex(index)!
        let cellName = cellModel.getCellName()
        let bundle = cellModel.getBundle()
        let cellView = collectionContext!.dequeueReusableCell(withNibName: cellName, bundle: bundle, for: self, at: index)
        
        if let cellViewInterface = cellView as? CellModelViewInterface{
            cellViewInterface.setCellModel(cellModel)
            cellViewInterface.setSectionController(self)
        }
        return cellView
    }
    
    public func cellForClass(_ clx: AnyClass) -> UICollectionViewCell? {
        let total = self.numberOfItems()
        for idx in 0..<total{
            let cell = cellForItem(at: idx)
            if cell.isKind(of: clx) {
                return cell
            }
        }
        return nil
    }
    
    public func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        self.sectionWillDisplay()
        self.sectionDisplayCount += 1
    }
    
    public func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {
        self.sectionDidEndDisplaying()
    }
    
    public func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        self.sectionWillDisplay()
        self.sectionDisplayCount += 1
        if let baseCell = cell as? CellModelViewInterface{
            baseCell.willDisplay()
        }
    }
    
    public func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        self.sectionDidEndDisplaying()
        if let baseCell = cell as? CellModelViewInterface{
            baseCell.didEndDisplaying()
        }
    }
    
    open func sectionWillDisplay(){
        
    }
    
    open func sectionDidEndDisplaying(){
        
    }
    
    //MARK: - Debug Header
    //https://github.com/Instagram/IGListKit/blob/master/Examples/Examples-iOS/IGListKitExamples/SectionControllers/FeedItemSectionController.swift
    public func supportedElementKinds() -> [String] {
        return [UICollectionElementKindSectionHeader]
    }
    
    public func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, for: self, class: _SectionDebugLabelView.self, at: index) as? _SectionDebugLabelView else{
            fatalError()
        }
        view.button?.setTitle("\t" + String(describing: type(of: self)), for: [])
        return view
    }
    
    public func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 20)
    }
    
    
}

class _SectionDebugLabelView: UICollectionViewCell {
    var button: UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)

        let button = UIButton(frame: frame)
        button.alpha = 0.5
        button.isUserInteractionEnabled = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: [])
        button.addTarget(self, action: #selector(_copySectionName), for: .touchUpInside)
        
        self.addSubViewAndBoundMaskPin(button)
        self.button = button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func _copySectionName(sender: UIButton!) {
        let name = button?.titleLabel?.text?.replacingOccurrences(of: "\t", with: "")
        UIPasteboard.general.string = name
    }
    
}

