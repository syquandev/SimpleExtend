//
//  SimpleIGController.swift
//  SimpleExtend
//
//  Created by Quan on 29/11/2022.
//
import Foundation
import UIKit
import RxSwift
import Core_Main
import IGListKit
import RxCocoa

open class SimpleIGController: UIViewController, ListAdapterDataSource {
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: RefreshControl
    var m_refreshControl: UIRefreshControl?
    open func initCollectionRefresh(){
        self.m_refreshControl = UIRefreshControl(frame: CGRect.zero)
        guard let collection = self.getCollectionView(),
            let refresher = m_refreshControl else{
                return
        }
        collection.addSubview(refresher)
        collection.alwaysBounceVertical = true
        refresher.subviews.first?.frame = CGRect(x: 0, y: 40, width: collection.width, height:0)
        refresher.addTarget(self, action: #selector(self.m_selectorBeginRefresh), for: UIControl.Event.valueChanged)
    }
    
    @objc func m_selectorBeginRefresh() {
        m_refreshControl?.endRefreshing()
        self.refresherDidBegined()
    }
    
    //MARK: - IG ListAdapterDataSource
    
//    static var m_loadingSection = LoadingSectionModel()
    public var adapter: ListAdapter?
    public var sectionsDatas = [BaseSectionModel]()
    var disposed = DisposeBag()
    public var loadNextLastOffset = 0
    
    open func initCollection() {
        guard let collectionView = self.getCollectionView() else{
            return
        }
        //        self.sectionsDatas.append(contentsOf: self.data.getSections())
        let viewController = self
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: viewController, workingRangeSize:5)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        self.adapter = adapter
        
        collectionView.rx.willDisplayCell.subscribe(onNext:{ [weak self] (cell, index) in
            self?.willDisplaySectionIndex(index.section)
            self?.willDisplayIndexPath(index)
        }).disposed(by: disposed)
    }
    //MARK: IG Delegate
    open func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.sectionsDatas
    }
    
    open func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ListSectionController()
    }
    
    open func getSectionDelegate() -> AnyObject{
        return self
    }
    
    open func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    //MARK: - Collection
    
    open func willDisplaySectionIndex(_ sectionIndex: Int){
        let sectionCallIndex = self.sectionsDatas.count - loadNextLastOffset - 1
        if sectionIndex == sectionCallIndex{
            tryLoadNext(sectionIndex)
        }
        //        self.controller.getNextAfterIndex(sectionIndex)
    }
    
    open func willDisplayIndexPath(_ index: IndexPath){
        //        self.controller.getNextAfterIndex(sectionIndex)
    }
    
    open func tryLoadNext(_ sectionIndex: Int){
        
    }
    
    open func getCollectionView() -> UICollectionView?{
        return nil
    }
    
    open func refresherDidBegined(){
        
    }
    
    open func reloadSections(){
        adapter?.reloadData {[weak self] (finished) in
            if finished{
                self?.reloadSectionsComplete()
            }
        }
    }
    
    open func reloadSectionsComplete(){
        
    }
}
