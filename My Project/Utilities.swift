//
//  Utilities.swift
//  My Project
//
//  Created by susanne on 2020/5/22.
//  Copyright © 2020 Mike Wu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class Utilities {
    
    let guestSample1 = Guest(documentID: nil, firstName: "Nat", lastName: "King Cole", idNumber: "", contactNumber: "000-000-000", email: nil, creditCardNumber: "0000-000-0000-000", checkInDate: Date(timeIntervalSinceNow: 60*60*24*1), checkOutDate: Date(timeIntervalSinceNow: 60*60*24*3), numberOfAdults: 1, numberOfChildren: 0, roomChoice: RoomType.standard, smokingNeeded: true, specialRequest: nil)
    
    let guestSample2 = Guest(documentID: nil, firstName: "Frank", lastName: "Sinatra", idNumber: "", contactNumber: "000-000-001", email: "xxxxx@gmail.com", creditCardNumber: "0000-000-0000-001", checkInDate: Date(timeIntervalSinceNow: 60*60*24*2), checkOutDate: Date(timeIntervalSinceNow: 60*60*24*5), numberOfAdults: 2, numberOfChildren: 0, roomChoice: RoomType.double, smokingNeeded: true, specialRequest: "No Morning Call")
    
    let guestSample3 = Guest(documentID: nil, firstName: "Bob", lastName: "Dylan", idNumber: "", contactNumber: "000-000-002", email: "xxxxx@hotmail.com", creditCardNumber: "0000-000-0000-002", checkInDate: Date(timeIntervalSinceNow: 60*60*24*1), checkOutDate: Date(timeIntervalSinceNow: 60*60*24*10), numberOfAdults: 2, numberOfChildren: 3, roomChoice: RoomType.family, smokingNeeded: true, specialRequest: "Side room only")
    
    let guestSample4 = Guest(documentID: nil, firstName: "Johnney", lastName: "Depp", idNumber: "", contactNumber: "000-000-003", email: "xxxxx@yahoo.com", creditCardNumber: "0000-000-0000-003", checkInDate: Date(timeIntervalSinceNow: 60*60*24*3), checkOutDate: Date(timeIntervalSinceNow: 60*60*24*6), numberOfAdults: 1, numberOfChildren: 0, roomChoice: RoomType.presidentSuite, smokingNeeded: false, specialRequest: "")
    
    let guestSample5 = Guest(documentID: nil, firstName: "Eric", lastName: "Clapton", idNumber: "'4'", contactNumber: "000-000-004", email: "xxxxx@outlook.com", creditCardNumber: "0000-000-0000-004", checkInDate: Date(timeIntervalSinceNow: 60*60*24*3), checkOutDate: Date(timeIntervalSinceNow: 60*60*24*5), numberOfAdults: 7, numberOfChildren: 0, roomChoice: RoomType.double, smokingNeeded: false, specialRequest: nil)
    
    static let db = Firestore.firestore()
    static let newDocument = db.collection("guests").document()
    
    // MARK: - 'CRUD' (CREATE, READ, UPDATE, DELETE) methods to Firestore
    
    static func addingGuest(with data: Guest) {

        // Creating Document to Firestore
        newDocument.setData(
            ["documentID": newDocument.documentID,
            "firstName": data.firstName,
            "lastName": data.lastName,
            "idNumber": data.idNumber,
            "phone": data.contactNumber,
            "email": data.email as Any,
            "creditCard": data.creditCardNumber,
            "checkIn": data.checkInDate,
            "checkOut": data.checkOutDate,
            "adults": data.numberOfAdults,
            "children": data.numberOfChildren,
            "roomType": data.roomChoice.title,
            "smoking": data.smokingNeeded,
            "special": data.specialRequest as Any])
    }
    
    static func updatingGuest(with data: Guest) {
        
        // Overwritting Document to Firestore
        db.collection("guests").document(data.documentID!).setData(
            ["documentID": newDocument.documentID,
            "firstName": data.firstName,
            "lastName": data.lastName,
            "idNumber": data.idNumber,
            "phone": data.contactNumber,
            "email": data.email as Any,
            "creditCard": data.creditCardNumber,
            "checkIn": data.checkInDate,
            "checkOut": data.checkOutDate,
            "adults": data.numberOfAdults,
            "children": data.numberOfChildren,
            "roomType": data.roomChoice.title,
            "smoking": data.smokingNeeded,
            "special": data.specialRequest as Any], merge: true)
    }
    
    static func loadingGuest() -> [Guest] {
        var guests: [Guest] = []
        
        // Reading all documents in guests collection
        db.collection("guests").getDocuments { (snapshot, error) in
            
            // If documents exist in snapshot and there is No Error
            if snapshot != nil && error == nil {
                
                // Go over the each document in snapshot
                for document in snapshot!.documents {
                    let documentData = document.data()
                    
                    let documentID = documentData["documentID"] ?? ""
                    let firstName = documentData["firstName"]
                    let lastName = documentData["lastName"]
                    let idNumber = documentData["idNumber"]
                    let contactNumber = documentData["phone"]
                    let email = documentData["email"] ?? ""
                    let creditCardNumber = documentData["creditCard"]
                    let checkInDate = documentData["checkIn"]
                    let checkOutDate = documentData["checkOut"]
                    let numberOfAdults = documentData["adults"]
                    let numberOfChildren = documentData["children"]
                    let roomChoice = documentData["roomType"]
                    let smokingNeeded = documentData["smoking"]
                    let specialRequest = documentData["special"] ?? ""
                    
                    let guest = Guest(documentID: documentID as? String, firstName: firstName as! String, lastName: lastName as! String, idNumber: idNumber as! String, contactNumber: contactNumber as! String, email: email as? String, creditCardNumber: creditCardNumber as! String, checkInDate: checkInDate as! Date, checkOutDate: checkOutDate as! Date, numberOfAdults: numberOfAdults as! Int, numberOfChildren: numberOfChildren as! Int, roomChoice: roomChoice as! RoomType, smokingNeeded: smokingNeeded as! Bool, specialRequest: specialRequest as? String)
                    
                    guests.append(guest)
                }
            }
        }
        return guests
    }
    
    static func deletingGuest(data: Guest) {
        
        // Deleting document
        db.collection("guests").document(data.documentID!).delete()
    }
}
