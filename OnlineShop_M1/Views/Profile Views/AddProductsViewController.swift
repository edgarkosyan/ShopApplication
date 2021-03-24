//
//  AddProductsViewController.swift
//  OnlineShop_M1
//
//  Created by edgar kosyan on 08.03.21.
//

import UIKit
import Gallery
import JGProgressHUD // Notification
import NVActivityIndicatorView // loading animation

class AddProductsViewController: UIViewController {
 
    @IBOutlet var tappGesture: UITapGestureRecognizer!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var chooseCategoryButton: UIButton!
    
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productTitleTextField: UITextField!
    @IBOutlet weak var shortDescriptionTextField: UITextField!
    @IBOutlet weak var descriptionTextVIew: UITextView!
    
    //MARK: vars
    var gallery: GalleryController!
    var hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
    var productImages: [UIImage?] = []
    

    var chosenCategoryId: String!
    var categoryIsChosen: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpcollection()
        setUpView()
        setRightBarButton()
        setBackButton()
        
    }
    
    func setBackButton(){
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonAction))]
    }
    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballRotateChase, color: UIColor.init(red: 255/255, green: 175/255, blue: 177/255, alpha: 1), padding: nil)
    }
    
    @IBAction func tappGestureClicked(_ sender: Any) {
        self.view.endEditing(false)
    }
    
    func setRightBarButton(){
        let barButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButton))
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    @objc func doneButton(_ sender: UIBarButtonItem){
        if productTitleTextField.text != "" && productPriceTextField.text != "" && descriptionTextVIew.text != "" && categoryIsChosen != false {
            
            saveToFirebase()
            
        } else {
            //            let alert = UIAlertController(title: "Attention", message: "All Fields Are Required", preferredStyle: .alert)
            //            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            //            alert.addAction(alertAction)
            //            self.present(alert, animated: true, completion: nil)
            self.hud.textLabel.text = "All Fields Are Required"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
            
        }
    }

    
    func setUpcollection(){
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.register(UINib(nibName: "listOfcategoriesCell", bundle: nil), forCellWithReuseIdentifier: "listOfcategoriesCell")
        categoryCollectionView.isHidden = true
    }
    
    func setUpView(){
        productTitleTextField.borderStyle = .none
        productPriceTextField.borderStyle = .none
        shortDescriptionTextField.borderStyle = .none
        chooseImageButton.layer.cornerRadius = 4
        chooseCategoryButton.layer.cornerRadius = 4
        descriptionTextVIew.layer.cornerRadius = 4
        
        
    }
    
    @IBAction func chooseCategoryButtonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.6) {
            self.categoryCollectionView.isHidden = !self.categoryCollectionView.isHidden
        }
        tappGesture.cancelsTouchesInView  = false
    }
    
    @IBAction func chooseImageButtonClicked(_ sender: Any) {
        productImages = []
        self.gallery = GalleryController()
        gallery.delegate = self
        
        Config.tabsToShow = [.cameraTab, .imageTab]
        Config.Camera.imageLimit = 5
        self.present(self.gallery, animated: true, completion: nil)
    }
    
    
    //MARK: Save to firebase
    
    func saveToFirebase(){
        self.navigationItem.rightBarButtonItem = nil
        
        self.view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
        
        
        let product = Product()
        product.id = UUID().uuidString
        product.categoryId = chosenCategoryId
        product.name = productTitleTextField.text!
        product.price = Double(productPriceTextField.text!)
        product.description = descriptionTextVIew.text
        product.shortDescription = shortDescriptionTextField.text
        if productImages.count > 0 {
            uploadImages(images: productImages, productId: product.id) { (imageLinkArr) in
                product.imageLinks = imageLinkArr
                
                
                saveItemToFirebase(product: product)
                self.navigationController?.popViewController(animated: true)
                
                self.activityIndicator!.removeFromSuperview()
                self.activityIndicator!.stopAnimating()
            }
        } else {
            saveItemToFirebase(product: product)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}



extension AddProductsViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            // MARK: convert PHAssets to UUImage
            Image.resolve(images: images) { (convertedImages) in
                self.productImages = convertedImages
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}


extension AddProductsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        CategoryEnum.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listOfcategoriesCell", for: indexPath) as! listOfcategoriesCell
        cell.setUp()
        cell.categoryLabel.text = CategoryEnum.allCases[indexPath.item].rawValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 2 - 30, height: collectionView.frame.width / 7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chooseCategoryButton.setTitle("\(CategoryEnum.allCases[indexPath.item].rawValue)", for: .normal)
        UIView.animate(withDuration: 0.4) {
            self.categoryCollectionView.isHidden = true
        }
        
        switch indexPath.row{
        case (0):
            chosenCategoryId = CategoryIdEnum.jackets.rawValue
            print("footwear")
        case (1):
            chosenCategoryId = CategoryIdEnum.denim.rawValue
            print("tshirt")
        case (2):
            chosenCategoryId = CategoryIdEnum.skirts.rawValue
            print("jacket")
        case (3):
            chosenCategoryId = CategoryIdEnum.shoes.rawValue
        case (4):
            chosenCategoryId = CategoryIdEnum.dresses.rawValue
        case (5):
            chosenCategoryId = CategoryIdEnum.beachwear.rawValue
        case (6):
            chosenCategoryId = CategoryIdEnum.knitwear.rawValue
        case (7):
            chosenCategoryId = CategoryIdEnum.jewelry.rawValue
        case (8):
            chosenCategoryId = CategoryIdEnum.shorts.rawValue
        case (9):
            chosenCategoryId = CategoryIdEnum.trousers.rawValue
        case (10):
            chosenCategoryId = CategoryIdEnum.lingerie.rawValue
        case (11):
            chosenCategoryId = CategoryIdEnum.tops.rawValue
        default:
            break
        }
        
        categoryIsChosen = true
    }
    
    
    
}
