//
//  LoadingIndicatorCell.swift
//  DemoAppListPhoto
//
//  Created by Trần Văn Dũng on 4/16/21.
//

import UIKit

class LoadingIndicatorCell : UICollectionReusableView {
    
    static let indentifierPagingCell:String = "PaginationCollectionViewCell"
    
    let viewIndicator = UIView()
    let spinner = UIActivityIndicatorView(style: .gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(viewIndicator)
        viewIndicator.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(10.adaptInch())
        }
        viewIndicator.addSubview(spinner)
        spinner.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
