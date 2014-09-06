//
//  EnterViewController.swift
//  TypeOneTwo
//
//  Created by andrew on 9/6/14.
//  Copyright (c) 2014 TypeOneTwo. All rights reserved.
//

class EnterViewController: UITableViewController {

    var objects = [AnyObject]()
    var glucoseQueried = false, insulinQueried = false

    override func viewDidLoad() {
        navigationItem.title = "TypeOneTwo"
        populateArrays()
    }

    func populateArrays() {
        // After querying both arrays, reload the table view.
        let completion: () -> () = {
            [weak self] in
            if self!.glucoseQueried && self!.insulinQueried {
                self!.tableView.reloadData()
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    let types = [InsulinType.RapidActing.toRaw(): "Rapid-Acting", InsulinType.LongActing.toRaw(): "Long-Acting"]
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = objects[indexPath.row] as PFObject

        if object.parseClassName == "Glucose" {
            // Set the level label.
            let cell = tableView.dequeueReusableCellWithIdentifier("glucoseCell") as GlucoseCell
            cell.levelLabel.text = String(object["level"] as Int) + " mg/dL"

            // Set the date.
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "M/d/yy h:mm"
            let dateString = dateFormatter.stringFromDate(object["date"] as NSDate)
            cell.dateLabel.text = dateString
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
