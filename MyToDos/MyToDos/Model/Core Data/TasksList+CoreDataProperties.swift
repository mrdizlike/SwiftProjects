//
//  TasksList+CoreDataProperties.swift
//  MyToDos
//
//  Created by Виктор on 08.04.2023.
//
//

import Foundation
import CoreData


extension TasksList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TasksList> {
        return NSFetchRequest<TasksList>(entityName: "TasksList")
    }

    @NSManaged public var icon: String?
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var tasks: Task?

}

extension TasksList : Identifiable {

}
