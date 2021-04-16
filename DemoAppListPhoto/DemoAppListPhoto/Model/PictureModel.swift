//
//  PictureModel.swift
//  DemoAppListPhoto
//
//  Created by Trần Văn Dũng on 4/13/21.
//

import Foundation
import UIKit
import CoreData

struct PictureModel: Decodable,Hashable {
    let id: String?
    let author: String?
    let width: Int?
    let height: Int?
    let url: String?
    let download_url: String?

    init(id: String?,
         author: String?,
         width: Int?,
         height: Int?,
         url: String?,
         download_url: String?) {
        
        self.id = id
        self.author = author
        self.width = width
        self.height = height
        self.url = url
        self.download_url = download_url
    }
}




