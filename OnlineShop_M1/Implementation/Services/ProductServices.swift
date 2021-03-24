//
//  ProductServices.swift
//  OnlineShop_M1
//
//  Created by edgar kosyan on 23.03.21.
//

import Foundation

class ProductServices: IProductServices {
    
//MARK: save to firestore
    
    func saveProductToFirebase(product: Product){
        FirebaseReference(.Product).document(product.id).setData(ProductDictionary(product: product) as! [String: Any])
    }
    
//MARK: download function
    
    func downloadProductFromFirebase(categoryID: String, completion: @escaping(_ productArr: [Product]) -> Void){
        
        var productArr: [Product] = []
        FirebaseReference(.Product).whereField("categoryId", isEqualTo: categoryID).getDocuments { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(productArr)
                return
            }
            if !snapshot.isEmpty{
                for product in snapshot.documents {
                    productArr.append(Product(dictionary: product.data() as NSDictionary))
                }
            }
            completion(productArr)
        }
    }
    
    func downloadProductFromFirebaseToMainView(completion: @escaping(_ productArr: [Product]) -> Void){
        
        var productArr: [Product] = []
        FirebaseReference(.Product).getDocuments { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(productArr)
                return
            }
            if !snapshot.isEmpty{
                for product in snapshot.documents {
                    productArr.append(Product(dictionary: product.data() as NSDictionary))
                }
            }
            completion(productArr)
        }
    }

    
    func downloadProductFromFIrebaseForWishList(ids: [String], completion: @escaping(_ productArray: [Product]) -> Void){
        var count = 0
        var productArray: [Product] = []
        
        if ids.count > 0 {
            
            for productId in  ids {
                FirebaseReference(.Product).document(productId).getDocument { (Snapshot, error) in
                    guard let snapshot = Snapshot else {
                        completion(productArray)
                        return
                    }
                    if snapshot.exists {
                        productArray.append(Product(dictionary: snapshot.data()! as NSDictionary))
                        
                        count += 1
                    }else{
                        completion(productArray)
                    }
                    if count == ids.count {
                        completion(productArray)
                    }
                }
                print("productIDS are = ", productId)
            }
        }else {
            completion(productArray)
        }
    }
    
//MARK: item to dictinary
    
    func ProductDictionary(product: Product)-> NSDictionary {
        return NSDictionary(objects: [product.id,product.categoryId,product.name, product.description,product.shortDescription,product.price,product.imageLinks], forKeys: ["objectId" as NSCopying,"categoryId" as NSCopying,"name" as NSCopying,"description" as NSCopying,"shortDescription" as NSCopying,"price" as NSCopying, "imageLinks" as NSCopying])
    }

}
