//
//  Note+CoreDataProperties.swift
//  Notes
//
//  Created by Евгений Борисов on 29.01.2024.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date!
    @NSManaged public var content: NSAttributedString?

}

extension Note : Identifiable {

}
