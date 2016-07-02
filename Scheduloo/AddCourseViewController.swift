//
//  AddCourseViewController.swift
//  Scheduloo
//
//  Created by Kevin Sito on 2014-06-10.
//  Copyright (c) 2014 Kevin Sito. All rights reserved.
//

import UIKit

class AddCourseViewController: UIViewController {
    
    @IBOutlet var subCodeField : UITextField
    @IBOutlet var subCatalogField : UITextField
    @IBOutlet var sectionField : UITextField
    @IBOutlet var doneButton : UIBarButtonItem

    var newCourse: Course = Course(theId: 0, subCode: "AA", subCatalog: "000", sec: "LEC000", start: "00:00", end: "00:00", date: "2014-01-01")
    
    let apiKey = "c6c7c1bf5b2270bef2e79392f012341a"
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (sender as? NSObject != self.doneButton){
            return
        }
        
        if self.subCodeField.text.utf16count <= 0 {
            //viewDidAppear(true)
        }

        if self.subCodeField.text.utf16count > 0 && self.subCatalogField.text.utf16count > 0 && self.sectionField.text.utf16count > 0 {
            self.newCourse = Course(theId: 0, subCode: self.subCodeField.text, subCatalog: self.subCatalogField.text, sec: self.sectionField.text, start: "00:00", end: "00:00", date:"2014-01-01")
        }
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    
    /*override func viewDidAppear(animated: Bool) {
        var alert = UIAlertController(title: "Incorrect Fields", message: "Please enter a course!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        /*alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter text:"
            textField.secureTextEntry = true
            })*/
        self.presentViewController(alert, animated: true, completion: nil)
    }*/
    
    @IBAction func addCourse(segue: UIStoryboardSegue) {
        var theCourses: NSArray = DataRepository.addCourse(self.subCodeField.text, subCatalog: self.subCatalogField.text, section: self.sectionField.text, delegate:self)
        
        var alert = UIAlertView()
        alert.title = "Scheduloo"
        alert.addButtonWithTitle("OK")
        if theCourses.count == 0 {
            alert.message = "Could not find course!"
        }
        else {
            alert.message = "Successfully added course!"
        }
        alert.show()

        let updateCalendarNote = NSNotification(name: "updateCalendar", object: nil)
        NSNotificationCenter.defaultCenter().postNotification(updateCalendarNote);
        sleep(2)
    }

}
