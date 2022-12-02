//
//  Profile.swift
//  BigRedBounty
//
//  Created by user228377 on 11/25/22.
//

import SwiftUI

struct Profile: View {
    
    let userList:[Bounty] = bounties.filter{
        $0.userID == "123456789"
    }
    let userMessages:[Message] = messages.filter{
        $0.userID == "123456789"
    }.reversed()
    
    @State var showSheet:Bool = false
    @State var showUserDetailView:Bool = false
    @State var currentUserDetailBounty:Bounty?
    @Namespace var animation2
    var body: some View {
        //ScrollView(.vertical,showsIndicators: false){
        
            VStack{
                HStack(spacing:10){
                    Button{
                        showSheet = true
                    }label:{
                        ZStack{
                            Circle()
                                .fill(LinearGradient(colors: [Color(red: 239/255, green: 71/255, blue: 58/255),Color(red: 203/255, green: 45/255, blue: 62/255)], startPoint: .topTrailing, endPoint: .bottomLeading))
                                .frame(width:60,height:60)
                                .shadow(radius: 5,x:7,y:7)
                            Image(systemName:"envelope.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width:35,height:35)
                                .foregroundColor(.white)
                            Circle()
                                .fill(LinearGradient(colors:[.cyan,.blue],startPoint: .topLeading,endPoint: .bottomTrailing))
                                .frame(width:20,height:20)
                                .offset(x:21,y:-18)
                        }
                            
                    }
                    .sheet(isPresented: $showSheet){
                        var tempUserMessages:[Message] = userMessages
                        ScrollView(.vertical,showsIndicators: false){
                            VStack(spacing:30){
                                Text("Messages")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .padding(.top,30)
                                ForEach(tempUserMessages){message in
                                    ZStack{
                                        Text("User with email: \(message.finderEmail) has found your \(message.itemName). Please contact them.")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                            .frame(width:300)
                                            .padding(15)                                               .background{
                                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                                    .fill(.blue.opacity(0.8))
                                                    
                                            }
                                                                                        
                                                                                        .padding(.horizontal,10)

                                        Button{
                                            
                                        }label:{
                                            Image(systemName:"xmark.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width:30,height:30)
                                                .foregroundColor(.gray)
                                                
                                        }
                                        .offset(x:161,y:-70)
                                    }
                                }
                            }
                        }
                        
                        .presentationDetents([.fraction(0.75),.large])
                        .presentationDragIndicator(.visible)
                    }
                    
                    Text("Email:")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("abc123@cornell.edu")
                        .font(.title2)
                        .lineLimit(1)
                        //.fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(10)
                        .background(.gray.opacity(0.25))
                        .cornerRadius(15)
                        
                }
                .padding(.bottom,25)
                ScrollView{
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160),spacing:15)], spacing:15){
                        ForEach(userList) { userBounty in
                            BountyCardView(bounty: userBounty)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    hideTabBar()
                                    withAnimation(.interactiveSpring(response:0.5,dampingFraction:0.7,blendDuration: 0.7)){
                                        currentUserDetailBounty = userBounty
                                        showUserDetailView = true
                                    }
                                }
                        }
                    }
                }
            }
            
            .padding(.top)
            .padding(.horizontal)
            .background(LinearGradient(colors: [.white.opacity(0.7),.red.opacity(0.15),.red.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea())
            .overlay{
                if let currentUserDetailBounty,showUserDetailView{
                    UserDetailView(showView: $showUserDetailView, animation2: animation2, bounty: currentUserDetailBounty)
                        .transition(.asymmetric(insertion: .identity, removal: .offset(x:0.5)))
                }
            }
        //}
        
        
    }
    @ViewBuilder
    func BountyCardView(bounty:Bounty)->some View{
        ZStack{
            //LinearGradient(colors: [.red.opacity(0.25),.red.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
            LinearGradient(colors: [.red.opacity(0.2),.red.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .clipShape(RoundedRectangle(cornerRadius: 30,style:.continuous))
                            ZStack{
                if currentUserDetailBounty?.id == bounty.id && showUserDetailView{
                    Rectangle()
                        .fill(.clear)
                }
                else{
                    Image(bounty.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .matchedGeometryEffect(id: bounty.id, in: animation2)
                        .frame(width:135,height:110)
                        .clipped()
                        .cornerRadius(20)
                        .padding(.bottom,75)
                        .shadow(radius: 5,x:7,y:7)
                }
                VStack(spacing:70){
                    Text("$"+String(bounty.bountyPrice))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .frame(width:40,height:40)
                        .background{
                            RoundedRectangle(cornerRadius: 12,style:.continuous)
                                .fill(.white)
                        }
                        .frame(maxWidth: .infinity,alignment: .topTrailing)
                        .padding(15)
                        .padding(.bottom,35)
                        .shadow(radius: 5,x:6,y:6)
                    
                    
                    HStack{
                        VStack(alignment:.leading,spacing: 14){
                            Text(bounty.itemName)
                                .font(.callout)
                                .fontWeight(.semibold)
                            
                                .frame(maxWidth:.infinity,alignment:.center)
                                .lineLimit(1)
                            Text(bounty.location)
                                .font(.callout)
                                .frame(maxWidth:.infinity,alignment:.center)
                                .lineLimit(1)
                                
                            
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height:60)
                    .background{
                        RoundedRectangle(cornerRadius: 15,style:.continuous)
                            .fill(.white)
                            .shadow(radius: 5,x:7,y:7)
                    }
                    .padding(8)
                    .padding(.bottom,20)
                    
                    
                }
            }
        }
    }

}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
    }
}
