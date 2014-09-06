//
//  Insulin.swift
//  TypeOneTwo
//
//  Created by andrew on 9/6/14.
//  Copyright (c) 2014 TypeOneTwo. All rights reserved.
//

class Insulin {
    // required:
    var type: InsulinType
    var dose: Float // mg/dL
    var date: NSDate

    init(type: InsulinType, dose: Float, date: NSDate) {
        self.type = type
        self.dose = dose
        self.date = date
    }
}

enum InsulinType: Int {
    case LongLasting = 0
    case FastActing = 1
}
