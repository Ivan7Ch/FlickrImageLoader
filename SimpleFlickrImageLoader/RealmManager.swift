//
//  RealmManager.swift
//  SimpleFlickrImageLoader
//
//  Created by Ivan Chernetskiy on 25.02.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import RealmSwift


class RealmImage: Object {
    @objc dynamic var name = ""
    @objc dynamic var imageData: Data? = nil
}


class RealmManager {
    
    private var realm: Realm
    
    
    init() {
        realm = try! Realm()
    }
    
    
    func saveImage(image: ImageModel) {
        let entity = RealmImage()
        entity.name = image.name ?? ""
        entity.imageData = image.image?.pngData()
        
        try! realm.write {
            realm.add(entity)
        }
    }
    
    
    func retrieveAllImages() -> [ImageModel] {
        let entities = realm.objects(RealmImage.self)
        var images = [ImageModel]()
        
        for i in entities {
            guard let data = i.imageData else { continue }
            let image = ImageModel(name: i.name, image: UIImage(data: data))
            images.append(image)
        }
        
        return images
    }
}
