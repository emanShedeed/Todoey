//
//  Item.swift
//  Todoey
//
//  Created by user137691 on 9/25/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title:String=""
    @objc dynamic var checked:Bool=false
    var parentCategory=LinkingObjects(fromType: Category.self, property: "items")
    
}
