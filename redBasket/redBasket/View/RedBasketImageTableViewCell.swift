//
//  RedBasketImageTableViewCell.swift
//  redBasket
//
//  Created by Salute on 26/08/18.
//  Copyright © 2018 Maharani. All rights reserved.
//

import UIKit

class RedBasketImageTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var rbScrollView: UIScrollView!
    @IBOutlet weak var rbPageControl: UIPageControl!
    
    var allProducts: Products?
    var imageViewFrame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var imageViews = [UIImageView]()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        rbScrollView.delegate = self
        
    }
    
    //MARK: - Cell Setup
    func setupCellFor(product: Products) {
        
        self.allProducts = product
        
        configurePageScroll()
        
        for index in 0..<product.images.count {
            
            imageViewFrame.origin.x = self.rbScrollView.frame.size.width * CGFloat(index)
            imageViewFrame.size = self.rbScrollView.frame.size
            self.rbScrollView.isPagingEnabled = true
            
            let productImageView = UIImageView(frame: imageViewFrame)
            productImageView.clipsToBounds = true
            productImageView.contentMode = .scaleAspectFill
            
            self.rbScrollView.addSubview(productImageView)
            imageViews.append(productImageView)
            productImageView.setImageFromURL(product.images[index], placeHolder: "PlaceHolder")
            
        }
        
        self.rbScrollView.contentSize = CGSize(width:self.rbScrollView.frame.size.width * CGFloat(product.images.count), height:self.rbScrollView.frame.size.height)
        rbPageControl.addTarget(self, action: #selector(RedBasketImageTableViewCell.scrollPage(sender:)), for: UIControlEvents.valueChanged)
        
    }
    
    //MARK: - Configure Page
    func configurePageScroll() {
        
        self.rbPageControl.numberOfPages = (allProducts?.images.count).or(0)
        self.rbPageControl.currentPage = 0
        self.rbPageControl.tintColor = UIColor.lightGray
        self.rbPageControl.pageIndicatorTintColor = UIColor.black
        self.rbPageControl.currentPageIndicatorTintColor = UIColor.white
        
        if allProducts?.images.count == 1 {
            
            rbPageControl.isHidden = true
            rbScrollView.isScrollEnabled = false
            
        }
        
    }
    
    //MARK: - Scroll Page
    @objc func scrollPage(sender: AnyObject) -> () {
        
        let x = CGFloat(rbPageControl.currentPage) * rbScrollView.frame.size.width
        rbScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
        
    }
}


//MARK: - Scroll View Delegate
extension RedBasketImageTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = Int (round(scrollView.contentOffset.x / scrollView.frame.size.width))
        
        if pageNumber < (allProducts?.images.count).or(0) {
            
            let imageView = imageViews[pageNumber]
            imageViewFrame.origin.x = self.rbScrollView.frame.size.width * CGFloat(pageNumber)
            imageViewFrame.size = self.rbScrollView.frame.size
            imageView.frame = imageViewFrame
            rbPageControl   .currentPage = Int(pageNumber)
            
}
}
}

