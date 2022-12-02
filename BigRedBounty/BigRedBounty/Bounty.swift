//
//  Bounty.swift
//  BigRedBounty
//
//  Created by user228377 on 11/24/22.
//

import SwiftUI
import Foundation
import PhotosUI

//remember to add in decodable for backened. Using Sample Data right now
struct Bounty: Identifiable,Equatable{
    
    
    var id: String = UUID().uuidString
    var imageName:String
    var itemName:String
    var description:String
    var bountyPrice:Int
    var location:String
    //var category:String
    var found:Bool
    var timestamp:Date
    var userID: String
    
    
}

var bounties:[Bounty] = [
    Bounty(imageName: "airpods", itemName: "Airpods", description: "Has my netID label on it. Also has some scratches on the bottom. black mark on the side. Has the initials ABC123 on the left side", bountyPrice: 10, location: "Olin Hall",  found: false, timestamp: Date(),userID: "123456789"),
    Bounty(imageName: "jacket", itemName: "Northface Jacket", description: "blue northface jacket with my label inside of it. has two red gloves in the pockets. The zipper is a little broken", bountyPrice: 20, location: "Bailey Hall",  found: false, timestamp: Date(),userID: "123456789"),
    Bounty(imageName: "wallet", itemName: "Wallet", description: "Green ridge wallet with 2 credit cards. One should be a visa. The other should be freedom. Has around 50 dollars in cash", bountyPrice: 40, location: "Statler Hall",  found: false, timestamp: Date(),userID: "123456789"),
    Bounty(imageName: "bottle", itemName: "Hydroflask", description: "White water bottle with a sun on it and has the label abc123. ", bountyPrice: 5, location: "Mann Library",  found: false, timestamp: Date(),userID: "8927581"),
    Bounty(imageName: "headphones", itemName: "Beats Headphones", description: "Black and gold headphones with white sticker on the inside. ", bountyPrice: 25, location: "Uris Library",  found: false, timestamp: Date(),userID: "123456789"),
    Bounty(imageName: "macbookpro", itemName: "Macbook Pro", description: "Macbook Pro has blue and red stickers on the back along with a label. ", bountyPrice: 90, location: "Olin Library",  found: false, timestamp: Date(),userID: "8927581")
    
]
