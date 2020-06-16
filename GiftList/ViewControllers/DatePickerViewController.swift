//
//  DatePickerViewController.swift
//  GiftList
//
//  Created by Jirka  on 29/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit

protocol SetBirthday {
    func birthdayAndAge(age: Int,_ birthday: String, date: Date)
}

class DatePickerViewController: UIViewController {

    @IBAction func selectDateButton(_ sender: UIButton) {
        
        dateAndCalculateAge(date: datePicker.date)
        
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancelDateButton(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: SetBirthday?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    func dateAndCalculateAge(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        
        
        let birthday = dateFormatter.string(from: date)
        
        
        guard let birthdayDate = dateFormatter.date(from: birthday) else {return}
        
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate, to: now, options: [])
        
        delegate?.birthdayAndAge(age: calcAge.year!, birthday, date: date)
    }
    

}
