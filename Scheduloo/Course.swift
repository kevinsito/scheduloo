//
//  Course.swift
//  Scheduloo
//
//  Created by Kevin Sito on 2014-06-11.
//  Copyright (c) 2014 Kevin Sito. All rights reserved.
//

import UIKit
import Foundation

class Course: Event {
    var id:Int
    var subjectCode:String
    var subjectCatalog:String
    var section:String
    var courseDate:String
   
    init(theId: Int, subCode:String, subCatalog:String, sec:String, start:String, end:String, date:String) {
        self.id = theId
        self.subjectCode = subCode
        self.subjectCatalog = subCatalog
        self.section = sec
        self.courseDate = date
        super.init(id: theId, name: "\(subCode) \(subCatalog)", date: courseDate, startTime: start, endTime: end, locationName: "", site: "", timeIndex: 0)

    }
}
