//
//  Entry+CoreDataProperties.swift
//  Travelogue
//
//  Created by Kyle Moore on 12/6/18.
//  Copyright © 2018 Kyle Moore. All rights reserved.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var body: String?
    @NSManaged public var image: NSData?
    @NSManaged public var modDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var trip: Trip?

}
