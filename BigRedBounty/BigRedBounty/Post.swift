//
//  Post.swift
//  BigRedBounty
//
//  Created by user228377 on 11/25/22.
//

import SwiftUI
import PhotosUI
struct Post: View {
    @State var itemNameText = ""
    @State var locationText = ""
    @State var descriptionText = "Description"
    @State var bountyText = ""
    @State var selectedItem:PhotosPickerItem? = nil
    @State var selectedImageData:Data? = nil
    var body: some View {
        
            //LinearGradient(colors: [Color(red: 239/255, green: 71/255, blue: 58/255),Color(red: 203/255, green: 45/255, blue: 62/255)],startPoint: .topTrailing,endPoint:.bottomLeading)
                //.ignoresSafeArea()
            //CustomCorner(corners: [.topLeft,.topRight], radius: 35)
//                .fill(LinearGradient(colors: [.white],startPoint: .topTrailing,endPoint:.bottomLeading))
//                .ignoresSafeArea()
//                .offset(y:600)
        
        ZStack{
            LinearGradient(colors: [.white.opacity(0.7),.red.opacity(0.15),.red.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing:15){
                HeaderView()
                BodyView()
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(.ultraThinMaterial)
        }
            
                       // .background(LinearGradient(colors: [.white.opacity(0.7),.red.opacity(0.15),.red.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
            
    }
    @ViewBuilder
    func HeaderView()->some View{
        Text("Create Post")
            //.foregroundColor(.white)
            .font(.title)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity,alignment: .center)
            .frame(width:200)
            //.background(.red.opacity(0.9))
            .cornerRadius(10)
            .padding(10)
            .padding(.vertical,15)
            .offset(y:-105)
    }
    @ViewBuilder
    func BodyView()->some View{
        VStack{
            
            CustomTextField(placeholder:Text("Enter Item Name").foregroundColor(.white),text: $itemNameText)
                .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(8)
                    .frame(width:310)
                    
                                        .background{
                        RoundedRectangle(cornerRadius: 15)
                                                .fill(.red.opacity(0.4))
                                                .shadow(radius: 5,x:11,y:11)
                    }
                                        .offset(y:-115)
            
            
            CustomTextField(placeholder:Text("Enter Location").foregroundColor(.white),text: $locationText)
                .foregroundColor(.white)                .font(.title)
                .fontWeight(.semibold)
                .padding(8)
                .frame(width:310)
                
                                    .background{
                    RoundedRectangle(cornerRadius: 10)
                                            .fill(.red.opacity(0.4))
                                            .shadow(radius: 5,x:11,y:11)
                }
                                    .offset(y:-95)
           
                TextEditor(text: $descriptionText)
                .scrollContentBackground(.hidden)
                .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(8)
                    .frame(width:310,height:200)
                    .background{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.red.opacity(0.4))
                            .shadow(color:.black.opacity(0.3),radius: 5,x:11,y:11)
            }
            .frame(height:200)
            .offset(y:-75)
            CustomTextField(placeholder: Text("Enter Bounty").foregroundColor(.white),text: $bountyText)
            
                .foregroundColor(.white)
                .font(.title)
                .fontWeight(.semibold)
                .padding(8)
                .frame(width:310)
                
                                    .background{
                    RoundedRectangle(cornerRadius: 10)
                                            .fill(.red.opacity(0.4))
                                            .shadow(radius: 5,x:11,y:11)
                }
                                    .offset(y:-50)
//            Button{
//
//            }label:{
//                Text("Select Photo")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//
//                    .padding(10)
//                    .background(.red.opacity(0.4))
//                    .foregroundColor(.white)
//                    .cornerRadius(15)
//
//
//            }
            PhotosPicker(selection:$selectedItem,matching:.images,photoLibrary:.shared()){
                Text("Select Photo")
                    .font(.title2)
                    .fontWeight(.semibold)
                    
                    .padding(10)
                    .background(.red.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .offset(y:-35)
            .onChange(of: selectedItem){newItem in
                Task{
                    if let data = try? await newItem?.loadTransferable(type: Data.self){
                        selectedImageData = data
                    }
                }
            }
            .shadow(radius: 5,x:10,y:10)
            Button{
                bounties.append(Bounty(imageName: "thinkpad", itemName: itemNameText, description: descriptionText, bountyPrice: Int(bountyText)!, location: locationText, found: false, timestamp: Date(), userID: "123456789"))
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
            .shadow(radius: 8,x:7,y:7)
            .offset(y:-20)
        }
    }
}

struct Post_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
