//
//  FirstViewController.swift
//  Scheduloo
//
//  Created by Roger Cui on 2014-06-09.
//  Copyright (c) 2014 Roger Cui. All rights reserved.
//
import Foundation
import UIKit

class CalendarController: UITableViewController, UIAlertViewDelegate {
     @IBOutlet var navItem: UINavigationItem
    
    // Handles when user clicks next Month
    @IBAction func goNextMonth(sender : AnyObject) {
        viewMonth += 1;
        if (viewMonth > 12) {
            viewYear += 1
            viewMonth = 1
        }
        navItem.title = "\(months[viewMonth - 1]) \(viewYear)"
        dataArr = DataRepository.getCourseSchedule("\(viewYear)-\(viewMonth)-1", n: 30)
        self.tableView.reloadData()
    }
    
    func reloadThisMonth(note : NSNotification) {
        navItem.title = "\(months[viewMonth - 1]) \(viewYear)"
        dataArr = DataRepository.getCourseSchedule("\(viewYear)-\(viewMonth)-1", n: 30)
        self.tableView.reloadData()
        print("reloaded month")
        self.refreshControl.endRefreshing()
        
    }
    
    // Handles when user clicks previous Month
    @IBAction func goPrevMonth(sender : AnyObject) {
        viewMonth -= 1;
        if (viewMonth < 1) {
            viewMonth = 12
            viewYear -= 1
        }
        navItem.title = "\(months[viewMonth - 1]) \(viewYear)"
        dataArr = DataRepository.getCourseSchedule("\(viewYear)-\(viewMonth)-1", n: 30)
        self.tableView.reloadData()
    }
    
    var dataArr : Dictionary<String, Event[]>[] = []
    var months : String[] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "Decemeber"]
    var weekdays : String[] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var numDaysInMonth : Integer[] = [31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31]
    var currMonth : Int = 0
    var viewMonth : Int = 0
    var viewYear : Int = 0
    var currYear : Int = 0
    var currDay : Int = 0
    var curDaySection : Int = 1
    var changed : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        // Initial calendar load
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        let stringDate = formatter.stringFromDate(date)
        let dateComponents : Array<String> = stringDate.componentsSeparatedByString("/")
        self.currMonth = dateComponents[0].toInt()!
        self.viewMonth = currMonth
        self.currYear = dateComponents[2].toInt()! + 2000
        self.viewYear = currYear
        self.currDay = dateComponents[1].toInt()!
        var finalString = "\(currYear)-\(currMonth)-1"
        dataArr = DataRepository.getCourseSchedule(finalString, n: 30)
        navItem.title = "\(months[currMonth - 1]) \(viewYear)"
        
        // Preload Settings view
        tabBarController.viewControllers[3].view
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadThisMonth:", name: "updateCalendar", object: nil)
        
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull Down to Refresh")
        refresh.addTarget(self, action: "reloadThisMonth:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //if (currMonth == viewMonth) {
        //    tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: curDaySection), atScrollPosition.: UITableViewScrollPosition.Top, animated: true)
        //}
        //dataArr = MyScheduleTableViewController.retrieveData(finalString, n: 30)
        //self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let eventCell = tableView.cellForRowAtIndexPath(indexPath) as EventCell!
            
            if (eventCell.event is Course) {
                
                let course : Course = eventCell.event as Course!

                DataRepository.deleteCourse(course.id, userID: 0)
                var alert = UIAlertView()
                alert.title = "Scheduloo"
                alert.addButtonWithTitle("OK")
                alert.message = "Your course has been deleted. Pull down to refresh!"
                alert.show()

            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> EventCell!
    {
        var cell: EventCell? = tableView.dequeueReusableCellWithIdentifier("myCell") as EventCell!
        if (cell == nil) {
            cell = EventCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "myCell")
            
        }
        let dictionary = dataArr[indexPath.section]
        let array = Array(dictionary.values)[0]
        let event = array[indexPath.row]
        
        cell!.event = event
        cell!.startTime.text = "\(event.startTime)"
        cell!.endTime.text = "\(event.endTime)"
        cell!.eventName.text = "\(event.name)"
        
        if (event is Course) {
            cell!.seperatorLabel.backgroundColor = UIColor.blueColor()
            cell!.locationName.text = "No friends are enrolled in this course"
        } else {
            cell!.seperatorLabel.backgroundColor = UIColor.greenColor()
            cell!.locationName.text = "No friends are attending this event"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        let thisSection = dataArr[section]
        let values = Array(thisSection.values)[0]
        
        return values.count
    }
    
    // Custom section header style
    override func tableView(tableView: UITableView!, willDisplayHeaderView view: UIView!, forSection section: Int) {
        let header = view as UITableViewHeaderFooterView
        header.textLabel.textColor = UIColor.blackColor()
        header.textLabel.font = UIFont.boldSystemFontOfSize(16)
        let headerFrame = header.frame
        header.textLabel.frame = headerFrame;
        header.textLabel.text = header.textLabel.text.capitalizedString
    }
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        var thisSection: Dictionary<String, Event[]> = dataArr[section]
        let keys = Array(thisSection.keys)
        let date = keys[0]
        let dateComponents = date.componentsSeparatedByString("-")
        
        let day : Int = dateComponents[2].toInt()! % 7
        
        if (curDaySection == 0 && dateComponents[2].toInt()! >= currDay) {
            curDaySection = section
        }
        
        if (currDay == day && viewMonth == currMonth && currYear == viewYear) {
            return "Today"
        } else {
            return "\(weekdays[day]) \(months[viewMonth - 1]) \(dateComponents[2])"
        }
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return dataArr.count
    }
    
    override func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 22;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        var segueController : EventDetailsViewController = segue.destinationViewController as EventDetailsViewController
        let indexPath = tableView.indexPathForSelectedRow()
        var cell: EventCell = tableView.cellForRowAtIndexPath(indexPath) as EventCell!
        segueController.setEventCell(cell)
        segueController.addButton.hidden = true
    }
}