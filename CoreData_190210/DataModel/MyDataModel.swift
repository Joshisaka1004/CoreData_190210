//
//  MyDataModel.swift
//  CoreData_190210
//
//  Created by Joachim Vetter on 13.02.19.
//  Copyright © 2019 Joachim Vetter. All rights reserved.
//

import Foundation
import RealmSwift

class MyDataModel: Object {
    @objc dynamic var myAge: Int = 0
    @objc dynamic var herName: String = ""
}
