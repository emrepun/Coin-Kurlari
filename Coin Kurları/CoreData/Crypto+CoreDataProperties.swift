//
//  Crypto+CoreDataProperties.swift
//  Coin Kurları
//
//  Created by Emre HAVAN on 25.12.2017.
//  Copyright © 2017 Emre HAVAN. All rights reserved.
//
//

import Foundation
import CoreData


extension Crypto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Crypto> {
        return NSFetchRequest<Crypto>(entityName: "Crypto")
    }

    @NSManaged public var coinName: String?
    @NSManaged public var coinAmount: Double

}
