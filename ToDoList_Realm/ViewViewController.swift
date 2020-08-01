//
//  ViewViewController.swift
//  ToDoList_Realm
//
//  Created by iljoo Chae on 7/31/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import RealmSwift


class ViewViewController: UIViewController {

    public var item: ToDoListItem?
    public var deletionHandler: (() -> Void)?
    
    private let realm = try! Realm()
    
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    static let dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemLabel.text = item?.item
        dateLabel.text = Self.dateFormatter.string(from: item!.date)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))
    }
    
    @objc private func didTapDelete() {
        guard let selectedItem = self.item else {
            return
        }
        realm.beginWrite()
        realm.delete(selectedItem)
        try! realm.commitWrite()
        deletionHandler?()
        navigationController?.popToRootViewController(animated: true)
    }
    



}
