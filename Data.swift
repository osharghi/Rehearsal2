//
//  Data.swift
//  Rehearsal
//
//  Created by Omid Sharghi on 5/30/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import Foundation
import CoreData

public struct SongObj {
    var title: String
    var versions: [VersionObj]
    var collapsed: Bool
    let dataObj: NSManagedObject
    
    public init(title: String, versions: [VersionObj], collapsed: Bool = false, dataObj: NSManagedObject) {
        self.title = title
        self.versions = versions
        self.collapsed = collapsed
        self.dataObj = dataObj
    }
}

public struct VersionObj {
    var num: Int
//    var date: String
    var date: Date

    var lastPathComp: String
    let dataObj: NSManagedObject
    
//    public init(num: Int, date: String, url: String, dataObj: NSManagedObject) {
    public init(num: Int, date: Date, lastPathComp: String, dataObj: NSManagedObject) {

        self.num = num
        self.date = date
        self.lastPathComp = lastPathComp
        self.dataObj = dataObj
    }
}
