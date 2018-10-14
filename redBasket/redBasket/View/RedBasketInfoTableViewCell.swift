//
//  RedBasketInfoTableViewCell.swift
//  redBasket
//
//  Created by Salute on 26/08/18.
//  Copyright © 2018 Maharani. All rights reserved.
//

import UIKit

class RedBasketInfoTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var rbPriceLabel: UILabel!
    @IBOutlet weak var rbLifeTimeLabel: UILabel!
    @IBOutlet weak var rbVendorName: UILabel!
    @IBOutlet weak var rbVendorLogo: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    //MARK: - Cell Setup
    func setupCellFor(product: Products) {
        rbPriceLabel.text = product.price ?? UrlConstants.notApplicable
        rbLifeTimeLabel.text = product.stockMeasure ?? UrlConstants.notApplicable
        if product.merchantName != ""{
            rbVendorName.text = product.merchantName ?? UrlConstants.notApplicable
        }else{
            rbVendorName.text = UrlConstants.notApplicable
        }
        rbVendorLogo.setImageFromURL(product.merchantLogo ?? "", placeHolder: nil)
    }
    
}

