//
//  FirstViewController.swift
//  TypeOneTwo
//
//  Created by andrew on 9/6/14.
//  Copyright (c) 2014 TypeOneTwo. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var doseTextField: UITextField!
    @IBOutlet weak var actingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        navigationItem.title = "Enter Insulin"
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        doseTextField.resignFirstResponder()
    }

    @IBAction func saveButtonTapped(sender: UIButton) {
        let type = InsulinType.fromRaw(actingSegmentedControl.selectedSegmentIndex)!
        let dose = (doseTextField.text as NSString).floatValue
        let date = datePicker.date
        let insulin = Insulin(type: type, dose: dose, date: date)
        insulin.save()
    }
}
