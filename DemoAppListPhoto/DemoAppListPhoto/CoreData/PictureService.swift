////
////  PictureService.swift
////  DemoAppListPhoto
////
////  Created by Trần Văn Dũng on 4/14/21.
////
//
//import Foundation
//
//class ProductService: NSObject {
//    
//    private var productRepository = ProductRepository()
//
//    func addProduct(product: PicturesSave) {
//        productRepository.addProduct(pictures: product)
//    }
//
//    func updateProduct(product: PicturesSave) {
//        productRepository.updateProduct(pictures: product)
//    }
//
//    func deleteProduct(productId: String) {
//        productRepository.deleteProduct(pictureId: productId)
//    }
//
//    func getProductById(productId: String) -> PicturesSave? {
//        if let entity = productRepository.getProductById(productId: productId) {
//            let product = PicturesSave()
//            product.id = entity.id ?? "0"
//            product.author = entity.author ?? ""
//            product.url = entity.url ?? ""
//            product.height = Int(entity.height)
//            product.width = Int(entity.width)
//            product.download_url = entity.download_url
//        }
//        return nil
//    }
//
//    func getProducts() -> [PicturesSave] {
//        var products = [PicturesSave]()
//        if let entities = productRepository.getProducts() {
//            for entity in entities {
//                let product = PicturesSave()
//                product.id = entity.id ?? "0"
//                product.author = entity.author ?? ""
//                product.url = entity.url ?? ""
//                product.height = Int(entity.height)
//                product.width = Int(entity.width)
//                product.download_url = entity.download_url
//                products.append(product)
//            }
//        }
//        return products
//    }
//}
