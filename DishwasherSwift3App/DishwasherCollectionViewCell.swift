//
//  DishwasherCollectionViewCell.swift
//  DishwasherSwift3App
//
//  Created by mac on 1/4/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage

class DishwasherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func configure(with dishwasher: Repository) {
        
        titleLabel.text = dishwasher.name
        brandLabel.text = dishwasher.brand
        priceLabel.text = String(dishwasher.price)
        
        imageView.sd_setImage(
            with: URL(string: dishwasher.imageURL),
            placeholderImage: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}
