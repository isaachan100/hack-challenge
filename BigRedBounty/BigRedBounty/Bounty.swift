//
//  Bounty.swift
//  BigRedBounty
//
//  Created by user228377 on 11/24/22.
//

import SwiftUI
//remember to add in decodable for backened. Using Sample Data right now
struct Bounty: Identifiable,Equatable{
    
    
    var id: String = UUID().uuidString
    var imageName:String
    var itemName:String
    var description:String
    var bountyPrice:Int
    var location:String
    var category:String
    var found:Bool
    var timestamp:Date
    
    
}

var bounties:[Bounty] = [
    Bounty(imageName: "airpods", itemName: "Airpods", description: "Has my netID label on it", bountyPrice: 10, location: "Olin Hall", category: "Technology", found: false, timestamp: Date()),
    Bounty(imageName: "jacket", itemName: "Northface Jacket", description: "blue northface jacket with my label inside of it", bountyPrice: 20, location: "Bailey Hall", category: "Clothing", found: false, timestamp: Date()),
    Bounty(imageName: "wallet", itemName: "Wallet", description: "Green ridge wallet with 2 credit cards", bountyPrice: 40, location: "Statler Hall", category: "Accessory", found: false, timestamp: Date()),
    Bounty(imageName: "bottle", itemName: "Hydroflask", description: "White water bottle and has the label abc123", bountyPrice: 5, location: "Mann Library", category: "Accessory", found: false, timestamp: Date())
]
