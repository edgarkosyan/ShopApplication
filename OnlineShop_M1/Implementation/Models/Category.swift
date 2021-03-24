//
//  Category.swift
//  OnlineShop_M1
//
//  Created by edgar kosyan on 28.02.21.
//

import Foundation
import UIKit

class Category {
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init(name: String, imageName: String) {
        id = ""
        self.name = name
        self.imageName = imageName
        image = UIImage(named:imageName)
    }
    
    init(_ dictionary: NSDictionary) {
        id = dictionary["objectId"] as! String
        name = dictionary["name"] as! String
        image = UIImage(named: dictionary["imageName"] as? String ?? "")
    }
}

//MARK: save category to Firebase

func saveCategoryToFirebase(category: Category) {
    let id = UUID().uuidString
    category.id = id
    
    FirebaseReference(.Category).document(id).setData(categoryDictionary(category: category) as! [String: Any])
    
}


//MARK: Download categories from firebase

func downloadCategory(completion: @escaping(_ categoryArray: [Category]) -> Void){
    var categoryArray: [Category] = []
    FirebaseReference(.Category).getDocuments { (querySnapshot, error) in
        guard let snapshot = querySnapshot else {
            completion(categoryArray)
            return
        }
        if !snapshot.isEmpty {
            
            for i in snapshot.documents {
                categoryArray.append(Category(i.data() as NSDictionary))
            }
        }
        completion(categoryArray)
    }
    
}


//MARK: category to dictionary

func categoryDictionary(category: Category) -> NSDictionary{
    return NSDictionary(objects: [category.id, category.imageName ?? "", category.name], forKeys: ["objectId" as NSCopying, "imageName" as NSCopying, "name" as NSCopying])
}



//MARK: create category /////use only one time
//
//func createCategoryCollection(){
//    let tops = Category(name: "Tops", imageName: "tops")
//    let shoes = Category(name: "Shoes", imageName: "shoes")
//    let dresses = Category(name: "Dresses", imageName: "dresses")
//    let knitwear = Category(name: "Knitwear", imageName: "knitwear")
//    let jackets = Category(name: "Jackets", imageName: "jackets")
//    let denim = Category(name: "Denim", imageName: "denim")
//    let shorts = Category(name: "Shorts", imageName: "shorts")
//    let skirts = Category(name: "Skirts", imageName: "skirts")
//    let trousers = Category(name: "Trousers", imageName: "trousers")
//    let lingerie = Category(name: "Lingerie", imageName: "lingerie")
//    let beachwear = Category(name: "Beachwear", imageName: "beachwear")
//    let jewelry = Category(name: "Jewelry", imageName: "jewelry")
//
//    let categoryArr = [tops,shoes, dresses,knitwear,jackets,denim,shorts,skirts,trousers,lingerie,beachwear,jewelry]
//
//    for i in categoryArr {
//        saveCategoryToFirebase(category: i)
//    }
//}

