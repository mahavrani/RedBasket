//
//  Products.swift
//  redBasket
//
//  Created by Salute on 26/08/18.
//  Copyright © 2018 Maharani. All rights reserved.
//

import UIKit
import SwiftyJSON


class Products: NSObject{
    
    //MARK: - Model Class Variables
    var id: String?
    var sku: String?
    var status: Int?
    var title: String?
    var details: String?
    var coverImage:String?
    var images = [String]()
    var lifeTime: String?
    var price: String?
    var merchantName : String?
    var merchantLogo : String?
    var stockStatus: Int?
    var stockMeasure: String?
    
    //MARK: - Init
    init(json: JSON){
        super.init()
        id = json["id"].stringValue
        sku = json["sku"].stringValue
        status = json["details"]["status"].int
        title = json["title"].stringValue
        details = json["desc"].stringValue
        coverImage = UrlConstants.productImageAPI.appending(json["img"]["name"].stringValue)
        lifeTime = "\(String(describing: json["product_life"]["time"].int))" + json["products"]["product_life"]["metric"].stringValue
        price = "$"+json["pricing"]["price"].stringValue
        merchantName = json["merchant"]["sub_vendor_name"].stringValue
        merchantLogo = UrlConstants.productImageAPI.appending(json["merchant"]["sub_vendor_logo"]["name"].stringValue)
        stockStatus = json["inventory"]["stock_status"].int
        stockMeasure = json["measure"]["wt_or_vol"].stringValue
        if let imageList = json["images"].array{
            for image in imageList {
                images.append(UrlConstants.productImageAPI.appending(image["name"].stringValue))
            }
        }else{
            images = []
        }
    }
    
    //MARK: - Clear Data
    func clear() {
        id = ""
        sku = ""
        status = 0
        title = ""
        details = ""
        coverImage = ""
        images = []
        lifeTime = ""
        price = ""
        stockStatus = 0
        stockMeasure = ""
    }
}
