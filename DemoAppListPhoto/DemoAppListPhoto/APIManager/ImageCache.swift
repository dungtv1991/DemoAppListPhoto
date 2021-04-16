////
////  ImageCache.swift
////  DemoAppListPhoto
////
////  Created by Trần Văn Dũng on 4/14/21.
////
//
//import UIKit
//import RxCocoa
//import RxSwift
//
//enum NetworkManagerError: Error {
//  case badResponse(URLResponse?)
//  case badData
//  case badLocalUrl
//}
//
//class CacheImage {
//    
//    static let shared = CacheImage()
//    
//    private init() {}
//    
//    private var images = NSCache<NSString, NSData>()
//    
//    private func download(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {
//        if let imageData = images.object(forKey: imageURL.absoluteString as NSString) {
//          print("using cached images")
//          completion(imageData as Data, nil)
//          return
//        }
//        
//        let task = URLSession.shared.downloadTask(with: imageURL) { [weak self] localUrl, response, error in
//          if let error = error {
//            completion(nil, error)
//            return
//          }
//          
//          guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//            completion(nil, NetworkManagerError.badResponse(response))
//            return
//          }
//          
//          guard let localUrl = localUrl else {
//            completion(nil, NetworkManagerError.badLocalUrl)
//            return
//          }
//          
//          do {
//            let data = try Data(contentsOf: localUrl)
//            self?.images.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
//            completion(data, nil)
//          } catch let error {
//            completion(nil, error)
//          }
//        }
//        
//        task.resume()
//      }
//    
//    func image(urlString: String, completion: @escaping (Data?, Error?) -> (Void)) {
//        let url = URL(string: urlString)!
//        download(imageURL: url, completion: completion)
//    }
//    
//}
