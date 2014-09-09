//
//  EnterViewController.swift
//  TypeOneTwo
//
//  Created by andrew on 9/6/14.
//  Copyright (c) 2014 TypeOneTwo. All rights reserved.
//

import HealthKit

class EnterViewController: UITableViewController {

    var objects = [AnyObject]()
    var oldObjects:[AnyObject]!
    var glucoseQueried = false, insulinQueried = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let readDataTypes = NSSet(object: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodGlucose))
        healthStore.requestAuthorizationToShareTypes(nil, readTypes: readDataTypes) { (success, error) in
            if !success {
                return
            }
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterForeground",
            name: UIApplicationWillEnterForegroundNotification, object: nil)
    }

    func didEnterForeground() {
        syncWithHealthKit()
    }

    func syncWithHealthKit() {
        let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: HKQuantityType.quantityTypeForIdentifier(
            HKQuantityTypeIdentifierBloodGlucose as String) as HKSampleType, predicate: nil,
            limit: 0, sortDescriptors: [timeSortDescriptor]) { (query, results, error) in
                if results == nil {
                    return
                }

                if results.count > 0 {
                    self.retrievedGlucoseSamples(results)
                }
        }
        healthStore.executeQuery(query)
    }

    func retrievedGlucoseSamples(samples: [AnyObject]!) {
        for sample in samples {
            pushSampleToParseIfNew(sample as HKQuantitySample)
        }
    }

    func pushSampleToParseIfNew(sample: HKQuantitySample) {
        let query = PFQuery(className: "Glucose")
        query.whereKey("date", equalTo: sample.endDate)
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if objects.count == 0 {
                let unit = HKUnit(fromString: "mg/dL")
                let level = sample.quantity.doubleValueForUnit(unit)
                PFObject(className: "Glucose", dictionary: [
                    "level": level,
                    "hk": true,
                    "date": sample.endDate]).saveInBackground()
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        syncWithHealthKit()
        populateArrays()
    }

    func populateArrays() {
        oldObjects = objects
        objects.removeAll(keepCapacity: false)
        glucoseQueried = false
        insulinQueried = false

        let completion: () -> () = {
            [weak self] in
            // After querying both arrays...
            if self!.glucoseQueried && self!.insulinQueried {

                // Sort the cumulative array.
                self!.objects.sort() {
                    ($0["date"] as NSDate).compare($1["date"] as NSDate)
                        == NSComparisonResult.OrderedDescending
                }

                // Check for array equality and only reload if they're unequal.
                if self!.oldObjects.count != self!.objects.count {
                    // Different lengths.
                    self!.tableView.reloadData()
                } else {
                    for i in 0..<self!.objects.count {
                        if self!.objects[i] as PFObject != self!.oldObjects[i] as PFObject {
                            // Sorted but different objects in the same position.
                            self!.tableView.reloadData()
                            break
                        }
                    }
                }
            }
        }

        // Query for Glucose.
        var query = PFQuery(className: "Glucose")
        query.findObjectsInBackgroundWithBlock { (glucoses, error) in
            for glucose in glucoses {
                self.objects.append(glucose)
            }
            self.glucoseQueried = true
            completion()
        }

        // Query for Insulin.
        query = PFQuery(className: "Insulin")
        query.findObjectsInBackgroundWithBlock { (insulins, error) in
            for insulin in insulins {
                self.objects.append(insulin)
            }
            self.insulinQueried = true
            completion()
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) in
            (self.objects[indexPath.row] as PFObject).deleteInBackground()
            self.objects.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        return [deleteAction]
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }

    let types = [InsulinType.RapidActing.toRaw(): "Rapid-Acting", InsulinType.LongActing.toRaw(): "Long-Acting"]
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var object: PFObject
        switch indexPath.row {
        case 0..<objects.count:
            object = objects[indexPath.row] as PFObject
        default:
            object = oldObjects[indexPath.row] as PFObject
        }

        if object.parseClassName == "Glucose" {
            // Set the level label.
            let cell = tableView.dequeueReusableCellWithIdentifier("glucoseCell") as GlucoseCell
            cell.heartImage.hidden = true
            cell.levelLabel.text = String(object["level"] as Int) + " mg/dL"

            // Set the date.
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "M/d/yy h:mm"
            let dateString = dateFormatter.stringFromDate(object["date"] as NSDate)
            cell.dateLabel.text = dateString


            // If from HealthKit, unhide the heart icon.
            if object["hk"] != nil {
                cell.heartImage.hidden = false
            }

            return cell
        } else if object.parseClassName == "Insulin" {
            // Set the type label.
            let cell = tableView.dequeueReusableCellWithIdentifier("insulinCell") as InsulinCell
            let index = object["type"] as Int
            let text = types[index]
            cell.typeLabel.text = text

            // Set the dose label.
            let dose = object["dose"] as Float
            cell.doseLabel.text = "\(dose) units"
            // Set the date.
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "M/d/yy h:mm"
            let dateString = dateFormatter.stringFromDate(object["date"] as NSDate)
            cell.dateLabel.text = dateString
            return cell
        } else {
            fatalError("Unknown parseClassName")
        }
    }

}
