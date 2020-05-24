//
//  EditorTableViewController.swift
//  My Project
//
//  Created by susanne on 2020/5/9.
//  Copyright © 2020 Mike Wu. All rights reserved.
//

import UIKit

class AddTableViewController: UITableViewController, AddRoomSelectionTableViewControllerDelegate {
    
    var roomType: RoomType?
    var addingGuest: Guest?
    
    var checkInDateLabelIndexPath = IndexPath(row: 0, section: 1)
    var checkInDatePickerIndexPath = IndexPath(row: 1, section: 1)
    var checkOutDateLabelIndexPath = IndexPath(row: 2, section: 1)
    var checkOutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    var checkInDatePickerIsHidden = true
    var checkOutDatePickerIsHidden = true
    // MARK: -
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var creditCardTextField: UITextField!
    
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet var numberOfAdultLabel: UILabel!
    @IBOutlet var numberOfAdultStepper: UIStepper!
    @IBOutlet var numberOfChildrenLabel: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!
    @IBOutlet var roomTypeLabel: UILabel!

    @IBOutlet var smokingSwitcher: UISwitch!
    @IBOutlet var remarkTextView: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
   
        updateUI()
        updateSaveButtonState()
        updateRoomType()
    }
    // MARK: - Date Pickers Configurations
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
    // MARK: - 
    private func updateUI() {
        // Initialize the Date Labels based on Date Pickers
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(86400)
        
        let dateFormatter = DateFormatter(); dateFormatter.dateStyle = .medium
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    private func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.title
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    private func updateSaveButtonState () {
        // Make sure Save Button only enabled when fields were filled-in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || idTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || creditCardTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || Int(numberOfAdultStepper.value) == 0
            || roomTypeLabel.text == "Not Set" {
            saveButton.isEnabled = false
        }
    }
    
    //MARK: - Protocol Method
    func didSelect(roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
        updateSaveButtonState()
    }
    //MARK: -
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateUI()
    }
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        numberOfAdultLabel.text = "\(Int(numberOfAdultStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
        updateSaveButtonState()
    }
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - NAVIGATION
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
