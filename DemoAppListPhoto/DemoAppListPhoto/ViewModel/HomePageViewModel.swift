//
//  HomePageViewModel.swift
//  DemoAppListPhoto
//
//  Created by Trần Văn Dũng on 4/13/21.
//

import Foundation
import UIKit
import SDWebImage

class HomePageViewModel {
   
    var page:Int = 1
    let totalPage:Int = 10
    var pictureModel:[PictureModel] = []
    var count:Int = 0
    var isLoading:Bool = false
    var isChangeType:Bool = false
    
    func fetchDataHomePage(page:Int,refresh:Bool ,completion: @escaping (_ statusCode:Int) -> Void) {
        if refresh == true {
            self.page = 1
        }
        APIManager.shared.getDataFromAPI(page: page) { [weak self] (pictureModel, statusCode) in
            if let data = pictureModel {
                let dataremovingDuplicates = data.removingDuplicates()
                if refresh == true {
                    self?.pictureModel.removeAll()
                }
                self?.pictureModel.append(contentsOf: dataremovingDuplicates)
                completion(statusCode)
            }
            
            completion(statusCode)
        }

    }
    
    @objc private func loadMoreData(collectionView:UICollectionView){
    
        if !isLoading {
            self.isLoading = true
            self.page += 1
            self.fetchDataHomePage(page: self.page, refresh: false) { (statusCode) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    collectionView.reloadData()
                })
                self.isLoading = false
            }
        }
        
    }
    
    func saveChange() -> Bool {
        let state = UserDefaults.standard.bool(forKey: "change")
        self.isChangeType = state
        return state
    }
    
    func handleSegmentedControlChange(collectionView:UICollectionView) {
        let userDegault = UserDefaults.standard
        self.isChangeType = !self.isChangeType
        userDegault.setValue(self.isChangeType, forKey: "change")
        collectionView.reloadData()
    }
    
    func selectedSegmentedController(refreshController:UISegmentedControl){
        let typeChange = self.saveChange()
        refreshController.selectedSegmentIndex = typeChange ? 1 : 0
    }
}

extension HomePageViewModel {
    
    func cellForItem(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !self.isChangeType {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCell.horizontalCellIdentifier, for: indexPath) as! HorizontalCell
            if self.pictureModel.count != 0 {
                cell.prepareForReuse()
                cell.bindUI(pictureModel: self.pictureModel[indexPath.row])
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.verticalCellIdentifier, for: indexPath) as! VerticalCell
        if self.pictureModel.count != 0 {
            cell.prepareForReuse()
            cell.bindUI(pictureModel: self.pictureModel[indexPath.row])
        }
        return cell
    }
    
    func itemForRow(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pictureModel.count
    }
    
    func sizeForRow(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        if UIDevice.current.userInterfaceIdiom == .pad {
            let orientation = UIApplication.shared.statusBarOrientation
            if !self.isChangeType {
                if(orientation == .landscapeLeft || orientation == .landscapeRight) {
                    return CGSize(width: (UIScreen.main.bounds.width - 40.adaptInch()) / 3, height: 65.adaptInch())
                } else {
                    return CGSize(width: (UIScreen.main.bounds.width - 30.adaptInch()) / 2, height: 65.adaptInch())
                }
            }else {
                if(orientation == .landscapeLeft || orientation == .landscapeRight) {
                    return CGSize(width: (UIScreen.main.bounds.width - 50.adaptInch())/5, height: (120.adaptInch()))
                } else {
                    return CGSize(width: (UIScreen.main.bounds.width - 30.adaptInch())/3, height: (120.adaptInch()))
                }
            }
            
        }
        
        if !self.isChangeType {
            return CGSize.init(width: (UIScreen.main.bounds.width - 20.adaptInch()), height: (130.adaptInch()))
        }else {
            return CGSize.init(width: (UIScreen.main.bounds.width - 30.adaptInch()) / 2, height: collectionView.bounds.height / 3.5)
        }
        
    }
    
    func footerCell(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var cellFooter : UICollectionReusableView? = nil
         
        if kind == UICollectionView.elementKindSectionFooter {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingIndicatorCell.indentifierPagingCell, for: indexPath) as! LoadingIndicatorCell
            cell.spinner.startAnimating()
            cellFooter = cell
        }
       
        return cellFooter ?? UICollectionReusableView()
    }
    
    func sizeForFooter(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if page == totalPage {
            return CGSize(width: 0, height: 0)
        }else {
            return CGSize(width: collectionView.bounds.width, height: 44)
        }
    }
    
    func cellWillDisplay(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if page == totalPage {
            return
        }
        
        if indexPath.row == self.pictureModel.count - 1 && !isLoading {
            self.loadMoreData(collectionView: collectionView)
        }

    }
    
}
