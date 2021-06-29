//
//  SimpleTasks+CoreDataProperties.swift
//  Task
//
//  Created by Роман Мошковцев on 28.06.2021.
//
//

import Foundation
import CoreData

extension SimpleTasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SimpleTasks> {
        return NSFetchRequest<SimpleTasks>(entityName: "SimpleTasks")
    }

    @NSManaged public var date: Date?
    @NSManaged public var isComplete: Bool
    @NSManaged public var tags: [TagItem]?
    @NSManaged public var task: String?
    @NSManaged public var title: String?

}

extension SimpleTasks : Identifiable {

}
