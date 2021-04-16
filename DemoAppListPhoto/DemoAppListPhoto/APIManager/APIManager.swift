//
//  APIManager.swift
//  DemoAppListPhoto
//
//  Created by Trần Văn Dũng on 4/13/21.
//

import Foundation
import Alamofire

class APIManager {
    
    static let shared = APIManager()
    
    struct BaseURL {
        static let urlString = "https://picsum.photos/v2/list"
    }
    
    private init() {}
    
    func getDataFromAPI(page:Int, completion: @escaping ([PictureModel]?,_ statusCode:Int) -> Void){
        
        guard let url = URL(string: BaseURL.urlString) else {
            return
        }
        
        let parameters:[String:Any] = [
            "page":page,
            "limit":"100"
        ]
        
        AF.request(url,method: .get, parameters: parameters) {$0.timeoutInterval = 60}.responseJSON { response in
            let statusCode = response.response?.statusCode
            switch response.result {
            case .success(_):
                do {
                    if let data = response.data {
                        let result = try JSONDecoder.init().decode([PictureModel].self, from: data)
                        completion(result,statusCode!)
                    }
                }catch {
                    print(error.localizedDescription)
                    completion(nil,statusCode!)
                }
                
            case let .failure(error):
                print(error.localizedDescription)
                completion(nil,statusCode!)
                break
            }
        }
    }
    
}
