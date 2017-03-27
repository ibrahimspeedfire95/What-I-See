//
//  DBFace+CoreDataProperties.swift
//  What I See
//
//  Created by ibrahim al-khatib on 3/26/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import Foundation
import CoreData


extension DBFace {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBFace> {
        return NSFetchRequest<DBFace>(entityName: "Face");
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var recognizedUser: DBRecognizedUser?

}
