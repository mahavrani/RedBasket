//
//  RedBasketDetailViewController.swift
//  redBasket
//
//  Created by Salute on 26/08/18.
//  Copyright © 2018 Maharani. All rights reserved.
//

import UIKit

class RedBasketDetailViewController: UIViewController {
    
    //MARK: - Variables
    var allProducts: Products?
    
    //MARK: - Outlets
    @IBOutlet weak var rbProductDetails: UILabel!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        rbProductDetails.text = allProducts?.title
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBAction
    @IBAction func rbBackButtonPressed(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.8
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromBottom
        self.navigationController!.view.layer.add(transition, forKey: nil)
        let storyBoardDetail : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let secondViewController = storyBoardDetail.instantiateViewController(withIdentifier: "RedmartList") as! RedBasketListViewController
        self.navigationController?.pushViewController(secondViewController, animated: false)
    }
    
}

extension RedBasketDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Tableviewview datasources
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
          
            let cell = tableView.dequeueReusableCell(withIdentifier: "RedBasketImageTableViewCell", for: indexPath) as! RedBasketImageTableViewCell
            cell.setupCellFor(product: allProducts!)
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RedBasketInfoTableViewCell", for: indexPath) as! RedBasketInfoTableViewCell
            cell.setupCellFor(product: allProducts!)
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RedBasketDetailTableViewCell", for: indexPath) as! RedBasketDetailTableViewCell
            cell.setupCellFor(product: allProducts!)
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RedBasketInfoTableViewCell", for: indexPath) as! RedBasketInfoTableViewCell
            cell.setupCellFor(product: allProducts!)
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
            
        case 0:
            return 250.0
            
        case 1:
            return 150.0
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RedBasketDetailTableViewCell") as! RedBasketDetailTableViewCell
            cell.rbDetailsTextView.text = allProducts?.details
            let fixedWidth = cell.rbDetailsTextView.frame.size.width
            cell.rbDetailsTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            let newSize = cell.rbDetailsTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = cell.rbDetailsTextView.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            return newFrame.size.height + 50.0
            
        default:
            return 50.0
            
        }
        
    }
    
}
