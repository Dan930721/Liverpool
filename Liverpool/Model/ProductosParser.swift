//
//  ProductosParser.swift
//  Liverpool
//
//  Created by Daniel Liceaga on 15/09/20.
//  Copyright © 2020 Daniel Liceaga. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProductosParser: NSObject {
    
    override init() {
        super.init()
    }
    
    func parse(json: JSON) -> [Producto] {
        var productosRes: [Producto] = []
        
        if (json["status"]["statusCode"] == 0) {
            if let array = json["plpResults"]["records"].array {
                for value in array {
                    productosRes.append(Producto(
                        titulo: value["productDisplayName"].string ?? "",
                        precio: value["maximumListPrice"].string ?? "$0",
                        categoria: value["category"].string ?? "",
                        thumbnail: value["smImage"].string ?? ""
                    ))
                }
            }
        }
        
        return productosRes
    }
}
