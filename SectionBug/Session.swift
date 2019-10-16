//
//  Session+CoreDataClass.swift
//  SectionBug
//
//  Created by Yonat Sharon on 16/10/2019.
//  Copyright © 2019 Yonat Sharon. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Session)
public class Session: NSManagedObject {
    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var phase: Int16
}
