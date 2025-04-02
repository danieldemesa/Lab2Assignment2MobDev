//
//  Product+CoreDataProperties.swift
//  A2_iOS_ Daniel_101440281
//
//  Created by daniel demesa on 2025-04-01.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var productID: Int32
    @NSManaged public var productName: String?
    @NSManaged public var productDescription: String?
    @NSManaged public var productPrice: NSDecimalNumber?
    @NSManaged public var productProvider: String?

}

extension Product : Identifiable {

}
