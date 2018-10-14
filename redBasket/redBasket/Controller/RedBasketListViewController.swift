//
//  RedBasketListViewController.swift
//  redBasket
//
//  Created by Salute on 26/08/18.
//  Copyright © 2018 Maharani. All rights reserved.
//

import UIKit
import SystemConfiguration
import NVActivityIndicatorView
var reachability = Reachability()
class RedBasketListViewController: UIViewController, NVActivityIndicatorViewable {
    //MARK: - Outlets
    @IBOutlet weak var rbCollectionview: UICollectionView!
    //MARK: - Variables
    var productCollectionRedmart: DataSource?
    let footerHeight: CGFloat = 44.0
    let collectionViewTopSpaceInset: CGFloat = 16.0
    let refreshControl = UIRefreshControl()
    let size = CGSize(width: 30, height: 30)
    var collectionFooterView: UIView?
     //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Check for Internet
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK: - Pull to Refresh
    @objc func pullToRefresh() {
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 30)!)
        if Reachability.isConnectedToNetwork(){
         self.loadData()
        }
        refreshControl.endRefreshing()
        return
    }
    
    //MARK: - View Setup
    func viewSetup(){
        
        refreshControl.addTarget(self, action: #selector(RedBasketListViewController.pullToRefresh), for: .valueChanged)
        rbCollectionview.addSubview(refreshControl)
        startAnimating(size, message: "Please wait...", type: NVActivityIndicatorType(rawValue: 30)!)
         if Reachability.isConnectedToNetwork(){
         self.loadData()
        }
    }

    func loadData(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Processing data...")
        }
        Service.sharedInstance().getProducts {(collection:DataSource?, error:Error?) -> Void in
            if nil != collection {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
                    self.stopAnimating()
                }
                self.productCollectionRedmart = collection
                self.rbCollectionview.reloadData()
                
            }
            
        }
    }
    
    //MARK: - Pagination Displaycell Helper
    func shouldLoadNewPage(_ indexPath : IndexPath) -> Bool {
        if (indexPath.row + 1 ==  productCollectionRedmart?.redMartAllSalesProducts.count) {
            return true
        }
        return false
    }
    
    //MARK: - Pagaination activityIndicator
    func setCollectionViewFooterLoadingIndicatorView(_ activityIndicator: Bool) -> () {
        
        if activityIndicator {
            let footerView = UIView(frame: CGRect(x: 0, y: rbCollectionview.contentSize.height, width: rbCollectionview.bounds.width, height: footerHeight))
            footerView.backgroundColor = UIColor.clear
            rbCollectionview.addSubview(footerView)
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            activityIndicator.tintColor = UIColor.gray
            activityIndicator.center = CGPoint(x:footerView.frame.size.width/2.0, y:footerView.frame.size.height/2.0)
            activityIndicator.startAnimating()
            footerView.addSubview(activityIndicator)
            rbCollectionview.contentInset = UIEdgeInsets(top: collectionViewTopSpaceInset, left: 0, bottom: footerHeight, right: 0)
            collectionFooterView = footerView
            
        } else {
            if let _ = collectionFooterView?.superview {
                collectionFooterView?.removeFromSuperview()
                collectionFooterView = nil
                rbCollectionview.contentInset = UIEdgeInsets(top: collectionViewTopSpaceInset, left: 0, bottom: 0, right: 0)
                
            }
            
        }
        
    }
    
    
}

extension RedBasketListViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: - Collectionview datasources
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (productCollectionRedmart?.redMartAllSalesProducts.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RedBasketListCollectionViewCell", for: indexPath) as! RedBasketListCollectionViewCell
        cell.setupCellForProduct(product: (productCollectionRedmart?.redMartAllSalesProducts[indexPath.row])!)
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        return cell
        
    }
    
    //MARK: - Collectionview delegates
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let transition = CATransition()
        transition.duration = 0.8
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromBottom
        self.navigationController!.view.layer.add(transition, forKey: nil)
        let storyBoardDetail : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let secondViewController = storyBoardDetail.instantiateViewController(withIdentifier: "RedmartDetail") as! RedBasketDetailViewController
        secondViewController.allProducts = productCollectionRedmart?.redMartAllSalesProducts[indexPath.row]
        self.navigationController?.pushViewController(secondViewController, animated: false)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
                if shouldLoadNewPage(indexPath) {
            setCollectionViewFooterLoadingIndicatorView(true)
            Service.sharedInstance().getPagination(productCollectionRedmart!) {(collection, error) in
                self.setCollectionViewFooterLoadingIndicatorView(false)
                if nil != collection {
                    self.productCollectionRedmart = collection
                    self.rbCollectionview.reloadData()
                    
                }
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCell: CGFloat = 3
        let cellWidth = ((rbCollectionview.bounds.size.width) / numberOfCell) - 8.0
        return CGSize(width:cellWidth, height:cellWidth + (1.4 * cellWidth))
    }
   
    
    
}

