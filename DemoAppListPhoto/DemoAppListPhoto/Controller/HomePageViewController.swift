//
//  ViewController.swift
//  DemoAppListPhoto
//
//  Created by Trần Văn Dũng on 4/13/21.
//

import UIKit
import SnapKit
import AdaptationKit
import SDWebImage

class HomePageViewController: UIViewController {

    var isChangeType:Bool = false

    var refresher:UIRefreshControl!
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(VerticalCell.self, forCellWithReuseIdentifier: VerticalCell.verticalCellIdentifier)
        collectionView.register(HorizontalCell.self, forCellWithReuseIdentifier: HorizontalCell.horizontalCellIdentifier)
        collectionView.register(LoadingIndicatorCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingIndicatorCell.indentifierPagingCell)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Regular", "Compact"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmentedControlChange), for: .valueChanged)
        return sc
    }()
    
    let failedLoadingLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let homePageViewModel = HomePageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.selectedSegmentedController()
        
        self.fetchData(pullToRefresh: false)
        
        self.view.backgroundColor = .white
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.collectionView)
        
        self.configCollectionView()
        self.setNotificationObserverRotate()
        self.setUpToRefresh()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.autoLayoutUI()
        
    }
    
    private func autoLayoutUI(){
        self.segmentedControl.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            } else {
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            make.centerX.equalToSuperview()
            make.width.equalTo((self.view.bounds.width - 60.adaptInch()))
            make.height.equalTo(30.adaptInch())
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(20.adaptInch())
            make.leading.equalToSuperview().offset(10.adaptInch())
            make.trailing.equalToSuperview().offset(-10.adaptInch())
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0.adaptInch())
            } else {
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(0.adaptInch())
            }
        }
    }
    
    private func selectedSegmentedController(){
        self.isChangeType = self.homePageViewModel.saveChange()
        self.segmentedControl.selectedSegmentIndex = self.isChangeType ? 1 : 0
    }
    
    private func setNotificationObserverRotate(){
        let deviceCurrent =  UIDevice.current.userInterfaceIdiom
        if deviceCurrent == .pad {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(orientationChanged(notification:)),
                    name: UIDevice.orientationDidChangeNotification,
                    object: nil)
        }
    }
    
    private func configCollectionView(){
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.isScrollEnabled = true
    }

    private func setUpToRefresh(){
        self.refresher = UIRefreshControl()
        self.collectionView.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.gray
        self.refresher.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.collectionView.addSubview(refresher)
    }
    
    @objc private func pullToRefresh(){
        self.fetchData(pullToRefresh: true)
    }
    
    @objc private func fetchData(pullToRefresh:Bool){
        self.homePageViewModel.fetchDataHomePage(page: 1,refresh: pullToRefresh) {[weak self] (statusCode) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                if pullToRefresh == true {
                    self.refresher.endRefreshing()
                }
                self.hideShowUI(statusCode: statusCode)
            }
        }
    }
    
    @objc func handleSegmentedControlChange() {
        let userDegault = UserDefaults.standard
        self.isChangeType = !self.isChangeType
        userDegault.setValue(self.isChangeType, forKey: "change")
        self.collectionView.reloadData()
    }
    
    @objc func orientationChanged(notification : NSNotification) {
        self.collectionView.isUserInteractionEnabled = true
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func hideShowUI(statusCode:Int){
        
        if statusCode != 200 {
            self.failedLoadingLabel.sizeToFit()
            self.view.addSubview(self.failedLoadingLabel)
            self.failedLoadingLabel.text = "Failed loading images. Http code: \(statusCode)"
            self.failedLoadingLabel.center = self.view.center
            self.collectionView.isHidden = true
            return
        }else {
            DispatchQueue.main.async {
                self.failedLoadingLabel.removeFromSuperview()
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }
        }
        
    }

}

extension HomePageViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homePageViewModel.itemForRow(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.homePageViewModel.cellForItem(collectionView, cellForItemAt: indexPath, isChangeType: self.isChangeType)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.homePageViewModel.sizeForRow(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath, isChangeType: !self.isChangeType)
    }
 
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return self.homePageViewModel.footerCell(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return self.homePageViewModel.sizeForFooter(collectionView, layout: collectionViewLayout, referenceSizeForFooterInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.homePageViewModel.cellWillDisplay(collectionView, willDisplay: cell, forItemAt: indexPath) 
    }
    
}


