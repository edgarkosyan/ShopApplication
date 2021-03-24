//
//  CategoryViewController.swift
//  OnlineShop_M1
//
//  Created by edgar kosyan on 25.02.21.
//

import UIKit
import NVActivityIndicatorView

class CategoryViewController: UIViewController {
    
    var activityIndicator: NVActivityIndicatorView?
    var categoryArray: [Category] = []
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadactivity()
        setUpCategoryCollection()
        setUpNavigationBar()
    }
    
    func loadactivity(){
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballGridPulse, color: UIColor.init(red: 255/255, green: 175/255, blue: 177/255, alpha: 1), padding: nil)
        
        self.view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
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
        navigationItem.backButtonTitle = "Back"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadCategory { (categoryArr) in
            self.categoryArray = categoryArr
            self.categoryCollection.reloadData()
            self.activityIndicator!.removeFromSuperview()
            self.activityIndicator!.stopAnimating()
        }
    }
    
    func setUpCategoryCollection(){
        categoryCollection.dataSource = self
        categoryCollection.delegate = self
        categoryCollection.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
    }
}


extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.setUp(categoryArray[indexPath.item])
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.backView.layer.cornerRadius).cgPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 120, height: 170)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "itemcell") as! SelectedCategoryViewController
        vc.category = categoryArray[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
