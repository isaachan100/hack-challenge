//
//  Post.swift
//  BigRedBounty
//
//  Created by user228377 on 11/25/22.
//

import SwiftUI

struct Post: View {
    @State var itemNameText = ""
    @State var locationText = ""
    @State var descriptionText = "Description"
    @State var bountyText = ""
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color(red: 239/255, green: 71/255, blue: 58/255),Color(red: 203/255, green: 45/255, blue: 62/255)],startPoint: .topTrailing,endPoint:.bottomLeading)
                .ignoresSafeArea()
            CustomCorner(corners: [.topLeft,.topRight], radius: 35)
                .fill(LinearGradient(colors: [.white],startPoint: .topTrailing,endPoint:.bottomLeading))
                .ignoresSafeArea()
                .offset(y:600)
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
            .offset(y:-105)
    }
    @ViewBuilder
    func BodyView()->some View{
        VStack{
            
                TextField("Enter Item Name",text: $itemNameText)
                .foregroundColor(.black)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(8)
                    .frame(width:310)
                    
                                        .background{
                        RoundedRectangle(cornerRadius: 10)
                                                .fill(.white)
                    }
                                        .offset(y:-85)
            
            TextField("Enter Location",text: $locationText)
                .foregroundColor(.black)
                .font(.title)
                .fontWeight(.semibold)
                .padding(8)
                .frame(width:310)
                
                                    .background{
                    RoundedRectangle(cornerRadius: 10)
                                            .fill(.white)
                }
                                    .offset(y:-65)
           
                TextEditor(text: $descriptionText)
                    .foregroundColor(.black)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(8)
                    .frame(width:310,height:200)
                    .background{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.white)
            }
            .frame(height:200)
            .offset(y:-50)
            TextField("Enter Bounty",text: $bountyText)
                .foregroundColor(.black)
                .font(.title)
                .fontWeight(.semibold)
                .padding(8)
                .frame(width:310)
                
                                    .background{
                    RoundedRectangle(cornerRadius: 10)
                                            .fill(.white)
                }
                                    .offset(y:-30)
            Button{
                
            }label:{
                Text("Select Photo")
                    .font(.title2)
                    .fontWeight(.semibold)
                    
                    .padding(10)
                    .background(.white)
                    .foregroundColor(.gray)
                    .cornerRadius(15)
                    
                
            }
            .offset(y:-15)
            Button{
                
            }label:{
                Text("Place Bounty")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(10)
                    .padding(.horizontal,25)
                    .foregroundColor(.white)
                    .background(LinearGradient(colors: [.cyan,.blue], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
            }
            .offset(y:20)
        }
    }
}

struct Post_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
