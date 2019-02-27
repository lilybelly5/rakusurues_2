//
//  Memo+CoreDataClass.swift
//  
//
//  Created by 石川陽子 on 2019/02/26.
//
//

import Foundation
import CoreData

@objc(Memo)
public class Memo: NSManagedObject {
    
    @NSManaged public var company: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var memoDate: String?
    @NSManaged public var memoNum: String?
    @NSManaged public var memoText: String?
    @NSManaged public var title: String?
    
    @objc var sectionDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: self.createdAt! as Date)
    }
    @objc var company:String {
        return company
    }
}
