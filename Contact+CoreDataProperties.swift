//
//  Contact+CoreDataProperties.swift
//  CoreDataFun
//
//  Created by Gil Estes on 10/2/20.
//  Copyright © 2020 Cal30. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var areaCode: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phone: String?
    @NSManaged public var id: UUID?
    @NSManaged public var address: Address?

    public var wrappedAreaCode: String {
        areaCode ?? "Unknown Area Code"
    }

    public var wrappedPhone: String {
        phone ?? "Unknown Phone"
    }

    public var wrappedFirstName: String {
        firstName ?? "Unknown First Name"
    }

    public var wrappedLastName: String {
        lastName ?? "Unknown Last Name"
    }

    public var fullName: String {
        return "\(wrappedFirstName) \(wrappedLastName)"
    }

    public var fullBySurname: String {
        return "\(wrappedLastName), \(wrappedFirstName)"
    }
}
