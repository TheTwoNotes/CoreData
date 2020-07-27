//
//  Address+CoreDataProperties.swift
//  CoreDataFun
//
//  Created by Gil Estes on 7/27/20.
//  Copyright © 2020 Cal30. All rights reserved.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var street: String?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var zipCode: String?
    @NSManaged public var contact: Contact?

    public var wrappedStreet: String {
        street ?? "Unknown Street"
    }

    public var wrappedCity: String {
        city ?? "Unknown City"
    }

    public var wrappedState: String {
        state ?? "Unknown State"
    }

    public var wrappedZipCode: String {
        zipCode ?? "Unknown Zip Code"
    }
}
