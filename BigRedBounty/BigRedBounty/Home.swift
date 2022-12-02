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
    
    @State var showSheet = false
    @State var locationFilter:String = ""
    @State var minBountyFilter:String = ""
    
    @State var tempList:[Bounty] = bounties
    
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
            .background(LinearGradient(colors: [.white.opacity(0.7),.red.opacity(0.15),.red.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
            //.background(.ultraThinMaterial)
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
           
                Text("Big Red Bounty")
                    .font(.title.bold())
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color(red: 239/255, green: 71/255, blue: 58/255))
                    .cornerRadius(15)
            
            .frame(maxWidth: .infinity,alignment: .center)
            .shadow(radius: 8,x:6,y:6)
            
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
                        
                        if searchText == ""{
                            tempList = bounties
                        }
                        else{
                            tempList = tempList.filter{
                                $0.itemName.contains(searchText)
                            }
                        }
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
                showSheet = true
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
            .sheet(isPresented: $showSheet){
               
                ScrollView{
                    VStack(spacing:60){
                        Text("Filter by")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top,30)
                        HStack(spacing:25){
                            Text("Location:")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.leading,0)
                            TextField("Enter location",text:$locationFilter)
                                .foregroundColor(.gray)
                                .padding(10)
                                .frame(width:200)
                                .background(.gray.opacity(0.3))
                                .cornerRadius(10)
                                .lineLimit(1)
                            
                        }
                        HStack(spacing:25){
                            Text("Minimum Bounty:")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.leading,0)
                            TextField("Enter amount",text:$minBountyFilter)
                                .foregroundColor(.gray)
                                .padding(10)
                                .frame(width:200)
                                .background(.gray.opacity(0.3))
                                .cornerRadius(10)
                                .lineLimit(1)
                            
                        }
                        Button{
                            if locationFilter == "" && minBountyFilter == "" {
                                tempList = bounties
                                
                            }
                            else{
                                
                                if locationFilter != "" && minBountyFilter != ""{
                                    tempList = bounties.filter{
                                        $0.location.contains( locationFilter)
                                    }
                                    tempList = tempList.filter{
                                        $0.bountyPrice >= Int(minBountyFilter)!
                                    }
                                }
                                else if locationFilter != ""
                                {
                                    tempList = bounties.filter{
                                        $0.location.contains( locationFilter)
                                    }
                                }
                                else if minBountyFilter != ""
                                {
                                    tempList = bounties.filter{
                                        $0.bountyPrice >= Int(minBountyFilter)!
                                    }
                                }
                            }
                                               
                            showSheet = false
                        }label:{
                            Text("Apply")
                                .fontWeight(.semibold)
                                .font(.title2)
                                .padding(10)
                                .padding(.horizontal,20)
                                .foregroundColor(.white)
                                .background(.linearGradient(colors:[.cyan,.blue], startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(10)
                        }
                    }
                }
                    .presentationDetents([.fraction(0.55),.large])
                    .presentationDragIndicator(.visible)
                                }
        }
        .shadow(radius: 8,x:6,y:6)
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
                    tempList = tempList.sorted{
                        $0.timestamp < $1.timestamp
                    }
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
                .shadow(color:button1Pressed ? .black.opacity(0.33) : .gray.opacity(0.2),radius: 8,x:6,y:6)
                Button(action: {
                    button2Pressed = true
                    button1Pressed = false
                    button3Pressed = false
                    tempList = tempList.sorted{
                        $0.bountyPrice > $1.bountyPrice
                    }
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
                .shadow(color:button2Pressed ? .black.opacity(0.33) : .gray.opacity(0.2),radius: 8,x:6,y:6)
                Button(action: {
                    button3Pressed = true
                    button1Pressed = false
                    button2Pressed = false
                    tempList = tempList.sorted{
                        $0.itemName < $1.itemName
                    }
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
                .shadow(color:button3Pressed ? .black.opacity(0.33) : .gray.opacity(0.2),radius: 8,x:6,y:6)
            }
            
            CustomCarousel(index: $currentIndex, items: tempList, spacing:25,cardPadding:90,id: \.id){bounty, size in
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
            LinearGradient(colors: [.red.opacity(0.2),.red.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .clipShape(RoundedRectangle(cornerRadius: 30,style:.continuous))
                .shadow(color:.black.opacity(0.05),radius: 8,x:6,y:6)
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
                        .shadow(radius: 8,x:6,y:6)
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
                        .shadow(radius: 8,x:6,y:6)
                    
                    
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
                    .shadow(radius: 8,x:6,y:6)
                    
                    
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
