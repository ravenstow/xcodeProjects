//
//  Guest.swift
//  My Project
//
//  Created by susanne on 2020/5/9.
//  Copyright © 2020 Mike Wu. All rights reserved.
//

import Foundation

struct Guest: Codable, Equatable {
    var firstName: String
    var lastName: String
    var idNumber: String
    var contactNumber: String
    var email: String? = "N/A"
    var creditCardNumber: String
    
    var checkInDate: Date
    var checkOutDate: Date
    
    var numberOfAdults: Int
    var numberOfChildren: Int
    var roomChoice: RoomType
    
    var smokingNeeded: Bool = false
    var specialRequest: String? = "N/A"
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    // Locate path for saving
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Guest_test").appendingPathExtension("plist")

    // Saving current data
    static func saveGuests(_ guests: [Guest]) {
        let propertyListEncoder = PropertyListEncoder()
        // Encoding
        let encodedGuests = try? propertyListEncoder.encode(guests)
        // Writing to disk by 'ArchiveURL'
        try? encodedGuests?.write(to: ArchiveURL, options: .noFileProtection)
    }
    // Loading saved data from disk
    static func loadGuests () -> [Guest]? {
        let propertyListDecoder = PropertyListDecoder()
        guard let encodedGuestsData = try? Data(contentsOf: ArchiveURL) else { return nil }
        return try? propertyListDecoder.decode(Array<Guest>.self, from: encodedGuestsData)
    }
    // Model Sample method
    static func loadSampleGuests() -> [Guest] {
        let guest1 = Guest(firstName: "Nat", lastName: "King Cole", idNumber: "", contactNumber: "000-000-000", email: nil, creditCardNumber: "0000-000-0000-000", checkInDate: Date(timeIntervalSinceNow: 60*60*24*1), checkOutDate: Date(timeIntervalSinceNow: 60*60*24*3), numberOfAdults: 1, numberOfChildren: 0, roomChoice: RoomType.standard, smokingNeeded: true, specialRequest: nil)
        
        let guest2 = Guest(firstName: "Frank", lastName: "Sinatra", idNumber: "", contactNumber: "000-000-001", email: "xxxxx@gmail.com", creditCardNumber: "0000-000-0000-001", checkInDate: Date(timeIntervalSinceNow: 60*60*24*2), checkOutDate: Date(timeIntervalSinceNow: 60*60*24*5), numberOfAdults: 2, numberOfChildren: 0, roomChoice: RoomType.double, smokingNeeded: true, specialRequest: "No Morning Call")
        
        let guest3 = Guest(firstName: "Bob", lastName: "Dylan", idNumber: "", contactNumber: "000-000-002", email: "xxxxx@hotmail.com", creditCardNumber: "0000-000-0000-002", checkInDate: Date(timeIntervalSinceNow: 60*60*24*1), checkOutDate: Date(timeIntervalSinceNow: 60*60*24*10), numberOfAdults: 2, numberOfChildren: 3, roomChoice: RoomType.family, smokingNeeded: true, specialRequest: "Side room only")
        
        let guest4 = Guest(firstName: "Johnney", lastName: "Depp", idNumber: "", contactNumber: "000-000-003", email: "xxxxx@yahoo.com", creditCardNumber: "0000-000-0000-003", checkInDate: Date(timeIntervalSinceNow: 60*60*24*3), checkOutDate: Date(timeIntervalSinceNow: 60*60*24*6), numberOfAdults: 1, numberOfChildren: 0, roomChoice: RoomType.presidentSuite, smokingNeeded: false, specialRequest: "")
        
        let guest5 = Guest(firstName: "Eric", lastName: "Clapton", idNumber: "'4'", contactNumber: "000-000-004", email: "xxxxx@outlook.com", creditCardNumber: "0000-000-0000-004", checkInDate: Date(timeIntervalSinceNow: 60*60*24*3), checkOutDate: Date(timeIntervalSinceNow: 60*60*24*5), numberOfAdults: 7, numberOfChildren: 0, roomChoice: RoomType.double, smokingNeeded: false, specialRequest: nil)
        
        let guests = [guest1, guest2, guest3, guest4, guest5]
        return guests
    }
    
    static func == (lhs: Guest, rhs: Guest) -> Bool {
        return lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.email == rhs.email &&
            lhs.checkInDate == rhs.checkInDate &&
            lhs.checkOutDate == rhs.checkOutDate &&
            lhs.contactNumber == rhs.contactNumber &&
            lhs.creditCardNumber == rhs.creditCardNumber &&
            lhs.idNumber == rhs.idNumber &&
            lhs.numberOfAdults == rhs.numberOfAdults &&
            lhs.numberOfChildren == rhs.numberOfChildren &&
            lhs.roomChoice == rhs.roomChoice &&
            lhs.specialRequest == rhs.specialRequest &&
            lhs.smokingNeeded == rhs.smokingNeeded
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
