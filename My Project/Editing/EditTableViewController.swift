//
//  EditTableViewController.swift
//  My Project
//
//  Created by susanne on 2020/5/14.
//  Copyright © 2020 Mike Wu. All rights reserved.
//

import UIKit

class EditTableViewController: UITableViewController, EditRoomSelectionTableViewControllerDelegate {
    
    var roomType: [RoomType]?
    var editingGuest: Guest!
    
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
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var creditCardTextField: UITextField!
    
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet var adultStepper: UIStepper!
    @IBOutlet var adultLabel: UILabel!
    @IBOutlet var childrenStepper: UIStepper!
    @IBOutlet var childrenLabel: UILabel!
    @IBOutlet var roomTypeLabel: UILabel!
    
    @IBOutlet var smokingSwitcher: UISwitch!
    @IBOutlet var remarkTextView: UITextField!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(86400)
        updateUI()
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
        let dateFormatter = DateFormatter(); dateFormatter.dateStyle = .medium
        
        guard let guest = editingGuest else { return }
            
        firstNameTextField.text = guest.firstName
        lastNameTextField.text = guest.lastName
        idTextField.text = String(guest.idNumber)
        phoneTextField.text = guest.contactNumber
        emailTextField.text = guest.email
        creditCardTextField.text = guest.creditCardNumber
        //checkInDateLabel.text = dateFormatter.string(from: guest.checkInDate!)
        //checkOutDateLabel.text = dateFormatter.string(from: guest.checkOutDate!)
        adultLabel.text = String(guest.numberOfAdults)
        childrenLabel.text = String(guest.numberOfChildren)
        //
        roomTypeLabel.text  = RoomType.standard.title
        remarkTextView.text = guest.specialRequest
    }

    private func updateSaveButtonState () {
        // Make sure Save Button is only enabled when fields were filled-in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || idTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || creditCardTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || Int(adultStepper.value) == 0 {
            saveButton.isEnabled = false
        }
    }
    
    // MARK: - Protocol methods
    
    func didSelect(roomType: [RoomType]) {
        self.roomType = roomType
        //
        roomTypeLabel.text = RoomType.standard.title
    }
    
    // MARK: -
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBAction func datePickersValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter(); dateFormatter.dateStyle = .medium
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    @IBAction func steppersValueChanged(_ sender: UIStepper) {
        adultLabel.text = "\(Int(adultStepper.value))"
        childrenLabel.text = "\(Int(childrenStepper.value))"
    }
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: "確定刪除此訂房內容？", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Delete", style: .default, handler: { ation in
            self.performSegue(withIdentifier: "deleteUnwind", sender: self)
        })
        

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.sourceView = sender
        
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditRoomTypeSelect" {
        let destinationViewController = segue.destination as? EditRoomSelectionTableViewController
        
        destinationViewController?.delegate = self
        destinationViewController?.roomType = roomType
            
            // Wrapping changed Data to be taken back to DetailTableViewController
        } else if segue.identifier == "saveChangeToDetail" {
            super.prepare(for: segue, sender: sender)
            
            guard let roomChoice = roomType else { return }
                let firstName = firstNameTextField.text ?? ""
                let lastName = lastNameTextField.text ?? ""
                let idNumber = Int(idTextField.text ?? "") ?? 0
                let contactNumber = phoneTextField.text ?? ""
                let email = emailTextField.text ?? ""
                let creditCardNumber = creditCardTextField.text ?? ""
                let checkInDate = checkInDatePicker.date
                let checkOutDate = checkOutDatePicker.date
                let numberOfAdults = Int(adultStepper.value)
                let numberOfChildren = Int(childrenStepper.value)
                let smokingNeeded = smokingSwitcher.isOn
                let specialRequest = remarkTextView.text ?? ""
            
            editingGuest = Guest(documentID: "", firstName: firstName, lastName: lastName, idNumber: idNumber, contactNumber: contactNumber, email: email, creditCardNumber: creditCardNumber, checkInDate: checkInDate as Date, checkOutDate: checkOutDate as Date, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, roomChoice: roomChoice, smokingNeeded: smokingNeeded, specialRequest: specialRequest)
            
        }
    
    }
}
