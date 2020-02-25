//
//  ViewController.swift
//  SimpleFlickrImageLoader
//
//  Created by Ivan Chernetskiy on 25.02.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import RealmSwift


class Dog: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let myDog = Dog()
        myDog.name = "Rex"
        myDog.age = 1
        print("name of dog: \(myDog.name)")

        // Get the default Realm
        let realm = try! Realm()

        

        // Persist your data easily
        try! realm.write {
            realm.add(myDog)
        }
        
        // Query Realm for all dogs less than 2 years old
        let puppies = realm.objects(Dog.self)
        print(puppies)
    }


}

