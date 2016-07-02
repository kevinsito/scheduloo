//
//  DataRepository.swift
//  Scheduloo
//
//  Created by Roger Cui on 2014-07-05.
//  Copyright (c) 2014 Scheduloo. All rights reserved.
//

import Foundation

class DataRepository : NSObject {
    
    class func addCourse(subCode: String, subCatalog: String, section: String, delegate: AnyObject) -> NSArray {
        let apiKey = "c6c7c1bf5b2270bef2e79392f012341a"
        var courseId = 0
        
        var getDataURL = "https://api.uwaterloo.ca/v2/courses/\(subCode)/\(subCatalog)/schedule.json?key=\(apiKey)"
        var url: NSURL = NSURL(string: getDataURL)
        var data: NSMutableData = NSMutableData(contentsOfURL: url)
        var error: NSError?
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
                
        var courseData : NSArray = jsonResult["data"] as NSArray
        
        if(courseData.count == 0){
            return courseData
        }
        
        for(var b = 0; b < courseData.count; b++) {
            var curSection: String = courseData[b].objectForKey("section") as String
            
            if curSection == ("LEC " + section) {
                courseId = courseData[b].objectForKey("class_number") as Int
            }
        }
        
        var addTableUrl = NSURL(string: "http://secret-oasis-8161.herokuapp.com/services/course/add-course-user")
        var request = NSMutableURLRequest(URL: addTableUrl)
        request.HTTPMethod = "POST"
        
        var addTableData = ["courseId":courseId, "userId": "10152519148432457"] as NSDictionary
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(addTableData, options: nil, error: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var connection = NSURLConnection(request: request, delegate: delegate, startImmediately: false)
        connection.start()
        
        return courseData
    }
    
    class func addEvent(eventId: Int, eventSite: String, delegate: AnyObject) -> Int {
        var addTableUrl = NSURL(string: "http://secret-oasis-8161.herokuapp.com/services/event/add-event-user")
        var request = NSMutableURLRequest(URL: addTableUrl)
        request.HTTPMethod = "POST"
        
        var addTableData = ["eventId":eventId, "eventSite": eventSite, "userId":"10152519148432457"] as NSDictionary
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(addTableData, options: nil, error: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var connection = NSURLConnection(request: request, delegate: delegate, startImmediately: false)
        connection.start()
        
        return 0
    }
    
    class func getCourseSchedule(date: String, n : Integer) -> Dictionary<String, Event[]>[]{
        print(date)
        var getDataURL = "http://secret-oasis-8161.herokuapp.com/services/course/10152519148432457/\(date)/\(n)"
        var url: NSURL = NSURL(string: getDataURL)
        var data: NSMutableData = NSMutableData(contentsOfURL: url)
        var error: NSError?
        var jsonResult: NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSArray
        var getEventURL = "http://secret-oasis-8161.herokuapp.com/services/event/10152519148432457/\(date)/\(n)"
        var eveUrl: NSURL = NSURL(string: getEventURL)
        var eveData: NSMutableData = NSMutableData(contentsOfURL: eveUrl)
        var eveError: NSError?
        var eveResult: NSArray = NSJSONSerialization.JSONObjectWithData(eveData, options: NSJSONReadingOptions.MutableContainers, error: &eveError) as NSArray
        
        var returnArr : Dictionary<String, Event[]>[] = []
        
        for(var a = 0; a < jsonResult.count; a++) {
            
            var day = Dictionary<String, Event[]>()
            
            var theDay:String = jsonResult[a].objectForKey("date") as String
            var theCoursesForDay: NSArray = jsonResult[a].objectForKey("courses") as NSArray
            var theEventsForDay: NSArray = eveResult[a].objectForKey("events") as NSArray
            
            var events : Event[] = []
            for (var i = 0; i < theCoursesForDay.count; i++) {
                var id: Int = theCoursesForDay[i].objectForKey("id") as Int
                var subCode: String = theCoursesForDay[i].objectForKey("subjectCode") as String
                var subCatalog: String = theCoursesForDay[i].objectForKey("subjectCatalog") as String
                var section: String = theCoursesForDay[i].objectForKey("section") as String
                var startTime: String = theCoursesForDay[i].objectForKey("startTime") as String
                var endTime: String = theCoursesForDay[i].objectForKey("endTime") as String
                var courseDate = theDay
                
                var theCourse = Course(theId: id, subCode: subCode, subCatalog: subCatalog, sec: section, start: startTime, end: endTime, date:courseDate)
                events.append(theCourse)
            }
            
            // showing events on calendar
            for(var j = 0; j < theEventsForDay.count; j++) {
                var eventId : Int = theEventsForDay[j].objectForKey("eventId") as Int
                var eventDate : String = theDay
                var name : String = theEventsForDay[j].objectForKey("name") as String
                var startTime : String = theEventsForDay[j].objectForKey("startTime") as String
                var endTime : String = theEventsForDay[j].objectForKey("endTime") as String
                var locationName = ""
                var site : String = theEventsForDay[j].objectForKey("site") as String
                
                var theEvent = Event(id: eventId, name: name, date: eventDate, startTime: startTime, endTime: endTime, locationName: locationName, site: site, timeIndex: 0)
                events.append(theEvent)
            }
            
            if (events.count > 0) {
                day[theDay] = events
                returnArr.append(day)
            }
            
        }
        
        return returnArr
    }
    
    class func getEventSchedule(date: NSDate, numOfDays : Int) -> Dictionary<String, Event[]>[] {
        var returnArr : Dictionary<String, Event[]>[] = []
        
        let apiKey = "c6c7c1bf5b2270bef2e79392f012341a"
        var getDataURL = "https://api.uwaterloo.ca/v2/events.json?key=\(apiKey)"
        var url: NSURL = NSURL(string: getDataURL)
        var data: NSMutableData = NSMutableData(contentsOfURL: url)
        var error: NSError?
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        var eventData : NSArray = jsonResult["data"] as NSArray
        
        var day = Dictionary<String, Event[]>()
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        let stringDate = formatter.stringFromDate(date)
        let dateComponents : Array<String> = stringDate.componentsSeparatedByString("/")
        for(var b = 0; b < numOfDays; b++) {
            var currMonth = dateComponents[0].toInt()!
            var currDay = dateComponents[1].toInt()! + b
            var currYear = dateComponents[2].toInt()! + 2000
        
            var curDate = "\(currYear)-\(currMonth)-\(currDay)"
        
            if(currDay < 10) {
                curDate = "\(currYear)-\(currMonth)-0\(currDay)"
            }
            if(currMonth < 10) {
                curDate = "\(currYear)-0\(currMonth)-\(currDay)"
            }
            if(currMonth < 10 && currDay < 10) {
                curDate = "\(currYear)-0\(currMonth)-0\(currDay)"
            }
            
            day[curDate] = []
        }
        
        for(var a = 0; a < eventData.count; a++) {
            
            var curEvent: NSDictionary = eventData[a] as NSDictionary
            var curEventTimes : NSArray = curEvent["times"] as NSArray
            var events : Event[] = []
            
            for(var i = 0; i < curEventTimes.count; i++) {
                var theTime : NSString = curEventTimes[i].objectForKeyedSubscript("start") as NSString
                var shortTime = theTime.substringToIndex(10)
                
                var existIndex = day["\(shortTime)"]
                
                if(existIndex != nil) {
                    var events : Event[] = day["\(shortTime)"]!
                    
                    var eventId : Int = curEvent["id"] as Int
                    var eventDate : String = shortTime
                    var name : String = curEvent["title"] as String
                    var range : NSRange = NSMakeRange (11, 5);
                    var startTime : String = curEventTimes[i].objectForKeyedSubscript("start").substringWithRange(range) as String
                    var endTime : String = curEventTimes[i].objectForKeyedSubscript("end").substringWithRange(range) as String
                    var site : String = curEvent["site"] as String
                    var locationName = " "
                    var timeIndex = i
                    
                    var theEvent = Event(id: eventId, name: name, date: eventDate, startTime: startTime, endTime: endTime, locationName: locationName, site: site, timeIndex: timeIndex)
                    events.append(theEvent)
                    day["\(shortTime)"] = events
                }
            }
           
        }
        
        for(var c = 0; c < numOfDays; c++) {
            var currMonth = dateComponents[0].toInt()!
            var currDay = dateComponents[1].toInt()! + c
            var currYear = dateComponents[2].toInt()! + 2000
            
            var curDate = "\(currYear)-\(currMonth)-\(currDay)"
            
            if(currDay < 10) {
                curDate = "\(currYear)-\(currMonth)-0\(currDay)"
            }
            if(currMonth < 10) {
                curDate = "\(currYear)-0\(currMonth)-\(currDay)"
            }
            if(currMonth < 10 && currDay < 10) {
                curDate = "\(currYear)-0\(currMonth)-0\(currDay)"
            }
            
            var appendDay = Dictionary<String, Event[]>()
            
            var appendDate = curDate
            var appendEvents = day["\(curDate)"]
            
            appendDay[appendDate] = appendEvents
            
            returnArr.append(appendDay)
        }
        
        return returnArr
    }
    
    class func getCourseDetails(subCode: String, subCatalog: String) -> Dictionary<String, AnyObject> {
        var detArr = Dictionary<String, AnyObject>()
        
        let apiKey = "c6c7c1bf5b2270bef2e79392f012341a"
        var getDataURL = "https://api.uwaterloo.ca/v2/courses/\(subCode)/\(subCatalog)/schedule.json?key=\(apiKey)"
        var url: NSURL = NSURL(string: getDataURL)
        var data: NSMutableData = NSMutableData(contentsOfURL: url)
        var error: NSError?
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        var jsonData : NSArray = jsonResult["data"] as NSArray
        var desc : NSString = jsonData[0].objectForKey("title") as NSString
        var classes : NSArray = jsonData[0].objectForKey("classes") as NSArray
        var loc : NSDictionary = classes[0].objectForKey("location") as NSDictionary
        var locName = "No Location"
        var locLat : Double = 43.4689
        var locLong : Double = -80.5400
        
        if let buildCheck = loc["building"] as? String{
            locName = buildCheck
        }
        var getLocURL = "https://api.uwaterloo.ca/v2/buildings/\(locName).json?key=\(apiKey)"
        if let roomCheck = loc["room"] as? String{
            locName += roomCheck
        }
        
        var locUrl: NSURL = NSURL(string: getLocURL)
        var locData: NSMutableData = NSMutableData(contentsOfURL: locUrl)
        var locError: NSError?
        var jsonLocResult = NSJSONSerialization.JSONObjectWithData(locData, options: NSJSONReadingOptions.MutableContainers, error: &locError) as NSDictionary

        var locJsonData : NSDictionary = jsonLocResult["data"] as NSDictionary
        
        if let latCheck = locJsonData["latitude"] as? Double{
            locLat = latCheck
        }
        if let longCheck = locJsonData["longitude"] as? Double{
            locLong = longCheck
        }
        
        detArr["description"] = desc
        detArr["name"] = locName
        detArr["latitude"] = locLat
        detArr["longitude"] = locLong
        
        return detArr
    }
    
    class func getEventDetails(eventId: Int, eventSite: String) -> Dictionary<String, AnyObject> {
        var detArr = Dictionary<String, AnyObject>()
        
        let apiKey = "c6c7c1bf5b2270bef2e79392f012341a"
        var getDataURL = "https://api.uwaterloo.ca/v2/events/\(eventSite)/\(eventId).json?key=\(apiKey)"
        var url: NSURL = NSURL(string: getDataURL)
        var data: NSMutableData = NSMutableData(contentsOfURL: url)
        var error: NSError?
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        var jsonData : NSDictionary = jsonResult["data"] as NSDictionary
        var desc : NSString = jsonData["description"] as NSString
        var category : NSString = jsonData["site_name"] as NSString
        var link : NSString = jsonData["link"] as NSString
        var loc : NSDictionary = jsonData["location"] as NSDictionary
        var locName = "No Location"
        var locLat : Double = 43.4689
        var locLong : Double = -80.5400
        
        if let nameCheck = loc["name"] as? String{
            locName = nameCheck
        }
        
        if let latCheck = loc["latitude"] as? Double{
            locLat = latCheck
        }
        if let longCheck = loc["longitude"] as? Double{
            locLong = longCheck
        }

        detArr["description"] = desc
        detArr["category"] = category
        detArr["link"] = link
        detArr["name"] = locName
        detArr["latitude"] = locLat
        detArr["longitude"] = locLong
        
        return detArr
    }
    
    class func deleteCourse(courseID : Int, userID : Int) {
        var request = NSMutableURLRequest(URL: NSURL(string:"http://secret-oasis-8161.herokuapp.com/services/course/delete"))
        request.HTTPMethod = "POST"
        
        var deleteTableData = ["courseId":courseID, "userId": "10152519148432457"] as NSDictionary
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(deleteTableData, options: nil, error: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var connection = NSURLConnection(request: request, delegate: nil, startImmediately: false)
        connection.start()
    }
    
    
    class func getFriendsTakingCourse() {
        
    }
    

}