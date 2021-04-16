//
//  ServiceCoreData.swift
//  DemoAppListPhoto
//
//  Created by Trần Văn Dũng on 4/14/21.
//

import Foundation
import UIKit

class ServiceCoreData {
    
    static let shared = ServiceCoreData()
    
    private init() {}
    
}

class PicturesSave: NSObject {
    var id: String = ""
    var author: String = ""
    var width: Int = 0
    var height: Int = 0
    var url: String = ""
    var download_url: Data?
}
