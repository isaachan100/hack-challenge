//
//  Message.swift
//  BigRedBounty
//
//  Created by user228377 on 12/2/22.
//

import SwiftUI

struct Message: Identifiable {
    var id:String = UUID().uuidString
    var finderEmail:String
    var userID:String
    var itemName:String
    
}
var messages:[Message] = [
    Message(finderEmail: "xyz@cornell.edu", userID:"123456789",itemName: "Airpods"), Message(finderEmail: "def@cornell.edu",userID:"123456789", itemName: "Northface Jacket"), Message(finderEmail: "mno@cornell.edu",userID:"123456789", itemName: "Wallet"),Message(finderEmail: "ghi@cornell.edu", userID:"123456789",itemName: "Beats Headphones")
]
struct Message_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
