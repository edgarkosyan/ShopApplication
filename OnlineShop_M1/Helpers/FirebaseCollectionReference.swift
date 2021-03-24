//
//  FirebaseCollectionReference.swift
//  OnlineShop_M1
//
//  Created by edgar kosyan on 28.02.21.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Product
    case Category
    case WishList
}

//MARK: get refference of of each folder of our collections in firebase

func FirebaseReference(_ collectionRef: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionRef.rawValue)
}
