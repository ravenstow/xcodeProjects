//
//  DetailTableViewController.swift
//  My Project
//
//  Created by susanne on 2020/5/10.
//  Copyright © 2020 Mike Wu. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var guestDetail: Guest!
    var roomType: RoomType?
    
    @IBOutlet var guestLastNameLabel: UILabel!
    @IBOutlet var guestFirstNameLabel: UILabel!
    @IBOutlet var guestEmailLabel: UILabel!
    @IBOutlet var guestNumberLabel: UILabel!
    @IBOutlet var guestIDNumberLabel: UILabel!
    @IBOutlet var guestCreditCardNumberLabel: UILabel!
    
    @IBOutlet var guestStartDateLabel: UILabel!
    @IBOutlet var guestEndDateLabel: UILabel!
    
    @IBOutlet var guestAdultsNumberLabel: UILabel!
    @IBOutlet var guestChildrenNumberLabel: UILabel!
    

    @IBOutlet var guestRoomPickLabel: UILabel!
    @IBOutlet var guestSmokingSwitcher: UISwitch!
    @IBOutlet var guestSpecialRequestTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        
        updateUI()
    }

    
    func updateUI() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        guestLastNameLabel.text = guestDetail.lastName
        guestFirstNameLabel.text = guestDetail.firstName
        guestEmailLabel.text = guestDetail.email ?? ""
        guestNumberLabel.text = guestDetail.contactNumber
        guestIDNumberLabel.text = String(guestDetail.idNumber)
        guestCreditCardNumberLabel.text = guestDetail.creditCardNumber
        guestStartDateLabel.text = dateFormatter.string(from: guestDetail.checkInDate)
        guestEndDateLabel.text = dateFormatter.string(from: guestDetail.checkOutDate)
        guestAdultsNumberLabel.text = String(guestDetail.numberOfAdults)
        guestChildrenNumberLabel.text = String(guestDetail.numberOfChildren)
    
        guestRoomPickLabel.text =  roomType?.title
        guestSmokingSwitcher.isOn = guestDetail.smokingNeeded
        guard let specialRequest = guestDetail.specialRequest else { return }
            guestSpecialRequestTextView.text = specialRequest

    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditGuest" {
            let navController = segue.destination as! UINavigationController
            let editingController = navController.topViewController as! EditTableViewController
            
        editingController.editingGuest = guestDetail
        editingController.roomType = guestDetail.roomChoice

        }
    }

    @IBAction func unwindToGuestDetail (segue: UIStoryboardSegue) {
        if segue.identifier == "saveChangeToDetail" {
            guard let sourceController = segue.source as? EditTableViewController else { return }
            guestDetail = sourceController.editingGuest
            roomType = sourceController.roomType
            
            updateUI()
        }
    }
    

}
