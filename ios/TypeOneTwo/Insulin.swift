//
//  Insulin.swift
//  TypeOneTwo
//
//  Created by andrew on 9/6/14.
//  Copyright (c) 2014 TypeOneTwo. All rights reserved.
//

class Insulin {
    var type: InsulinType
    var dose: Float
    var date: NSDate

    private var asParseObject: PFObject {
        return PFObject(className: "Insulin", dictionary: [
            "type": type.toRaw(),
            "dose": dose,
            "date": date])
    }

    init(type: InsulinType, dose: Float, date: NSDate) {
        self.type = type
        self.dose = dose
        self.date = date
    }

    convenience init(parseObject: PFObject) {
        let type = parseObject["level"] as Int
        let dose = parseObject["level"] as Float
        let date = parseObject["date"] as NSDate
        self.init(type: InsulinType.fromRaw(type)!, dose: dose, date: date)
    }

    func saveInBackgroundWithBlock(block: PFBooleanResultBlock) {
        asParseObject.saveInBackgroundWithBlock(block)
    }

    func delete() {
        asParseObject.deleteInBackground()
    }
}

enum InsulinType: Int {
    case RapidActing = 0
    case LongActing = 1
}
