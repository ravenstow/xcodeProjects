//
//  EditorTableViewController.swift
//  My Project
//
//  Created by susanne on 2020/5/9.
//  Copyright © 2020 Mike Wu. All rights reserved.
//

import UIKit

class AddTableViewController: UITableViewController, AddRoomSelectionTableViewControllerDelegate {
    
    func didSelect(roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
        updateSaveButtonState()
    }
    
    // 基本資料 properties
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var creditCardTextField: UITextField!
    // 入住期間 properties
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    
    // 入住條件 properties
    @IBOutlet var numberOfAdultLabel: UILabel!
    @IBOutlet var numberOfAdultStepper: UIStepper!
    @IBOutlet var numberOfChildrenLabel: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!
    @IBOutlet var roomTypeLabel: UILabel!
    // 特殊需求 properties
    @IBOutlet var smokingSwitcher: UISwitch!
    @IBOutlet var remarkTextView: UITextView!
    
    @IBOutlet var saveButton: UIBarButtonItem!

    var roomType: RoomType?
    var addingGuest: Guest?
    
    var checkInDateLabelIndexPath = IndexPath(row: 0, section: 1)
    var checkInDatePickerIndexPath = IndexPath(row: 1, section: 1)
    var checkOutDateLabelIndexPath = IndexPath(row: 2, section: 1)
    var checkOutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    
    var checkInDatePickerIsHidden = true
    var checkOutDatePickerIsHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Checking whether a model object has been passed from other tableview
        updateUI()
        updateGuestNumbers()
        updateSaveButtonState()
        updateRoomType()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerIndexPath:
            if checkInDatePickerIsHidden {
                return 0.0
            } else {
                return 216.0
            }
        case checkOutDatePickerIndexPath:
            if checkOutDatePickerIsHidden {
                return 0.0
            } else {
                return 216.0
            }
        default:
            return 44.0
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
        case checkInDateLabelIndexPath:
            if !checkInDatePickerIsHidden {
                checkInDatePickerIsHidden = true
            } else if !checkOutDatePickerIsHidden {
                checkOutDatePickerIsHidden = true
                checkInDatePickerIsHidden = false
            } else {
                checkInDatePickerIsHidden = false
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        case checkOutDateLabelIndexPath:
            if !checkOutDatePickerIsHidden {
                checkOutDatePickerIsHidden = true
            } else if !checkInDatePickerIsHidden {
                checkInDatePickerIsHidden = true
                checkOutDatePickerIsHidden = false
            } else {
                checkOutDatePickerIsHidden = false
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default:
            break
        }
    }
        
    func updateUI() {
        if let guest = addingGuest {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            navigationItem.title = guest.firstName + " " + guest.lastName
            firstNameTextField.text = guest.firstName
            lastNameTextField.text = guest.lastName
            idTextField.text = guest.idNumber
            phoneNumberTextField.text = guest.contactNumber
            emailTextField.text = guest.email
            creditCardTextField.text = guest.creditCardNumber
            checkInDateLabel.text = dateFormatter.string(from: guest.checkInDate)
            checkOutDateLabel.text = dateFormatter.string(from: guest.checkOutDate)
            numberOfAdultLabel.text = String(guest.numberOfAdults)
            numberOfChildrenLabel.text = String(guest.numberOfChildren)
            roomTypeLabel.text  = guest.roomChoice.title
            remarkTextView.text = guest.specialRequest
        } else {
        
            updateDateViews()
        }
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.title
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    func updateSaveButtonState () {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let id = idTextField.text ?? ""
        let phone = phoneNumberTextField.text ?? ""
        let creditCard = creditCardTextField.text ?? ""
        let adults = Int(numberOfAdultStepper.value)
        let roomType = roomTypeLabel.text

        saveButton.isEnabled = !firstName.isEmpty && !lastName.isEmpty && !id.isEmpty && !phone.isEmpty && !creditCard.isEmpty && adults > 0 && roomType != "Not Set"
    }
    
    func updateDateViews () {
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(86400)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    func updateGuestNumbers () {
        numberOfAdultLabel.text = "\(Int(numberOfAdultStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    func updateRoomTypeLabel () {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.title
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateGuestNumbers()
        updateSaveButtonState()
    }
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectRoomType" {
        let destinationViewController = segue.destination as? AddRoomSelectionTableViewController
        
        destinationViewController?.delegate = self
        destinationViewController?.roomType = roomType
        
        super.prepare(for: segue, sender: sender)
        } else if segue.identifier == "saveAddUnwind" {
            guard let roomChoice = roomType else { return }
            let firstName = firstNameTextField.text ?? ""
            let lastName = lastNameTextField.text ?? ""
            let idNumber = idTextField.text ?? ""
            let contactNumber = phoneNumberTextField.text ?? ""
            let email = emailTextField.text ?? ""
            let creditCardNumber = creditCardTextField.text ?? ""
            let checkInDate = checkInDatePicker.date
            let checkOutDate = checkOutDatePicker.date
            let numberOfAdults = Int(numberOfAdultStepper.value)
            let numberOfChildren = Int(numberOfChildrenStepper.value)
            let smokingNeeded = smokingSwitcher.isOn
            let specialRequest = remarkTextView.text ?? ""
        
            addingGuest = Guest(firstName: firstName, lastName: lastName, idNumber: idNumber, contactNumber: contactNumber, email: email, creditCardNumber: creditCardNumber, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, roomChoice: roomChoice, smokingNeeded: smokingNeeded, specialRequest: specialRequest)
        }
    }
}
