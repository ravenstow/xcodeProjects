//
//  RoomSelectionTableViewController.swift
//  My Project
//
//  Created by susanne on 2020/5/10.
//  Copyright © 2020 Mike Wu. All rights reserved.
//

import UIKit

protocol AddRoomSelectionTableViewControllerDelegate: class {
    func didSelect(roomType: [RoomType])
}

class AddRoomSelectionTableViewController: UITableViewController {

    var roomType: [RoomType]?
    weak var delegate: AddRoomSelectionTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view DATA SOURCE

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomType.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
        let roomType = RoomType.all[indexPath.row]

        // Configure the cell...
        cell.textLabel?.text = roomType.title
        cell.detailTextLabel?.text = "$ \(String(describing: roomType.price))"
       // if roomType == self.roomType {
          //  cell.accessoryType = .checkmark
       // } else {
        //    cell.accessoryType = .none
       // }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        roomType = RoomType.all
        delegate?.didSelect(roomType: roomType!)
        tableView.reloadData()
    }
}
