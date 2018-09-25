//
//  Category.swift
//  Todoey
//
//  Created by user137691 on 9/25/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name:String=""
    var items=List<Item>()
}
