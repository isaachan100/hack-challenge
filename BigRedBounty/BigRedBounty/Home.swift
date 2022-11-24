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
        
    }
    @ViewBuilder
    func HeaderView()->some View{
        HStack{
           
                Text("Bounties")
                    .font(.title.bold())
                    .padding(10)
                    .foregroundColor(.white)
                    .background(.red)
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
                            .fill(.red)
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
                    
                }){
                    Text("Newest").padding(.vertical).padding(.horizontal,15).foregroundColor(.gray.opacity(0.9))
                }
                .background(.gray.opacity(0.2))
                .cornerRadius(15)
                .frame(maxWidth:.infinity,alignment: .leading)
                .padding(.leading,2)
                .padding(.top,10)
                Button(action: {
                    
                }){
                    Text("Highest Bounty").padding(.vertical).padding(.horizontal,15).foregroundColor(.gray.opacity(0.9)).lineLimit(1)
                }
                .background(.gray.opacity(0.2))
                .cornerRadius(15)
                .frame(maxWidth:.infinity,alignment: .center)
                .padding(.leading,-25)
                .padding(.top,10)
                Button(action: {
                    
                }){
                    Text("Name").padding(.vertical).padding(.horizontal,15).foregroundColor(.gray.opacity(0.9))
                }
                .background(.gray.opacity(0.2))
                .cornerRadius(15)
                .frame(alignment: .trailing)
                .padding(.trailing,2)
                .padding(.leading,20)
                .padding(.top,10)
            }
            CustomCarousel(index: $currentIndex, items: bounties, spacing:25,cardPadding:90,id: \.id){bounty, size in
                BountyCardView(bounty: bounty, size: size)
            }
            .frame(height:400)
            .padding(.top,20)
            .padding(.horizontal,10)
        }
        .padding(.top,10)
    }
    
    @ViewBuilder
    func BountyCardView(bounty:Bounty,size:CGSize)->some View{
        ZStack{
            LinearGradient(colors: [.red.opacity(0.25),.red.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .clipShape(RoundedRectangle(cornerRadius: 30,style:.continuous))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
