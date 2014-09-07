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
        let originalColor = view.backgroundColor
        view.backgroundColor = UIColor(red: 224.0/255.0, green: 247.0/255.0, blue: 250.0/255.0, alpha: 1.0)

        UIView.animateWithDuration(1.0, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.view.backgroundColor = originalColor
        }, completion: nil)
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        levelTextField.resignFirstResponder()
    }

    @IBAction func saveButtonTapped(sender: UIButton) {
        let level = (levelTextField.text as NSString).doubleValue
        let date = datePicker.date
        let glucose = Glucose(level: level, date: date)
        glucose.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                self.navigationController!.popToRootViewControllerAnimated(true)
            }
        }
    }
}
