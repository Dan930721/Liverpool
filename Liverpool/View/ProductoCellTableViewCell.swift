//
//  ProductoCellTableViewCell.swift
//  Liverpool
//
//  Created by Daniel Liceaga on 15/09/20.
//  Copyright © 2020 Daniel Liceaga. All rights reserved.
//

import UIKit

class ProductoCellTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var categoria: UILabel!
    
    var thumbnailURL = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titulo.numberOfLines = 2
        titulo.textColor = .darkGray
        titulo.font = UIFont.systemFont(ofSize: 14)
        titulo.adjustsFontSizeToFitWidth =  true
        
        precio.textColor = .red
        precio.font = UIFont.boldSystemFont(ofSize: 14)
        
        categoria.numberOfLines = 2
        categoria.textColor = .darkGray
        categoria.font = UIFont.systemFont(ofSize: 14)
        categoria.adjustsFontSizeToFitWidth =  true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        
    }
    
}
