//
//  EditTableViewController.swift
//  My Project
//
//  Created by susanne on 2020/5/14.
//  Copyright © 2020 Mike Wu. All rights reserved.
//

import UIKit

protocol EditTableViewControllerDelegate: class {
    func saveChangeSegue (by guest: Guest)
    func confirmedDeleteAt ()
}

class EditTableViewController: UITableViewController, EditRoomSelectionTableViewControllerDelegate {
 
    func didSelect(roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
    }
    
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
    
    var roomType: RoomType?
    var editingGuest: Guest!
    
    weak var delegate: EditTableViewControllerDelegate?
    
    var checkInDateLabelIndexPath = IndexPath(row: 0, section: 1)
    var checkInDatePickerIndexPath = IndexPath(row: 1, section: 1)
    var checkOutDateLabelIndexPath = IndexPath(row: 2, section: 1)
    var checkOutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    
    var checkInDatePickerIsHidden = true
    var checkOutDatePickerIsHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        setupDatesValue()
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

    // MARK: - Instance Methods 
    
    // Assign data from 'editingGuest' to proper UI objects
    func updateUI() {
        guard let guest = editingGuest else { return }
            let dateFormatter = DateFormatter(); dateFormatter.dateStyle = .medium
                    
        firstNameTextField.text = guest.firstName
        lastNameTextField.text = guest.lastName
        idTextField.text = String(guest.idNumber)
        phoneTextField.text = guest.contactNumber
        emailTextField.text = guest.email
        creditCardTextField.text = guest.creditCardNumber
        checkInDateLabel.text = dateFormatter.string(from: guest.checkInDate)
        checkOutDateLabel.text = dateFormatter.string(from: guest.checkOutDate)
        adultLabel.text = String(guest.numberOfAdults)
        childrenLabel.text = String(guest.numberOfChildren)
        roomTypeLabel.text  = guest.roomChoice.title
        remarkTextView.text = guest.specialRequest
    }
    
    func updateRoomType() {
        guard let roomType = roomType else { return }
            roomTypeLabel.text = roomType.title
    }
    
    func updateSaveButtonState () {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let id = idTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let creditCard = creditCardTextField.text ?? ""

        saveButton.isEnabled = !firstName.isEmpty && !lastName.isEmpty && !id.isEmpty && !phone.isEmpty && !creditCard.isEmpty
    }
    
    func setupDatesValue() {
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(86400)
        }
        
    func updateDateValue() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    func updateGuestNumbers () {
        adultLabel.text = "\(Int(adultStepper.value))"
        childrenLabel.text = "\(Int(childrenStepper.value))"
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBAction func datePickersValueChanged(_ sender: UIDatePicker) {
        setupDatesValue()
        updateDateValue()
    }
    @IBAction func steppersValueChanged(_ sender: UIStepper) {
        updateGuestNumbers()
        saveButton.isEnabled = Int(adultStepper.value) > 0
    }
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: "確定刪除此訂房內容？", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Delete", style: .default, handler: { ation in
            self.performSegue(withIdentifier: "deleteUnwind", sender: self)
            self.delegate?.confirmedDeleteAt()
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
            
            super.prepare(for: segue, sender: sender)
        } else if segue.identifier == "saveChangeToDetail" {
            
            guard let roomChoice = roomType else { return }
                let firstName = firstNameTextField.text ?? ""
                let lastName = lastNameTextField.text ?? ""
                let idNumber = idTextField.text ?? ""
                let contactNumber = phoneTextField.text ?? ""
                let email = emailTextField.text ?? ""
                let creditCardNumber = creditCardTextField.text ?? ""
                let checkInDate = checkInDatePicker.date
                let checkOutDate = checkOutDatePicker.date
                let numberOfAdults = Int(adultStepper.value)
                let numberOfChildren = Int(childrenStepper.value)
                let smokingNeeded = smokingSwitcher.isOn
                let specialRequest = remarkTextView.text ?? ""
            
                editingGuest = Guest(firstName: firstName, lastName: lastName, idNumber: idNumber, contactNumber: contactNumber, email: email, creditCardNumber: creditCardNumber, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, roomChoice: roomChoice, smokingNeeded: smokingNeeded, specialRequest: specialRequest)
            
            delegate?.saveChangeSegue(by: editingGuest)
        }
    
    }
}
