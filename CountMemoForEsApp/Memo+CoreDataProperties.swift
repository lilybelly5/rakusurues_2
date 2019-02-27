//
//  Memo+CoreDataProperties.swift
//  
//
//  Created by 石川陽子 on 2019/02/26.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var company: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var memoDate: String?
    @NSManaged public var memoNum: String?
    @NSManaged public var memoText: String?
    @NSManaged public var title: String?

}
