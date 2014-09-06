//
//  GlucoseViewController.swift
//  TypeOneTwo
//
//  Created by andrew on 9/6/14.
//  Copyright (c) 2014 TypeOneTwo. All rights reserved.
//

class GlucoseViewController: UIViewController {

    @IBOutlet weak var levelTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        navigationItem.title = "Enter Glucose"
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        levelTextField.resignFirstResponder()
    }

    @IBAction func saveButtonTapped(sender: UIButton) {
        let level = (levelTextField.text as NSString).integerValue
        let date = datePicker.date
        let glucose = Glucose(level: level, date: date)
        glucose.save()
    }
}
