//
//  VerticalCell.swift
//  DemoAppListPhoto
//
//  Created by Trần Văn Dũng on 4/13/21.
//

import UIKit
import SnapKit
import SDWebImage

class VerticalCell: UICollectionViewCell {
    
    static let verticalCellIdentifier:String = "verticalCellIdentifier"
    
    var spinner = UIActivityIndicatorView(style: .gray)
    
    let placeHolderView:UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.alpha = 0.7
        return view
    }()
    
    private let pictureImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let viewLabel:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        self.addSubview(self.pictureImageView)
        self.addSubview(self.viewLabel)
        self.viewLabel.addSubview(self.titleLabel)
        self.viewLabel.addSubview(self.descriptionLabel)
        self.addSubview(self.placeHolderView)
        self.addSubview(self.spinner)
        self.autoLayoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.pictureImageView.image = nil
    }
    
    private func autoLayoutUI(){
        
        self.pictureImageView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            let height = (4 * self.frame.height) / 5
            make.height.equalTo(height - 20.adaptInch())
        }
        
        self.viewLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.pictureImageView.snp.bottom).offset(5.adaptInch())
            make.leading.trailing.equalTo(self.pictureImageView)
            make.bottom.equalToSuperview().offset(-5.adaptInch())
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.viewLabel.snp.top).offset(5.adaptInch())
            make.leading.equalTo(self.viewLabel.snp.leading).offset(5)
            make.trailing.equalTo(self.viewLabel.snp.trailing).offset(-5)
        }
        self.descriptionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.viewLabel.snp.bottom).offset(-5.adaptInch())
            make.leading.equalTo(self.viewLabel.snp.leading).offset(5)
            make.trailing.equalTo(self.viewLabel.snp.trailing).offset(-5)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5.adaptInch())
        }
        self.placeHolderView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.top.equalTo(self.pictureImageView)
        }
        self.spinner.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self.pictureImageView)
        }
        
    }

    func bindUI(pictureModel:PictureModel){
        
        self.autoLayoutUI()
        
        self.pictureImageView.image = nil
        self.spinner.startAnimating()

        if let imageURL = pictureModel.download_url {
            let imageURLArray = imageURL.components(separatedBy: "/")
            let newURLString = imageURLArray[0] + "/" + imageURLArray[1] + "/" + imageURLArray[2] + "/" + imageURLArray[3] + "/" + imageURLArray[4] + "/\(510)/\(382)"
            let transformer = SDImageResizingTransformer(size: CGSize(width: 510, height: 382), scaleMode: .fill)
            SDImageCache.shared.diskImageExists(withKey: pictureModel.id) { isInCache in
                DispatchQueue.main.async {
                    if isInCache {
                        let image = SDImageCache.shared.imageFromDiskCache(forKey: pictureModel.id)
                      
                            self.pictureImageView.image = image
                            self.placeHolderView.isHidden = true
                            self.spinner.stopAnimating()
                            self.layoutIfNeeded()

                    } else {
                            self.pictureImageView.sd_setImage(with: URL(string: newURLString), placeholderImage: nil, context: [.imageTransformer: transformer],progress: nil, completed: { (image, error, cacheType, imageUR) in
                                if let image = image {
                                    SDImageCache.shared.store(image, forKey: pictureModel.id, toDisk: true) {
                                        self.placeHolderView.isHidden = true
                                        self.spinner.stopAnimating()
                                        self.layoutIfNeeded()
                                    }
                                }
                            })
                
                    }
                    
                }
            }
        }
        if let height = pictureModel.height, let witdh = pictureModel.width {
            self.descriptionLabel.text = "Size : \(witdh) x \(height)"
        }
        self.titleLabel.text = pictureModel.author
        
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}
