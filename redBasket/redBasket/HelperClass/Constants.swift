//
//  Constants.swift
//  redBasket
//
//  Created by Salute on 26/08/18.
//  Copyright © 2018 Maharani. All rights reserved.
//

import UIKit

    //MARK: - Constants
    struct UrlConstants {
        static var productListAPI = "https://api.redmart.com/v1.6.0/catalog/search?theme=all-sales&"
        static var productImageAPI = "http://media.redmart.com/newmedia/200p"
        static var notApplicable = "N/A"
        static var notApplicableInteger = 0
    }


    
    extension UIViewController {
        
        //MARK: - default alert/info message with an OK button.
        func showAlertMessage(_ message: String, okButtonTitle: String = "Ok") -> Void {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    //Extension to handle Optional value//
    extension Optional {
        func or(_ defaultValue: Wrapped) -> Wrapped {
            if self == nil{
                return defaultValue
            }
            else if self is NSNull{
                return defaultValue
            }else{
                return self!
            }
        }
    }
    //Extension for Image View//
public extension UIImageView {
    fileprivate func setImageData(_ cachedResponse:CachedURLResponse?,placeHolder:String?) {
        //UI operation,Should be over main thread.
        if let data = cachedResponse?.data {
            if let img = UIImage(data: data) {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.image = img
                })
            } else {
                if let hlder = placeHolder {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.image = UIImage(named: hlder)
                    })
                }
            }
        } else {
            if let hlder = placeHolder {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.image = UIImage(named: hlder)
                })
            }
        }
    }
    
    func setImageFromURL(_ urlString:String,placeHolder:String?) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: { () -> Void in
            if let url =  URL(string: urlString) {
                let request = URLRequest(url: url)
                
                if let cachedUrlResponse = URLCache.shared.cachedResponse(for: request) {
                    self.setImageData(cachedUrlResponse,placeHolder: placeHolder)
                } else {
                    //Set place holder
                    if let placeHolder = placeHolder {
                        self.setImageData(nil, placeHolder: placeHolder)
                    }
                    //Fetch remote image
                    let urlInstance = URL(string: urlString)
                    let request = URLRequest(url: urlInstance!, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
                    var response:URLResponse?
                    //var error:NSError?
                    let data: Data?
                    do {
                        data = try NSURLConnection.sendSynchronousRequest(request, returning: &response)
                    } catch _ as NSError {
                        //error = error1
                        data = nil
                    } catch {
                        fatalError()
                    }
                    if let response = response ,let data = data {
                        let cachedResponse = CachedURLResponse(response: response, data: data)
                        URLCache.shared.storeCachedResponse(cachedResponse , for: request)
                        self.setImageData(cachedResponse, placeHolder: placeHolder)
                    }
                }
            } else {
                if let placeHolder = placeHolder {
                    self.setImageData(nil, placeHolder: placeHolder)
                }
            }
        })
    }
}
