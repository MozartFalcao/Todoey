//
//  Category.swift
//  Todoey
//
//  Created by Mozart Falcão on 20/05/19.
//  Copyright © 2019 Mozart Falcão. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {

    @objc dynamic var name: String = ""
    let items = List<Item>()
    
    
}
