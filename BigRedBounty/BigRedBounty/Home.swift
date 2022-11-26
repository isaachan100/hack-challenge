//
//  Home.swift
//  BigRedBounty
//
//  Created by user228377 on 11/23/22.
//

import SwiftUI

struct Home: View {
    @State var searchText = ""
    @State var searching = false
    @State var currentIndex:Int = 0
    @State var button1Pressed:Bool = true
    @State var button2Pressed:Bool = false
    @State var button3Pressed:Bool = false
    @State var showDetailView:Bool = false
    @State var currentDetailBounty:Bounty?
    @Namespace var animation
    
    var body: some View {
        
        ScrollView(.vertical,showsIndicators: false){
            VStack(spacing:15){
                HeaderView()
                
                SearchView()
                
                BountiesView()
            }
            .padding(15)
            .padding(.bottom,50)
        }
        .background(LinearGradient(colors: [.gray.opacity(0.05),.red.opacity(0.1),.red.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .overlay{
            if let currentDetailBounty,showDetailView{
                DetailView(showView: $showDetailView, animation: animation, bounty: currentDetailBounty)
                    .transition(.asymmetric(insertion: .identity, removal: .offset(x:0.5)))
            }
        }
    }
    @ViewBuilder
    func HeaderView()->some View{
        HStack{
           
                Text("Bounties")
                    .font(.title.bold())
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color(red: 239/255, green: 71/255, blue: 58/255))
                    .cornerRadius(15)
            
            .frame(maxWidth: .infinity,alignment: .center)
            
        }
       
    }
    
    @ViewBuilder
    func SearchView()->some View{
        HStack(spacing:15){
            HStack(spacing: 15){
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24,height:24)
                
                Divider()
                    .padding(.vertical,-6)
                TextField("Search", text: $searchText){startedEditing in
                    if startedEditing{
                        withAnimation{
                            searching = true
                        }
                    }
                    
                } onCommit:{
                    withAnimation{
                        searching = false
                    }
                }
            }
            .padding(15)
            .background{
                RoundedRectangle(cornerRadius: 10,style:.continuous)
                    .fill(.gray.opacity(0.15))
            }
            Button{
                
            }label:{
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .aspectRatio(contentMode: .fit)
                    .frame(width:22,height:22)
                    .padding(15)
                    .background{
                        RoundedRectangle(cornerRadius: 10,style:.continuous)
                            .fill(Color(red: 239/255, green: 71/255, blue: 58/255))
                    }
            }
        }
        .padding(.top,15)
    }
    
    @ViewBuilder
    func BountiesView() -> some View{
        VStack(alignment: .leading, spacing:15){
            HStack(alignment:.center,spacing:0){
                Button(action: {
                    button1Pressed = true
                    button2Pressed = false
                    button3Pressed = false
                }){
                    Text("Newest").padding(.vertical).padding(.horizontal,15)
                        .fontWeight(.semibold)
                        .foregroundColor(button1Pressed ? .white : .gray.opacity(0.9))
                }
                .background(button1Pressed ? Color(red: 239/255, green: 71/255, blue: 58/255) :.gray.opacity(0.2))
                .cornerRadius(15)
                .frame(maxWidth:.infinity,alignment: .leading)
                .padding(.leading,2)
                .padding(.top,10)
                Button(action: {
                    button2Pressed = true
                    button1Pressed = false
                    button3Pressed = false
                }){
                    Text("Highest Bounty").padding(.vertical).padding(.horizontal,15)
                        .fontWeight(.semibold)
                        .foregroundColor(button2Pressed ? .white : .gray.opacity(0.9)).lineLimit(1)
                }
                .background(button2Pressed ? Color(red: 239/255, green: 71/255, blue: 58/255) : .gray.opacity(0.2))
                .cornerRadius(15)
                .frame(maxWidth:.infinity,alignment: .center)
                .padding(.leading,-25)
                .padding(.top,10)
                Button(action: {
                    button3Pressed = true
                    button1Pressed = false
                    button2Pressed = false
                }){
                    Text("Name").padding(.vertical).padding(.horizontal,15)
                        .fontWeight(.semibold)
                        .foregroundColor(button3Pressed ? .white : .gray.opacity(0.9))
                }
                .background(button3Pressed ? Color(red: 239/255, green: 71/255, blue: 58/255) : .gray.opacity(0.2))
                .cornerRadius(15)
                .frame(alignment: .trailing)
                .padding(.trailing,2)
                .padding(.leading,20)
                .padding(.top,10)
            }
            CustomCarousel(index: $currentIndex, items: bounties, spacing:25,cardPadding:90,id: \.id){bounty, size in
                BountyCardView(bounty: bounty, size: size)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideTabBar()
                        withAnimation(.interactiveSpring(response:0.5,dampingFraction:0.7,blendDuration: 0.7)){
                            currentDetailBounty = bounty
                            showDetailView = true
                        }
                    }
            }
            .frame(height:380)
            .padding(.top,20)
            .padding(.horizontal,10)
        }
        .padding(.top,10)
    }
    
    @ViewBuilder
    func BountyCardView(bounty:Bounty,size:CGSize)->some View{
        ZStack{
            //LinearGradient(colors: [.red.opacity(0.25),.red.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
            LinearGradient(colors: [.red.opacity(0.25),.red.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .clipShape(RoundedRectangle(cornerRadius: 30,style:.continuous))
            ZStack{
                if currentDetailBounty?.id == bounty.id && showDetailView{
                    Rectangle()
                        .fill(.clear)
                }
                else{
                    Image(bounty.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .matchedGeometryEffect(id: bounty.id, in: animation)
                        .frame(width:210,height:200)
                        .clipped()
                        .cornerRadius(20)
                        .padding(.bottom,110)
                }
                VStack(spacing:130){
                    Text("$"+String(bounty.bountyPrice))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .frame(width:50,height:50)
                        .background{
                            RoundedRectangle(cornerRadius: 12,style:.continuous)
                                .fill(.white)
                        }
                        .frame(maxWidth: .infinity,alignment: .topTrailing)
                        .padding(15)
                        .padding(.bottom,35)
                    
                    
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
                    .frame(height:100)
                    .background{
                        RoundedRectangle(cornerRadius: 25,style:.continuous)
                            .fill(.white)
                    }
                    .padding(10)
                    .padding(.bottom,15)
                    
                    
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
