//
//  ViewController.swift
//  ToDoList_Realm
//
//  Created by iljoo Chae on 7/31/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
/*
  - to show list of current to do list items
 - to enter new to do list items
 - to show previously entered to do list item
 
 
 - items
 - date
 
 
 */


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet var table: UITableView!

    private var data  = [ToDoListItem]()
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //register cell with code
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        data = realm.objects(ToDoListItem.self).map({$0})
    
    }
    
    
   
    
    
    @IBAction func didTapAddButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "enter") as? EntryViewController else {return}
        vc.completionHandler = { [weak self] in
            self?.refresh()
            
 
            
        }
        vc.title = "New item"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func refresh() {
       data = realm.objects(ToDoListItem.self).map({$0})
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = data[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(identifier: "view") as? ViewViewController else {return
            
        }
        vc.item = item
        vc.deletionHandler = {[weak self] in
            self?.refresh()
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = item.item
        navigationController?.pushViewController(vc, animated: true)
        
        //open the screen where we can see item info and delete
    }
}


class ToDoListItem: Object {
    @objc dynamic var item: String = ""
    @objc dynamic var date: Date = Date()
}

