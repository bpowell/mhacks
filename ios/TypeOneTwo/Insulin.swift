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

    init(type: InsulinType, dose: Float, date: NSDate) {
        self.type = type
        self.dose = dose
        self.date = date
    }

    func saveInBackgroundWithBlock(block: PFBooleanResultBlock) {
        PFObject(className: "Insulin", dictionary: [
            "type": type.toRaw(),
            "dose": dose,
            "date": date]).saveInBackgroundWithBlock(block)
    }
}

enum InsulinType: Int {
    case RapidActing = 0
    case LongActing = 1
}
