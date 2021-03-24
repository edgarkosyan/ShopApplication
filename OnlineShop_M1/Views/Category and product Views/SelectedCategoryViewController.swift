//
//  SelectedCategoryViewController.swift
//  OnlineShop_M1
//
//  Created by edgar kosyan on 25.02.21.
//

import UIKit
import NVActivityIndicatorView

class SelectedCategoryViewController: UIViewController {
    
    var activityIndicator: NVActivityIndicatorView?
    
    var category: Category?
    var productArray: [Product] = []
    @IBOutlet weak var ProductsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadactivity()
        setUpItemCollection()
        self.title = category?.name
        setBackButton()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil {
            downloadProductFromFirebase(categoryID: category!.id) { (products) in
                self.productArray = products
                self.ProductsCollectionView.reloadData()
                for i in self.productArray{
                    print("product ids = " ,i.id)
                }
            }
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 ){
                self.activityIndicator!.removeFromSuperview()
                self.activityIndicator!.stopAnimating()
            //}
        }
        
    }

    

    
    func setBackButton(){
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonAction))]
    }
    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func loadactivity(){
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .circleStrokeSpin, color: UIColor.init(red: 255/255, green: 175/255, blue: 177/255, alpha: 1), padding: nil)
        
        self.view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
    }
    

    
    func setUpItemCollection(){
        ProductsCollectionView.register(UINib(nibName: "SelectedCategoryCell", bundle: nil), forCellWithReuseIdentifier: "SelectedCategoryCell")
        ProductsCollectionView.dataSource = self
        ProductsCollectionView.delegate = self
    }
    
    
}



extension SelectedCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedCategoryCell", for: indexPath) as! SelectedCategoryCell
        
        cell.setUp(productArray[indexPath.item])
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.backView.layer.cornerRadius).cgPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 2 - 15, height: collectionView.frame.height / 2 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 7, bottom: 20, right: 7)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "productview") as! ProductViewController
        vc.product = productArray[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}
