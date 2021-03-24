//

//  OnlineShop_M1
//
//  Created by edgar kosyan on 06.03.21.
//

import UIKit
import JGProgressHUD
class WishListProductViewViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productShortDescriptionLabel: UILabel!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    
    var product: Product!
    var ProductImages: [UIImage] = []
    var hud = JGProgressHUD(style: .dark)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("product id is", product.name,product.price, product.id)
        productCollectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        setProduct()
        downloadPictures()
        self.title = "Midiart"
        setBackButton()
        
        
    }

//MARK: WISHLIST FUNCTIONS
    
  
    func createWishList(){
        let newList = WishList()
        newList.id = UUID().uuidString
        newList.ownerId = User.currentId()
        
        newList.productsId = [self.product.id]
        saveWishListToFirebase(wishList: newList)
        
        self.hud.textLabel.text = "product was added to WishList"
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2)
    }
    
    func updateWishList(wishList: WishList, values: [String: Any]){
        updateWishListInFireBase(wishList: wishList, values: values) { (error) in
            if error != nil {
                self.hud.textLabel.text = "error, \(error!.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2)
            }else{
                self.hud.textLabel.text = "product was added to WishList"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2)
            }
        }
    }
    
    
    func setBackButton(){
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonAction))]
    }
    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func downloadPictures(){
        if product != nil && product.imageLinks != nil {
            downloadImages(imageURL: product.imageLinks) { (images) in
                if images.count > 0 {
                    self.ProductImages = images as! [UIImage]
                    self.productCollectionView.reloadData()
                }
            }
        }
    }
    
    
    
    func setProduct(){
        productNameLabel.text = product.name
        productPriceLabel.text = "$ \(product.price!)"
        descriptionLabel.text = product.description
        productShortDescriptionLabel.text = product.shortDescription
        backView.backgroundColor = .white
        self.view.backgroundColor = .white
    }

    
    
}

extension WishListProductViewViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProductImages.count == 0 ? 1 : ProductImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        if ProductImages.count > 0 {
            cell.setUp(ProductImages[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
}

