//
//  Event.swift
//  Scheduloo
//
//  Created by Roger Cui on 2014-06-17.
//  Copyright (c) 2014 Roger Cui. All rights reserved.
//

import Foundation

class Event : NSObject {
    var eventId: Int
    var name: String
    var date: String
    var startTime: String
    var endTime: String
    var locationName: String
    var site: String
    var timeIndex: Int
    
    init (id: Int, name: String, date: String, startTime: String, endTime: String, locationName: String, site: String, timeIndex: Int) {
        self.eventId = id
        self.date = date
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.locationName = locationName
        self.site = site
        self.timeIndex = timeIndex
    }
}