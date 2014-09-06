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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell

        let object = objects[indexPath.row] as PFObject
        if object.parseClassName == "Glucose" {
            cell = tableView.dequeueReusableCellWithIdentifier("glucoseCell") as GlucoseCell
        } else if object.parseClassName == "Insulin" {
            cell = tableView.dequeueReusableCellWithIdentifier("insulinCell") as InsulinCell
        } else {
            fatalError("Unknown parseClassName")
        }

        return cell
    }

}
