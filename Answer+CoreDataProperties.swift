//
//  Answer+CoreDataProperties.swift
//  Pythagorean
//
//  Created by Ioannis on 11/3/21.
//
//

import Foundation
import CoreData


extension Answer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Answer> {
        return NSFetchRequest<Answer>(entityName: "Answer")
    }

    @NSManaged public var kind: String?
    @NSManaged public var date: Date?
    @NSManaged public var textOfAnswer: String?

}

extension Answer : Identifiable {

}
