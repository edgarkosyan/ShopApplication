//
//  Basket.swift
//  OnlineShop_M1
//
//  Created by edgar kosyan on 10.03.21.
//

import Foundation

class WishList {
    var id: String!
    var ownerId: String!
    var productsId: [String]!
    
    init(){
    }
    init(_ dictionaty: NSDictionary){
        id = dictionaty["objectId"] as? String ?? ""
        ownerId = dictionaty["ownerId"] as? String ?? ""
        productsId = dictionaty["productId"] as? [String] ?? [""]
    }
}

//MARK: Download Basket Items

func downloadWishListFromFirebase(ownerId: String, completion: @escaping(_ wishList: WishList?) -> Void){
    FirebaseReference(.WishList).whereField("ownerId", isEqualTo: ownerId).getDocuments { (querySnapshot, error) in
        guard let snapshot = querySnapshot else {
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.count > 0 {
            let wishList = WishList(snapshot.documents.first!.data() as NSDictionary)
            completion(wishList)
        }else {
            completion(nil)
        }
    }
}

//MARK: save wishList to Firebase

func saveWishListToFirebase(wishList: WishList){
    FirebaseReference(.WishList).document(wishList.id).setData(basketDictionary(wishList: wishList) as! [String:Any])
}

func basketDictionary(wishList:WishList) -> NSDictionary{
    return NSDictionary(objects: [wishList.id,wishList.ownerId,wishList.productsId], forKeys: [ "objectId" as NSCopying,"ownerId" as NSCopying,"productId" as NSCopying])
}

func updateWishListInFireBase(wishList: WishList, values: [String: Any], completion: @escaping(_ error: Error?)-> Void){
    FirebaseReference(.WishList).document(wishList.id).updateData(values){ (error) in
        completion(error)
    }
}
