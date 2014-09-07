//
//  Glucose.swift
//  TypeOneTwo
//
//  Created by andrew on 9/6/14.
//  Copyright (c) 2014 TypeOneTwo. All rights reserved.
//

import HealthKit

class Glucose {
    var level: Double // mg/dL
    var date: NSDate

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
        PFObject(className: "Glucose", dictionary: [
            "level": level,
            "date": date]).saveInBackground()
        saveToHealthKit()
    }

    func delete() {
        PFObject(className: "Glucose", dictionary: [
            "level": level,
            "date": date]).deleteInBackground()
        deleteFromHealthKit()
    }

    func saveInBackgroundWithBlock(block: PFBooleanResultBlock!) {
        PFObject(className: "Glucose", dictionary: [
            "level": level,
            "date": date]).saveInBackgroundWithBlock(block)
        saveToHealthKit()
    }

    func saveToHealthKit() {
        let mgPerdL = HKUnit(fromString: "mg/dL")
        let glucoseQuantity = HKQuantity(unit: mgPerdL, doubleValue: level)
        let bloodGlucoseType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodGlucose)
        let glucoseSample = HKQuantitySample(type: bloodGlucoseType, quantity: glucoseQuantity, startDate: date, endDate: date)

        healthStore.saveObject(glucoseSample, withCompletion: nil)
    }

    func deleteFromHealthKit() {
        let mgPerdL = HKUnit(fromString: "mg/dL")
        let glucoseQuantity = HKQuantity(unit: mgPerdL, doubleValue: level)
        let bloodGlucoseType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodGlucose)
        let glucoseSample = HKQuantitySample(type: bloodGlucoseType, quantity: glucoseQuantity, startDate: date, endDate: date)
        let sampleType: HKSampleType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodGlucose)
        let predicate = NSPredicate(format: "(%K = %@) and endDate = %@", HKPredicateKeyPathQuantity, glucoseQuantity, date)
        let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate,
            limit: 0, sortDescriptors: [timeSortDescriptor]) { (query, results, error) in
                println(query)
                println(error)
                println(results)
        }

        healthStore.executeQuery(query)
    }
}
//        let query = HKSampleQuery(sampleType: HKQuantityType.quantityTypeForIdentifier( HKQuantityTypeIdentifierBloodGlucose as String) as HKSampleType, predicate: nil,
//            limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
//                if results == nil {
//                    println("no results")
//                    return
//                }
//                
//                if results.count > 0 {
//                    
//                    healthStore.deleteObject(glucoseSample, withCompletion: { (success, error) in
//                        if success {
//                            println("yup")
//                        } else {
//                            println(error.localizedDescription)
//                        }
//                    })
//                }
//        }
//    }
