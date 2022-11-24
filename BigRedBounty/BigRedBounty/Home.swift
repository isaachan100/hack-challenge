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
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            VStack(spacing:15){
                HeaderView()
                
                SearchView()
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
            
            .frame(maxWidth: .infinity,alignment: .leading)
            
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
                Image(systemName: "line.horizontal.3.decrease")
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
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
