//
//  Service.swift
//  redBasket
//
//  Created by Salute on 26/08/18.
//  Copyright © 2018 Maharani. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class Service: NSObject{
    
    //MARK: - Shared Instance
    private static var sharedService: Service = {
        let networkManager = Service()
        return networkManager
    }()
    
    class func sharedInstance() -> Service {
        return sharedService
    }
    
    //MARK: - Main API Call
    func getProducts(_ completion:@escaping ((DataSource?, Error?) -> Void)) {
        getProductsService(collection: DataSource(), completion: completion)
        
    }
    
    
    //MARK: - Pagination API Call
    func getPagination(_ collection:DataSource, completion:@escaping ((DataSource?, Error?) -> Void)) {
        collection.redMartAllSalesPagination.pageIndex += 1
        getProductsService(collection: collection, completion: completion)
        
    }
    
    //MARK: - Main API Skeleton
    private func getProductsService(collection:DataSource, completion:@escaping ((DataSource?, Error?) -> Void)) {
        let allSalesAPI = UrlConstants.productListAPI.appending("pageSize=\(collection.redMartAllSalesPagination.pageSize)&Page=\(collection.redMartAllSalesPagination.pageIndex)")
        Alamofire.request(allSalesAPI).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                   let jsonError:NSErrorPointer? = nil
                   let json =  JSON(data)
                    if let jsonError = jsonError {
                        completion(nil, jsonError as? Error)
                    }
                    else {
                        guard let productList = json["products"].array else{
                            return
                        }
                        
                        for productJson in productList {
                            let product = Products(json: productJson)
                            collection.redMartAllSalesProducts.append(product)
                        }
                        completion(collection, nil)
                    }
                }
                
            case.failure(let error):
                completion(nil, error)
            }
        }
    }
}
