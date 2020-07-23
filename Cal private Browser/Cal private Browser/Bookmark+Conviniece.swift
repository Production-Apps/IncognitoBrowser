//
//  Task+Conviniece.swift
//  Cal private Browser
//
//  Created by FGT MAC on 7/23/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import Foundation
import CoreData

extension Bookmark {
    convenience init(title: String, url: URL, cat: String, context:
        NSManagedObjectContext = CoreDataStack.shared.mainContext ) {
        self.init(context: context)
        self.title = title
        self.url = url
        self.cat = cat
    }
}
