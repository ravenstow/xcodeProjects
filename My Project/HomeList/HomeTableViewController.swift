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

    private var guests: [Guest] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        fetchData()
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
        
        let guest = guests[indexPath.row]
        let dateFormatter = DateFormatter(); dateFormatter.dateStyle = .short
        let checkInDate = dateFormatter.string(from: guest.checkInDate)
        let checkOutDate = dateFormatter.string(from: guest.checkOutDate)
        
        // Cell Configuration
        cell.titleTextLabel?.text = guest.firstName + " " + guest.lastName
        cell.subtitleTextLabel?.text = RoomType.roomDescriptionConverter(roomTypes: guest.roomChoice) + ": " + checkInDate + " - " + checkOutDate
      
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
            
            let db = Firestore.firestore()
            let guestReference = db.collection("guests")
            let guest = self.guests[indexPath.row]
            guestReference.document("\(guest.firstName.prefix(1))" + "\(guest.lastName)").delete { (error) in
                guard let error = error else { print ("Successfully deleted!")
                    return }
                print ("Failed to delete data: \(guest.firstName.prefix(1)) \(guest.lastName), Error Message \(error).")
            }
            
            self.tableView.reloadData()
        }
    }
    
    // Cell Selecting Delegation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - TOOLS
    
    private func fetchData () {
        let db = Firestore.firestore()
        let guestReference = db.collection("guests")

        guestReference.addSnapshotListener({ (snapshot, error) in
            guard let documents = snapshot?.documents else { print ("Error fetching snapshot results: \(error!)")
                return
            }
            // First check to print DocumentSnapshot
                 print (" ### <最初的文件擷取>Document Snapshots: \(documents)")
            
            self.guests = documents.map { (document) -> Guest in
                if let model = Guest(dictionary: document.data()) {
                    // Second check to print individual model
                    print(" ### <取出的單筆資料> Object models: \(model)")
                    return model
                            
                            // Error meesage when there's NO DATA to fetch
                        } else {
                            fatalError("Unable to initialize type \(Guest.self) with \(document.data())")
                        }
            }
            self.tableView.reloadData()
        })
    }
    // MARK: - NAVIGATIONS

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationController = segue.destination as! DetailTableViewController
        let indexPath = tableView.indexPathForSelectedRow!
        
        destinationController.guestDetail = guests[indexPath.row]
    }
    
    @IBAction func unwindToHomeTable(_ segue: UIStoryboardSegue) {
        
    }
}
