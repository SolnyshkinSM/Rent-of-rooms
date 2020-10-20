//
//  ManagedObjectContext.swift
//  Rent of rooms
//
//  Created by Administrator on 10.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import Foundation
import CoreData

protocol ManagedObjectContext {
    var managedObjectContext: NSManagedObjectContext? {get set}
}
