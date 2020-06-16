//
//  EditRoomSelectionTableViewController.swift
//  My Project
//
//  Created by susanne on 2020/5/14.
//  Copyright © 2020 Mike Wu. All rights reserved.
//

import UIKit

protocol EditRoomSelectionTableViewControllerDelegate: class {
    func didSelect(roomType: [RoomType])
}

class EditRoomSelectionTableViewController: UITableViewController {

    var roomType: [RoomType]!
    weak var delegate: EditRoomSelectionTableViewControllerDelegate?
    
    @IBOutlet var standardCountLabel: UILabel!
    @IBOutlet var standardStepper: UIStepper!
    @IBOutlet var doubleCountLabel: UILabel!
    @IBOutlet var doubleStepper: UIStepper!
    @IBOutlet var familyCountLabel: UILabel!
    @IBOutlet var familyStepper: UIStepper!
    @IBOutlet var presidentCountLabel: UILabel!
    @IBOutlet var presidentStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view DELEGATIONS

  

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        roomType = RoomType.all
        delegate?.didSelect(roomType: roomType)
        
        tableView.reloadData()
    }

    // MARK: -
    @IBAction func standardStepperValueChanged(_ sender: UIStepper) {
        standardCountLabel.text = String(standardStepper.value)
    }
    @IBAction func doubleStepperValueChanged(_ sender: UIStepper) {
        doubleCountLabel.text = String(doubleStepper.value)
    }
    @IBAction func familyStepperValueChanged(_ sender: UIStepper) {
        familyCountLabel.text = String(familyStepper.value)
    }
    @IBAction func presidentStepperValueChanged(_ sender: UIStepper) {
        presidentCountLabel.text = String(presidentStepper.value)
    }
    
}
