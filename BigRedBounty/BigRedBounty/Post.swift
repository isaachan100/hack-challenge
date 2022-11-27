//
//  Post.swift
//  BigRedBounty
//
//  Created by user228377 on 11/25/22.
//

import SwiftUI

struct Post: View {
    @State var itemNameText = ""
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color(red: 239/255, green: 71/255, blue: 58/255),Color(red: 203/255, green: 45/255, blue: 62/255)],startPoint: .topTrailing,endPoint:.bottomLeading)
                .ignoresSafeArea()
            //CustomCorner(corners: [.topLeft,.topRight], radius: 25)
                //.fill(LinearGradient(colors: [.white],startPoint: .topTrailing,endPoint:.bottomLeading))
                //.ignoresSafeArea()
                //.offset(y:350)
            VStack(spacing:15){
                HeaderView()
                BodyView()
            }
            
        }
    }
    @ViewBuilder
    func HeaderView()->some View{
        Text("Create Post")
            .foregroundColor(.white)
            .font(.title)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity,alignment: .center)
    }
    @ViewBuilder
    func BodyView()->some View{
        VStack{
            HStack{
                
            }
        }
    }
}

struct Post_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
