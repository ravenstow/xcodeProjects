//
//  Guest.swift
//  My Project
//
//  Created by susanne on 2020/5/9.
//  Copyright © 2020 Mike Wu. All rights reserved.
//

import Foundation
import Firebase

struct Guest: Codable {
    // Identifier in Firebase
    var documentID: String
    // Basic info.
    var firstName: String
    var lastName: String
    var idNumber: Int
    var contactNumber: String
    var email: String?
    var creditCardNumber: String
    // Condition info.
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    var roomChoice: [RoomType]
    var smokingNeeded: Bool = false
    var specialRequest: String?
    
    var ditionary: [String: Any] {
        return [
            "documentID": documentID,
            "firstName":  firstName,
            "lastName": lastName,
            "idNumber": idNumber,
            "phone": contactNumber,
            "email": email as Any,
            "creditCard": creditCardNumber,
            "checkIn": checkInDate,
            "checkOut": checkOutDate,
            "adults": numberOfAdults,
            "children": numberOfChildren,
            "roomChoice": roomChoice,
            "smoking": smokingNeeded,
            "special": specialRequest as Any
        ]
    }
}

extension Guest {
    enum CodingKeys: String, CodingKey {
        case documentID
        case firstName
        case lastName
        case idNumber
        case contactNumber
        case email
        case creditCardNumber
        case checkInDate
        case checkOutDate
        case numberOfAdults
        case numberOfChildren
        case roomChoice
        case smokingNeeded
        case specialRequest
    }
    
//    init(from decoder: Decoder) throws {
//        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
//
//        self.documentID = try valueContainer.decode(String.self, forKey: CodingKeys.documentID)
//        self.firstName = try valueContainer.decode(String.self, forKey: CodingKeys.firstName)
//        self.lastName = try valueContainer.decode(String.self, forKey: CodingKeys.lastName)
//        self.idNumber = try valueContainer.decode(Int.self, forKey: CodingKeys.idNumber)
//        self.contactNumber = try valueContainer.decode(String.self, forKey: CodingKeys.contactNumber)
//        self.email = try? valueContainer.decode(String.self, forKey: CodingKeys.email)
//        self.creditCardNumber = try valueContainer.decode(String.self, forKey: CodingKeys.creditCardNumber)
//        self.checkInDate = try valueContainer.decode(Date.self, forKey: CodingKeys.checkInDate)
//        self.checkOutDate = try valueContainer.decode(Date.self, forKey: CodingKeys.checkOutDate)
//        self.numberOfAdults = try valueContainer.decode(Int.self, forKey: CodingKeys.numberOfAdults)
//        self.numberOfChildren = try valueContainer.decode(Int.self, forKey: CodingKeys.numberOfChildren)
//        self.roomChoice = try valueContainer.decode([RoomType].self, forKey: CodingKeys.roomChoice)
//        self.smokingNeeded = try valueContainer.decode(Bool.self, forKey: CodingKeys.smokingNeeded)
//        self.specialRequest = try? valueContainer.decode(String.self, forKey: CodingKeys.specialRequest)
//    }
    init? (dictionary: [String: Any]) {
        guard let documentID = dictionary["documentID"] as? String,
            let firstName = dictionary["firstName"] as? String,
            let lastName = dictionary["lastName"] as? String,
            let idNumber = dictionary["idNumber"] as? Int,
            let contactNumber = dictionary["phone"] as? String,
            let email = dictionary["email"] as? String,
            let creditCardNumber = dictionary["creditCard"] as? String,
            let checkInDate = (dictionary["checkIn"] as? Timestamp)?.dateValue() as Date?,
            let checkOutDate = (dictionary["checkOut"] as? Timestamp)?.dateValue() as Date?,
            let numberOfAdults = dictionary["adults"] as? Int,
            let numberOfChildren = dictionary["children"] as? Int,
            let rooms = dictionary["roomChoice"] as? [Int],
            let roomChoice =  RoomType.roomDecoder(counts: rooms),
            let smokingNeeded = dictionary["smoking"] as? Bool,
            let specialRequest = dictionary["special"] as? String else { return nil }
        
        self.init(documentID: documentID,
                  firstName: firstName,
                  lastName: lastName,
                  idNumber: idNumber,
                  contactNumber: contactNumber,
                  email: email,
                  creditCardNumber: creditCardNumber,
                  checkInDate: checkInDate,
                  checkOutDate: checkOutDate,
                  numberOfAdults: numberOfAdults,
                  numberOfChildren: numberOfChildren,
                  roomChoice: roomChoice,
                  smokingNeeded: smokingNeeded,
                  specialRequest: specialRequest)
    }
}

struct RoomType: Codable {
    var roomID: Int
    var title: String
    var content: String
    var shortName: String
    var price: Int
    
    init(roomID: Int, title: String, content: String, shortName: String, price: Int) {
        self.roomID = roomID
        self.title = title
        self.content = content
        self.shortName = shortName
        self.price = price
    }

    //MARK: - TYPE PROPERTIES
    static var all: [RoomType] {
        return [RoomType.standard, RoomType.double, RoomType.family, RoomType.presidentSuite]
    }
    static var standard: RoomType {
        return RoomType(roomID: 00, title: "Standard", content: "One King", shortName: "S", price: 2000)
    }
    static var double: RoomType {
        return RoomType(roomID: 01, title: "Double", content: "Two Queens", shortName: "D", price: 3200)
    }
    static var family: RoomType {
        return RoomType(roomID: 02, title: "Family", content: "Two Queens and One Single", shortName: "FA", price: 4500)
    }
    static var presidentSuite: RoomType {
        return RoomType(roomID: 03, title: "President Suite", content: "Two Luxury", shortName: "PRE", price: 8000)
    }
 
    // MARK: - Formatter
    
    static func roomEncoder (rooms: [RoomType]) -> [Int] {
        // Format representing as ["Standard", "Double", "Family", "PresidentSuite"]
        var roomCountsFormat: [Int] = [0, 0, 0, 0]
       
        for room in rooms {
            if room.roomID == 00 {
                roomCountsFormat[0] += 1
            }
            if room.roomID == 01 {
                roomCountsFormat[1] += 1
            }
            if room.roomID == 02 {
                roomCountsFormat[2] += 1
            }
            if room.roomID == 03 {
                roomCountsFormat[3] += 1
            }
        }
     
        return roomCountsFormat
    }
 
    static func roomDecoder (counts: [Int]) -> [RoomType]? {
        var roomTypeOutcome: [RoomType] = []
        
        // If "Standard" room has been selected (>0), adding into collection by times of its counts
        if counts[0] > 0 {
            for _ in 1...counts[0] {
            roomTypeOutcome.append(RoomType.standard)
            }
        }
        
        // If "Double" room has been selected (>0), adding into collection by times of its counts
        if counts[1] > 0 {
            for _ in 1...counts[1] {
            roomTypeOutcome.append(RoomType.double)
            }
        }
        
        // If "Family" room has been selected (>0), adding into collection by times of its counts
        if counts[2] > 0 {
            for _ in 1...counts[2] {
            roomTypeOutcome.append(RoomType.family)
            }
            
        }// If "Standard" room has been selected (>0), adding into collection by times of its counts
        if counts[3] > 0 {
            for _ in 1...counts[3] {
            roomTypeOutcome.append(RoomType.presidentSuite)
            }
        }
        
        return roomTypeOutcome
    }
    
    static func roomDescriptionConverter (roomTypes: [RoomType]) -> String {
        var roomCollection: [String: Int] = ["S": 0, "D": 0, "F": 0, "P": 0]
        var descriptionOutcome: String = ""
             
        // Checking through RoomType instances to collect selected rooms
        for roomType in roomTypes {
            if roomType.roomID == 00 {
                roomCollection["S"]! += 1
            }
            
            if roomType.roomID == 01 {
                roomCollection["D"]! += 1
            }
            
            if roomType.roomID == 02 {
                roomCollection["F"]! += 1
            }
            
            if roomType.roomID == 03 {
                roomCollection["P"]! += 1
            }
        }
        
        for (room, roomCount) in roomCollection {
            if roomCount != 0 {
                descriptionOutcome += "\(String(roomCount))\(room) "
            }
        }
        return descriptionOutcome
    }
}
