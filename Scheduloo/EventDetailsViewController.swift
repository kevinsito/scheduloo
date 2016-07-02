//
//  EventDetailsViewController.swift
//  Scheduloo
//
//  Created by Roger Cui on 2014-07-12.
//  Copyright (c) 2014 Scheduloo. All rights reserved.
//

import Foundation


class EventDetailsViewController : UIViewController, GMSMapViewDelegate {
    @IBOutlet var startTime : UILabel
    @IBOutlet var endTime : UILabel
    @IBOutlet var categoryName : UILabel
    @IBOutlet var eventName : UILabel
    @IBOutlet var date : UILabel
    @IBOutlet var eventDesc : UITextView
    @IBOutlet var eventUrl : UITextView
    @IBOutlet var mapView : GMSMapView
    @IBOutlet var addButton : UIButton
    @IBOutlet var linkLabel : UILabel
    
    var eventCell : EventCell = EventCell()
    var eventID : Int = 0
    var eventSite: String = ""
    var eventDetails = Dictionary<String, AnyObject>()
    
    override func viewDidLoad() {
        eventUrl.editable = false
        eventDesc.editable = false
        eventUrl.dataDetectorTypes = UIDataDetectorTypes.Link
        startTime.text = eventCell.startTime.text
        endTime.text = eventCell.endTime.text
        eventName.text = eventCell.eventName.text
        date.text = eventCell.event!.date
        
        var cellsEvent : Event = eventCell.event!
        self.eventID = cellsEvent.eventId
        self.eventSite = cellsEvent.site
        
        var target: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        
        if (cellsEvent is Course) {
            var cellsEvent : Course = eventCell.event! as Course
            
            self.eventDetails = DataRepository.getCourseDetails(cellsEvent.subjectCode, subCatalog: cellsEvent.subjectCatalog)
            
            var title : AnyObject = eventDetails["description"]!
            categoryName.text = title as String
            eventDesc.text = "No Description"
            eventUrl.text = ""
            linkLabel.hidden = true
        }
        else {
            self.eventDetails = DataRepository.getEventDetails(self.eventID, eventSite: self.eventSite)
            
            var category : AnyObject = eventDetails["category"]!
            categoryName.text = category as String
            var theDesc : AnyObject = eventDetails["description"]!
            eventDesc.text = theDesc as String
            var theUrl : AnyObject = eventDetails["link"]!
            eventUrl.text = theUrl as String
        }
        
        
        var lat1 : AnyObject = eventDetails["latitude"]!
        var long1 : AnyObject = eventDetails["longitude"]!
        
        let lat : CLLocationDegrees = lat1 as CLLocationDegrees
        let long : CLLocationDegrees = long1 as CLLocationDegrees
        
        println()
        println("The lat: \(lat) The long: \(long)")
        println()
        
        target = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.position = CLLocationCoordinate2DMake(lat, long)
        
        var camera: GMSCameraPosition = GMSCameraPosition(target: target, zoom: 18, bearing: 0, viewingAngle: 0)
        
        mapView.camera = camera
        mapView.delegate = self
        mapView.myLocationEnabled = true
        
        
        
        marker.title = "Sydney";
        marker.snippet = "Australia";
        marker.map = mapView
        
        
    }
    
    @IBAction func addEventToCalendar(sender : AnyObject) {
        var retCode = DataRepository.addEvent(self.eventID, eventSite: self.eventSite, delegate: self)
        
        var alert = UIAlertView()
        alert.title = "Scheduloo"
        alert.addButtonWithTitle("OK")
        alert.message = "Successfully added event!"
        alert.show()
        let updateCalendarNote = NSNotification(name: "updateCalendar", object: nil)
        NSNotificationCenter.defaultCenter().postNotification(updateCalendarNote);
        sleep(2)
        
    }
    
    func setEventCell(p_eventCell : EventCell) {
        self.eventCell = p_eventCell
    }
}