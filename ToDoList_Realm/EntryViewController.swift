//
//  EntryViewController.swift
//  ToDoList_Realm
//
//  Created by iljoo Chae on 7/31/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import RealmSwift

class EntryViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    
    private let realm = try! Realm()
    public var completionHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.setDate(Date(), animated: true)

        textField.becomeFirstResponder()
        textField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        
    }
    
    
    
    @objc @IBAction func didTapSaveButton() {
        if let text = textField.text, !text.isEmpty {
            let date = datePicker.date
            
            //1. Ask for permission
            let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound])
                {(granted, error) in
                    print("If you want to give permisstion later, please do ...")
                }
            
            //2. Create the notification content
            let content = UNMutableNotificationContent()
            content.title = text
            content.sound = .default
            let targetDate = date
            
           let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month,.day, .hour,.minute,.second], from: targetDate), repeats: false)

            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                if let error = error {
                    print("\(error.localizedDescription)")
                }
            })

            
            realm.beginWrite()
            let newItem = ToDoListItem()
            newItem.date = date
            newItem.item = text
            realm.add(newItem)
            try! realm.commitWrite()
            completionHandler?()
            navigationController?.popToRootViewController(animated: true)
        }else{
            print("Add Sth")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

struct myReminder {
    let title: String
    let date: Date
}
