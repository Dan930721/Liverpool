//
//  LiverpoolGetProducts.swift
//  Liverpool
//
//  Created by Daniel Liceaga on 15/09/20.
//  Copyright © 2020 Daniel Liceaga. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LiverpoolGetProducts: NSObject {
    
    private let BASE_URL: String = "https://shoppapp.liverpool.com.mx/appclienteservices/services/v3/plp"
    override init() {
        super.init()
    }

    func getProducts(criterio: String, x: Int = 1, y: Int = 30, callback: @escaping ([Producto]) -> Void) -> Void {
        
        let criterioEncoded = criterio.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = "\(BASE_URL)?force-plp=true&search-string=\(criterioEncoded!)&page-number=\(x)&number-of-items-per-page=\(y)"
        let headers = ["Content-Type" : "application/json","Accept" : "application/json"]
        
        print(url)
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { res in
            
            if (res.response?.statusCode == 200) {
                if let data = res.data {
                    do {
                        let json = try JSON(data: data)
                        let productos = ProductosParser().parse(json: json)
                        callback(productos)
                    }
                    catch {
                        callback([])
                    }
                }
            }
            else {
                callback([])
            }
        }
    }
    
    func getImage(url: String, callback: @escaping (UIImage?) -> Void) {
        
        Alamofire.request(url).response { res in
            callback(UIImage(data: res.data!))
        }
    }
}
