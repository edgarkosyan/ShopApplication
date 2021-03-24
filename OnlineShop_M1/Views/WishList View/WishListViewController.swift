//
//  WishListViewController.swift
//  OnlineShop_M1
//
//  Created by edgar kosyan on 17.03.21.
//

import UIKit

class WishListViewController: UIViewController {

    var wishList: WishList?
    var productArr: [Product] = []
    
    @IBOutlet weak var totalProductsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        setUpNavigationBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        if User.currentUser() != nil {
            downloadthisWishListFromFireBase()
            totalProductsLabel.text = "\(productArr.count) ITEMS"
            print("Count //////",productArr.count)
        }else{
            print("no user logged in")
        }
        
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
    
    func setUpTableView(){
        tableView.register(UINib(nibName: "WishListTableViewCell", bundle: nil), forCellReuseIdentifier: "WishListTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }



    func downloadthisWishListFromFireBase(){
        downloadWishListFromFirebase(ownerId: User.currentId()) { (wishList) in
            self.wishList = wishList
            
            self.downloadproducts()
        }
    }
    func downloadproducts(){
        if wishList != nil {
            downloadProductFromFIrebaseForWishList(ids: wishList!.productsId) { (productArray) in
                self.productArr = productArray
                self.tableView.reloadData()
            }
        }
    }
    func deleteProductFromWishList(productId: String){
        for i in 0..<wishList!.productsId.count {
            if productId == wishList!.productsId[i] {
                wishList!.productsId.remove(at: i)
                return
            }
        }
    }
}

extension WishListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        totalProductsLabel.text = "\(productArr.count) ITEMS"
       return productArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishListTableViewCell", for: indexPath) as! WishListTableViewCell
        cell.setUp(product: productArr[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "wishlistproductview") as! WishListProductViewViewController
        vc.product = productArr[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteItm = productArr[indexPath.row]
            productArr.remove(at: indexPath.row)
            tableView.reloadData()
            deleteProductFromWishList(productId: deleteItm.id)
            updateWishListInFireBase(wishList: wishList!, values: ["productId" : wishList!.productsId]) { (error) in
                if error != nil {
                    print("error deleting product from basket", error?.localizedDescription)
                }else {
                    self.downloadproducts()
                }
            }
        }
    }
}

