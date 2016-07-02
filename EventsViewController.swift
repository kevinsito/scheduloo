//
//  EventsViewController.swift
//  Scheduloo
//
//  Created by Roger Cui on 2014-07-04.
//  Copyright (c) 2014 Kevin Sito. All rights reserved.
//
import Foundation
import UIKit


class EventsViewController: UITableViewController {
    @IBOutlet var navItem: UINavigationItem
    
    // Handles when user clicks next Month
    @IBAction func goNextDay(sender : AnyObject) {
        viewDate = viewDate.dateByAddingTimeInterval(60*60*24)
        dataArr = DataRepository.getEventSchedule(viewDate, numOfDays: 1)
        self.tableView.reloadData()
    }
    
    // Handles when user clicks previous Month
    @IBAction func goPrevDay(sender : AnyObject) {
        viewDate = viewDate.dateByAddingTimeInterval(-60*60*24)
        dataArr = DataRepository.getEventSchedule(viewDate, numOfDays: 1)
        self.tableView.reloadData()
    }
    
    var dataArr : Dictionary<String, Event[]>[] = []
    var months : String[] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "Decemeber"]
    var weekdays : String[] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var numDaysInMonth : Integer[] = [31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31]
    var edited : Bool = false
    var viewDate : NSDate = NSDate()    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial calendar load
        viewDate = NSDate()


        dataArr = DataRepository.getEventSchedule(viewDate, numOfDays: 1)
        navItem.title = "Daily Events"
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        /*if (currMonth == viewMonth) {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 3), atScrollPosition: UITableViewScrollPosition.None, animated: false)
        }*/
        //dataArr = MyScheduleTableViewController.retrieveData(finalString, n: 30)
        //self.tableView.reloadData()
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
        cell!.locationName.text = "No friends are attending this event"
        
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
        
        let weekday : String = weekdays[dateComponents[2].toInt()! % 7]
        let viewMonth : String = months[dateComponents[1].toInt()! - 1]
        return "\(weekday) \(viewMonth) \(dateComponents[2])"
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var cell: EventCell? = tableView.cellForRowAtIndexPath(indexPath) as EventCell!
        //print(cell!.endTime.text)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return dataArr.count
    }
    
    override func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 32;
        }
        return 22;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        var segueController : EventDetailsViewController = segue.destinationViewController as EventDetailsViewController
        let indexPath = tableView.indexPathForSelectedRow()
        var cell: EventCell = tableView.cellForRowAtIndexPath(indexPath) as EventCell
        segueController.setEventCell(cell)
    }
}