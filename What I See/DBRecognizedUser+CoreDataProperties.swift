//
//  DBRecognizedUser+CoreDataProperties.swift
//  What I See
//
//  Created by ibrahim al-khatib on 3/26/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import Foundation
import CoreData


extension DBRecognizedUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBRecognizedUser> {
        return NSFetchRequest<DBRecognizedUser>(entityName: "RecognizedUser");
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var updateAt: NSDate?
    @NSManaged public var faces: NSSet?

}

// MARK: Generated accessors for faces
extension DBRecognizedUser {

    @objc(addFacesObject:)
    @NSManaged public func addToFaces(_ value: DBFace)

    @objc(removeFacesObject:)
    @NSManaged public func removeFromFaces(_ value: DBFace)

    @objc(addFaces:)
    @NSManaged public func addToFaces(_ values: NSSet)

    @objc(removeFaces:)
    @NSManaged public func removeFromFaces(_ values: NSSet)

}
