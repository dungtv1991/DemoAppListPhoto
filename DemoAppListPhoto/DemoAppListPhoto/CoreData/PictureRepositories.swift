////
////  PictureRepositories.swift
////  DemoAppListPhoto
////
////  Created by Trần Văn Dũng on 4/14/21.
////
//
//import Foundation
//import MagicalRecord
//
//class ProductRepository: NSObject {
//
//    
//    
//    func addProduct(pictures: PicturesSave) {
//        MagicalRecord.saveUsingCurrentThreadContext { (context) -> Void in
//            let entity = DataPictures.mr_create(in: context)
//            entity?.id = pictures.id
//            entity?.author = pictures.author
//            entity?.height = Int64(pictures.height)
//            entity?.width = Int64(pictures.width)
//            entity?.url = pictures.url
//            entity?.download_url = pictures.download_url
//        }
//    }
//
//    func updateProduct(pictures: PicturesSave) {
//        MagicalRecord.saveUsingCurrentThreadContext { (context) -> Void in
//            let predicate = NSPredicate(format: "id = '\(pictures.id)'")
//            if let entity = DataPictures.mr_findFirst(with: predicate, in: context) {
//                entity.id = pictures.id
//                entity.author = pictures.author
//                entity.height = Int64(pictures.height)
//                entity.width = Int64(pictures.width)
//                entity.url = pictures.url
//                entity.download_url = pictures.download_url
//            }
//        }
//    }
//
//    func deleteProduct(pictureId: String) {
//        MagicalRecord.saveUsingCurrentThreadContext { (context) -> Void in
//            let predicate = NSPredicate(format: "id = '\(pictureId)'")
//            DataPictures.mr_deleteAll(matching: predicate, in: context)
//        }
//    }
//
//    func getProductById(productId: String) -> DataPictures? {
//        var context = NSManagedObjectContext.mr_contextForCurrentThread()
//        let predicate = NSPredicate(format: "id = '\(productId)'")
//        if let product = DataPictures.mr_findFirst(with: predicate, in: context) {
//            return product
//        }
//        return nil
//    }
//
//    func getProducts() -> [DataPictures]? {
//        let context = NSManagedObjectContext.mr_contextForCurrentThread()
//
//        if let products = DataPictures.mr_findAll(in: context) as? [DataPictures]? {
//            return products
//        }
//        return nil
//    }
//}
