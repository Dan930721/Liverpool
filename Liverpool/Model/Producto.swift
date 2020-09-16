//
//  Producto.swift
//  Liverpool
//
//  Created by Daniel Liceaga on 15/09/20.
//  Copyright © 2020 Daniel Liceaga. All rights reserved.
//

import Foundation

class Producto: NSObject {
    
    var titulo: String = ""
    var precio: String = ""
    var categoria: String = ""
    var thumbnail: String = ""
    
    override init() {
        super.init()
    }
    
    init(titulo: String, precio: String, categoria: String, thumbnail:  String) {
        super.init()
        
        self.titulo = titulo
        self.precio = precio
        self.categoria = categoria
        self.thumbnail = thumbnail
    }
}
