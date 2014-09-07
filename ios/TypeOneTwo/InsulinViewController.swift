//
//  InsulinViewController.swift
//  TypeOneTwo
//
//  Created by andrew on 9/6/14.
//  Copyright (c) 2014 TypeOneTwo. All rights reserved.
//

import UIKit

class InsulinViewController: UIViewController {

    @IBOutlet weak var doseTextField: UITextField!
    @IBOutlet weak var actingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        navigationItem.title = "Enter Insulin"

        let originalColor = view.backgroundColor
        view.backgroundColor = UIColor(red: 224.0/255.0, green: 247.0/255.0, blue: 250.0/255.0, alpha: 1.0)

        UIView.animateWithDuration(1.0, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.view.backgroundColor = originalColor
        }, completion: nil)
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        doseTextField.resignFirstResponder()
    }

    @IBAction func saveButtonTapped(sender: UIButton) {
        let type = InsulinType.fromRaw(actingSegmentedControl.selectedSegmentIndex)!
        let dose = (doseTextField.text as NSString).floatValue
        let date = datePicker.date
        let insulin = Insulin(type: type, dose: dose, date: date)
        insulin.saveInBackgroundWithBlock { (succeeded, error) in
            if succeeded {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
}
