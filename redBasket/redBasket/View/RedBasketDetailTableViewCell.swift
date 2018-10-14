//
//  RedBasketDetailTableViewCell.swift
//  redBasket
//
//  Created by Salute on 26/08/18.
//  Copyright © 2018 Maharani. All rights reserved.
//

import UIKit

class RedBasketDetailTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var rbDetailsTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Cell Setup
    func setupCellFor(product: Products) {
        rbDetailsTextView.text = product.details ?? UrlConstants.notApplicable
    }

}
