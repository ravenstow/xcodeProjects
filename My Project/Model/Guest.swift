//
//  Guest.swift
//  My Project
//
//  Created by susanne on 2020/5/9.
//  Copyright © 2020 Mike Wu. All rights reserved.
//

import Foundation

struct Guest {
    // Identifier in Firebase
    var documentID: String?
    // Basic info.
    var firstName: String
    var lastName: String
    var idNumber: String
    var contactNumber: String
    var email: String?
    var creditCardNumber: String
    // Condition info.
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    var roomChoice: RoomType
    var smokingNeeded: Bool = false
    var specialRequest: String?
    
    init (documentID: String?, firstName: String, lastName: String, idNumber: String, contactNumber: String, email: String?, creditCardNumber: String, checkInDate: Date, checkOutDate: Date, numberOfAdults: Int, numberOfChildren: Int, roomChoice: RoomType, smokingNeeded: Bool, specialRequest: String?) {
        
        self.documentID = documentID
        self.firstName = firstName
        self.lastName = lastName
        self.idNumber = idNumber
        self.contactNumber = contactNumber
        self.email = email
        self.creditCardNumber = creditCardNumber
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
        self.numberOfAdults = numberOfAdults
        self.numberOfChildren = numberOfChildren
        self.roomChoice = roomChoice
        self.smokingNeeded = smokingNeeded
        self.specialRequest = specialRequest
    }

}

struct RoomType: Codable, Equatable {
    var title: String
    var content: String
    var shortName: String
    var roomID: Int
    var price: Int
    
    static var all: [RoomType] {
        return [RoomType(title: "Standard", content: "One King", shortName: "K", roomID: 0, price: 2000), RoomType(title: "Double", content: "Two Queens", shortName: "2Q", roomID: 1, price: 3200), RoomType(title: "Family", content: "Two Queens and One Single", shortName: "FA", roomID: 2, price: 4500), RoomType(title: "President Suite", content: "Two Luxury", shortName: "PRE", roomID: 3, price: 8000)]
    }
    static var standard: RoomType {
        return RoomType(title: "Standard", content: "One King", shortName: "K", roomID: 0, price: 2000)
    }
    static var double: RoomType {
        return RoomType(title: "Double", content: "Two Queens", shortName: "2Q", roomID: 1, price: 3200)
    }
    static var family: RoomType {
        return RoomType(title: "Family", content: "Two Queens and One Single", shortName: "FA", roomID: 2, price: 4500)
    }
    static var presidentSuite: RoomType {
        return RoomType(title: "President Suite", content: "Two Luxury", shortName: "PRE", roomID: 3, price: 8000)
    }
    
}
