//
//  Glucose.swift
//  TypeOneTwo
//
//  Created by andrew on 9/6/14.
//  Copyright (c) 2014 TypeOneTwo. All rights reserved.
//

class Glucose {
    var level: Double // mg/dL
    var date: NSDate

    private var asParseObject: PFObject {
        return PFObject(className: "Glucose", dictionary: [
            "level": level,
             "date": date])
    }

    init(level: Double, date: NSDate) {
        self.level = level
        self.date = date
    }

    convenience init(parseObject: PFObject) {
        let level = parseObject["level"] as Double
        let date = parseObject["date"] as NSDate
        self.init(level: level, date: date)
    }

    func save() {
        asParseObject.saveInBackground()
    }

    func delete() {
        asParseObject.deleteInBackground()
    }

    func saveInBackgroundWithBlock(block: PFBooleanResultBlock!) {
        asParseObject.saveInBackgroundWithBlock(block)
    }

}
