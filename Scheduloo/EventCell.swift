//
//  TableCell.swift
//  Scheduloo
//
//  Created by Roger Cui on 2014-06-09.
//  Copyright (c) 2014 Roger Cui. All rights reserved.
//


import Foundation

class EventCell: UITableViewCell {
    @IBOutlet var startTime: UILabel
    @IBOutlet var endTime: UILabel
    @IBOutlet var eventName: UILabel
    @IBOutlet var locationName: UILabel
    @IBOutlet var seperatorLabel: UILabel
    
    var event: Event? = nil
}