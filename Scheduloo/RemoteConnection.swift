//
//  RemoteConnection.swift
//  Scheduloo
//
//  Created by Kevin Sito on 2014-06-21.
//  Copyright (c) 2014 Kevin Sito. All rights reserved.
//

import UIKit

class RemoteConnection: NSObject {
    var data: NSMutableData = NSMutableData()
    var jsonData: NSArray = NSArray()
    
    func connect(query:NSString) {
        var url =  NSURL.URLWithString("http://secret-oasis-8161.herokuapp.com/services/course")
        var request = NSURLRequest(URL: url)
        var conn = NSURLConnection(request: request, delegate: self, startImmediately: true)
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        self.data = NSMutableData()
        println("didReceiveResponse")
    }
    
    func connection(connection: NSURLConnection!, didReceiveData conData: NSData!) {
        self.data.appendData(conData)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var err: NSError
        
        var jsonResult: NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
        //jsonData = jsonResult as NSDictionary
        
        if jsonResult.count>0 {
            self.jsonData = jsonResult
            //println(jsonData)
        }
    }
    
    deinit {
        println("deiniting")
    }
}