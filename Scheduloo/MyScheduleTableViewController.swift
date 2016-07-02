//
//  MyScheduleTableViewController.swift
//  Scheduloo
//
//  Created by Kevin Sito on 2014-06-10.
//  Copyright (c) 2014 Kevin Sito. All rights reserved.
//

import UIKit

@objc(MyScheduleTableViewController)class MyScheduleTableViewController: UITableViewController, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    var remoteConn = RemoteConnection()
    var connData: NSArray = NSArray()
    var myCourses: Array<Course> = []

    init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //loadInitialData()
        //retrieveData("2014-6-27", n:  7)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    /*func loadInitialData() {
        var test = Course(theId:1, subCode:"CS", subCatalog:"135", sec:"001")
        self.myCourses.append(test)
        var test2 = Course(theId:2, subCode:"ECON", subCatalog:"101", sec:"002")
        self.myCourses.append(test2)
        
        
    }*/
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.myCourses.count
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let CellIndentifier: NSString = "ListPrototypeCell"

        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellIndentifier) as UITableViewCell
        var theCourse: Course = self.myCourses[indexPath.row] as Course
        
        cell.textLabel.text = theCourse.subjectCode + theCourse.subjectCatalog + " - " + theCourse.section
        cell.detailTextLabel.text = theCourse.startTime + " - " + theCourse.endTime
        return cell
    }

    @IBAction func unwindToSchedule(segue: UIStoryboardSegue) {
        /*var source: AddCourseViewController = segue.sourceViewController as AddCourseViewController
        
        if var theCourse: Course = source.newCourse {
            var url = NSURL(string: "http://secret-oasis-8161.herokuapp.com/services/course/add-course-user")
            var request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            
            var data = ["courseId":"3534", "userId":"0"] as NSDictionary
            //var requestBodyData: NSData = dataString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) as NSData
            //let encodedData = (data as NSDictionary).dataUsingEncoding(NSUTF8StringEncoding)
            
            //request.HTTPBody = NSJSONSerialization.dataWithJSONObject(data, options: nil, error: nil)
            //request.HTTPBody = re
            //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            var connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
            
            println("sending request...")
            
            connection.start()
            
            
            //self.myCourses.append(theCourse)
            //self.tableView.reloadData()
        }
        
        print("acd")*/
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView?, moveRowAtIndexPath fromIndexPath: NSIndexPath?, toIndexPath: NSIndexPath?) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView?, canMoveRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
