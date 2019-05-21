//
//  Item.swift
//  Todoey
//
//  Created by Mozart Falcão on 20/05/19.
//  Copyright © 2019 Mozart Falcão. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done : Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
}
