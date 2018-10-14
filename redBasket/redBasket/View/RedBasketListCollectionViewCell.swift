//
//  RedBasketListCollectionViewCell.swift
//  redBasket
//
//  Created by Salute on 26/08/18.
//  Copyright © 2018 Maharani. All rights reserved.
//

import UIKit

class RedBasketListCollectionViewCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var rbImageView: UIImageView!
    @IBOutlet weak var rbProductNameLabel: UILabel!
    @IBOutlet weak var rbPriceLabel: UILabel!
    @IBOutlet weak var rbStockMeasure: UILabel!
    
    //MARK: - Cell Setup
    func setupCellForProduct(product: Products)  {
        rbImageView.setImageFromURL((product.coverImage ?? ""), placeHolder: nil)
        rbImageView.clipsToBounds = true
        rbProductNameLabel.text = product.title ?? UrlConstants.notApplicable
        rbPriceLabel.text = product.price ?? UrlConstants.notApplicable
        rbStockMeasure.text = product.stockMeasure ?? UrlConstants.notApplicable
    }
    
}
