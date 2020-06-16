//
//  Utilities.swift
//  My Project
//
//  Created by susanne on 2020/5/22.
//  Copyright © 2020 Mike Wu. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class Utilities {
    
    static let dateFormatter = DateFormatter()
    static let db = Firestore.firestore()
    static let guestReference = db.collection("guests")

    // MARK: - FIRESTORE COMMUNICATION
   
    // Creating Document to Firestore -- COMPLETE
    static func addingGuestToFirebase(with data: Guest) {
        
        let creatingPathOfGuest = guestReference.document("\(data.firstName.prefix(1))" + "\(data.lastName)")
        
        // Saving root documents
        creatingPathOfGuest.setData(
            ["documentID": "\(data.firstName.prefix(1))" + "\(data.lastName)",
             "firstName": data.firstName,
             "lastName": data.lastName,
             "phone": data.contactNumber,
             "idNumber": data.idNumber,
             "email": data.email as Any,
             "creditCard": data.creditCardNumber as Any,
             "checkIn": Timestamp(date: data.checkInDate as Date),
             "checkOut": Timestamp(date: data.checkOutDate as Date),
             "roomChoice": RoomType.roomEncoder(rooms: data.roomChoice),
             "adults": data.numberOfAdults as Any,
             "children": data.numberOfChildren as Any,
             "smoking": data.smokingNeeded,
             "special": data.specialRequest as Any
        ])
    }
    
    // Deleting document
    static func deletingGuestInFirebase(data: Guest) {
        
        guestReference.document("\(data.firstName.prefix(1))" + "\(data.lastName)").delete { (error) in
            guard let error = error else { print ("Successfully deleted!")
                return }
            print ("Failed to delete data: \(data.firstName.prefix(1)) \(data.lastName), Error Message \(error).")
        }
    }
    
    

    // Temporary Sample Instance storage
    static let guestSample1 = Guest(documentID: "", firstName: "Nat", lastName: "King Cole", idNumber: 00, contactNumber: "0900-000-000", email: "nkingcole@hotmail.com", creditCardNumber: "0000-000-0000-000", checkInDate: Date(timeIntervalSinceNow: 60*60*24*1), checkOutDate: Date(timeIntervalSinceNow: 60*60*24*3), numberOfAdults: 1, numberOfChildren: 0, roomChoice: [RoomType.standard, RoomType.standard], smokingNeeded: true, specialRequest: "")
    
    static let guestSample2 = Guest(documentID: "", firstName: "Frank", lastName: "Sinatra", idNumber: 01, contactNumber: "0900-000-001", email: "fsinatra@gmail.com", creditCardNumber: "0000-000-0000-001", checkInDate: Date(timeIntervalSinceNow: 60*60*24*2), checkOutDate: Date(timeIntervalSinceNow: 60*60*24*5), numberOfAdults: 2, numberOfChildren: 0, roomChoice: [RoomType.double], smokingNeeded: true, specialRequest: "No Morning Call")
    
    static let guestSample3 = Guest(documentID: "", firstName: "Bob", lastName: "Dylan", idNumber: 02, contactNumber: "0900-000-002", email: "bdylan@hotmail.com", creditCardNumber: "0000-000-0000-002", checkInDate: Date(timeIntervalSinceNow: 60*60*24*1), checkOutDate: Date(timeIntervalSinceNow: 60*60*24*10), numberOfAdults: 2, numberOfChildren: 3, roomChoice: [RoomType.standard, RoomType.double, RoomType.family], smokingNeeded: true, specialRequest: "Side room only")
    
    static let guestSample4 = Guest(documentID: "", firstName: "Johnney", lastName: "Depp", idNumber: 03, contactNumber: "0900-000-003", email: "jdepp@yahoo.com", creditCardNumber: "0000-000-0000-003", checkInDate: Date(timeIntervalSinceNow: 60*60*24*3), checkOutDate: Date(timeIntervalSinceNow: 60*60*24*6), numberOfAdults: 1, numberOfChildren: 0, roomChoice: [RoomType.presidentSuite, RoomType.double], smokingNeeded: false, specialRequest: "")
    
    static let guestSample5 = Guest(documentID: "", firstName: "Eric", lastName: "Clapton", idNumber: 04, contactNumber: "0900-000-004", email: "eclapton@outlook.com", creditCardNumber: "0000-000-0000-004", checkInDate: Date(timeIntervalSinceNow: 60*60*24*3), checkOutDate: Date(timeIntervalSinceNow: 60*60*24*5), numberOfAdults: 7, numberOfChildren: 0, roomChoice: [RoomType.double, RoomType.double, RoomType.double], smokingNeeded: false, specialRequest: "")
}
