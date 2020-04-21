//
//  Title+CoreDataProperties.swift
//  FavoriteURLList
//
//  Created by 寺山和也 on 2020/04/21.
//  Copyright © 2020 寺山和也. All rights reserved.
//
//

import Foundation
import CoreData


extension Title {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Title> {
        return NSFetchRequest<Title>(entityName: "Title")
    }

    @NSManaged public var array: NSData?
    @NSManaged public var titleName: String?

}
