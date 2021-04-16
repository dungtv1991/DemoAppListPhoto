//
//  DataPictures+CoreDataProperties.swift
//  
//
//  Created by Trần Văn Dũng on 4/14/21.
//
//

import Foundation
import CoreData


extension DataPictures {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataPictures> {
        return NSFetchRequest<DataPictures>(entityName: "DataPictures")
    }

    @NSManaged public var download_url: Data?
    @NSManaged public var url: String?
    @NSManaged public var height: Int64
    @NSManaged public var width: Int64
    @NSManaged public var author: String?
    @NSManaged public var id: String?

}
