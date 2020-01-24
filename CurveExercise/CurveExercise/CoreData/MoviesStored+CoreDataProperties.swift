//
//  MoviesStored+CoreDataProperties.swift
//  

import Foundation
import CoreData


extension MoviesStored {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviesStored> {
        return NSFetchRequest<MoviesStored>(entityName: "MoviesStored")
    }

    @NSManaged public var date: String
    @NSManaged public var name: String
    @NSManaged public var voteAvg: String
    @NSManaged public var isFav: Bool
    @NSManaged public var id: Int32

}
