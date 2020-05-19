//
//  EditRoomSelectionTableViewController.swift
//  My Project
//
//  Created by susanne on 2020/5/14.
//  Copyright © 2020 Mike Wu. All rights reserved.
//

import UIKit
protocol EditRoomSelectionTableViewControllerDelegate: class {
    func didSelect(roomType: RoomType)
}

class EditRoomSelectionTableViewController: UITableViewController {

    var roomType: RoomType?
    weak var delegate: EditRoomSelectionTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomType.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
        let roomType = RoomType.all[indexPath.row]

        cell.textLabel?.text = roomType.title
        cell.detailTextLabel?.text = "$ \(roomType.price)"
        if roomType == self.roomType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        roomType = RoomType.all[indexPath.row]
        delegate?.didSelect(roomType: roomType!)
        tableView.reloadData()
    }

}
