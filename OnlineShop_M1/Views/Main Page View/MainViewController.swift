//
//  MainViewController.swift
//  OnlineShop_M1
//
//  Created by edgar kosyan on 07.03.21.
//

import UIKit
import NVActivityIndicatorView

class MainViewController: UIViewController {
    var activityIndicator: NVActivityIndicatorView?
    var products: [Product] = []
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadactivity()
        setUpCollection()
        setUpNavigationBar()
        setUpTabbar()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        downloadProductFromFirebaseToMainView { (allProduct) in
            self.products = allProduct
            self.mainCollectionView.reloadData()
            self.activityIndicator!.removeFromSuperview()
            self.activityIndicator!.stopAnimating()
        }
        print("Current User is ", User.currentUser()?.email)
            
    }
    func loadactivity(){
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: UIColor.init(red: 255/255, green: 175/255, blue: 177/255, alpha: 1), padding: nil)
        
        self.view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
    }
    func setUpTabbar(){
        let tapBar = tabBarController?.tabBar
        tapBar?.barTintColor = .white
        tapBar?.tintColor = .darkGray
        tapBar?.unselectedItemTintColor = .lightGray
        
    }
    func setUpNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!
        ]
       // chevron.backward
        navigationItem.title = "Midiart"
        navigationController?.navigationBar.titleTextAttributes = attrs
        //navigationItem.backButtonTitle = "Back"
    }
    
    func setUpCollection(){
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.register(UINib(nibName: "MainViewCell", bundle: nil), forCellWithReuseIdentifier: "MainViewCell")
    }


}

extension MainViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainViewCell", for: indexPath) as! MainViewCell
        cell.setUp(products[indexPath.item])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "productview") as! ProductViewController
        vc.product = products[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
