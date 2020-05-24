//
//  BrowserTableViewController.swift
//  My Project
//
//  Created by susanne on 2020/5/9.
//  Copyright © 2020 Mike Wu. All rights reserved.
//

import UIKit
import FirebaseFirestore

class HomeTableViewController: UITableViewController {

    var guests: [Guest] = []
    var documentID = [Guest.documentID]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
    
        updateUI()
    }
    
    // MARK: - Table view DATA SOURCES & DELEGATION
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guests.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GuestCell", for: indexPath)
            as? GuestCellTableViewCell else { fatalError("Could not dequeue a cell") }
        
        // Cell Configuration
        let guest = guests[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short

        cell.titleTextLabel?.text = guest.firstName + " " + guest.lastName
        cell.subtitleTextLabel?.text = guest.roomChoice.title + ": " + dateFormatter.string(from: guest.checkInDate) + " - " + dateFormatter.string(from: guest.checkOutDate)
        
        return cell
    }
    
    // Enable Edit Mode
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Edit Mode Configuration
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Cell Selecting Delegation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - TOOLS
    func updateUI() {
   
    }
 
    // MARK: - NAVIGATIONS

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GuestDetail" {
        let detailController = segue.destination as! DetailTableViewController
        let indexPath = tableView.indexPathForSelectedRow!
        let selectedGuests = guests[indexPath.row]
        
            detailController.guestDetail = selectedGuests
            detailController.roomType = selectedGuests.roomChoice
        }
        
    }
    
    @IBAction func unwindToGuestBrowser (segue: UIStoryboardSegue) {
        if segue.identifier == "deleteUnwind" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guests.remove(at: indexPath.row)
            tableView.reloadData()
            
            
        } else {
            guard let sourceTableViewController = segue.source as? AddTableViewController,
                let addingGuest = sourceTableViewController.addingGuest else { return }
 
            let newIndexPath = IndexPath(row: guests.count, section: 0)
            // user instance method to add from the model object
            guests.append(addingGuest)
            tableView.insertRows(at: [newIndexPath], with: .automatic)

        
        }
    }
}
