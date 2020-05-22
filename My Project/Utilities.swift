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
    

    static func saveToFirebase(with data: Guest, errorMessage: String) {
        let db = Firestore.firestore()
        
        // Create Document to Firestore
        db.collection("guests").addDocument(data: [
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
            "special": data.specialRequest as Any
        ]) { (error) in
            if let error = error {
                print ()
            } else {
                print ()
            }
        }
    }
    
    static func loadFromFirebase() {
    
    }
}
