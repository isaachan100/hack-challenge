//
//  DetailView.swift
//  BigRedBounty
//
//  Created by user228377 on 11/25/22.
//

import SwiftUI

struct UserDetailView: View {
    @Binding var showView:Bool
    var animation2:Namespace.ID
    var bounty:Bounty
    @State var showContent:Bool = false
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            VStack(spacing:0){
                
                Text(bounty.itemName)
                    .padding(15)
                    .font(.title)
                    .fontWeight(.bold)
                    .background(.white)
                    .cornerRadius(15)
                    .padding(.top,-90)
                    .offset(x:showContent ? 0 : 1000)
                    .shadow(radius: 5,x:11,y:11)
                    
                Image(bounty.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .matchedGeometryEffect(id: bounty.id, in: animation2)
                    .frame(width:size.width-50,height:size.height/2.5)
                    .clipped()
                    .cornerRadius(20)
                    .shadow(radius: 5,x:11,y:11)
                VStack(spacing:5){
                    VStack{
                        Text(bounty.description)
                            .font(.system(size: 16))
                            .multilineTextAlignment(.leading)
                            .lineSpacing(8)
                            .padding(.vertical,20)
                            .padding(.horizontal,10)
                            
                    }
                    
                   
                    
                    .cornerRadius(20)
                    .background(.gray.opacity(0.2))
                    HStack{
                        Text("Last Sighted in:")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .frame(maxWidth:.infinity,alignment:.leading)
                        Text(bounty.location)
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .padding(10)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(15)
                            .frame(maxWidth:.infinity,alignment:.leading)
                    }
                    //.padding(10)
                    .offset(y:20)
                    HStack{
                        Text("Bounty:")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .frame(maxWidth:.infinity,alignment:.leading)
                        Text("$"+String(bounty.bountyPrice))
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .padding(10)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(15)
                            .frame(maxWidth:.infinity,alignment:.leading)
                    }
                    .padding(10)
                    .offset(y:30)
                    
                    Button{
                        
                    } label: {
                        Text("Remove Post")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(15)
                           
                            .background{
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(LinearGradient(colors: [.red.opacity(0.6),.red], startPoint: .leading, endPoint: .trailing))
                            }
                            
                        
                    }
                    .offset(y:30)
                    .padding(10)
                    .shadow(radius: 8,x:8,y:8)
                    
                   
                    
                }
                .padding(15)
                .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
                .background{
                    CustomCorner(corners: [.topLeft,.topRight], radius: 25)
                        .fill(.white)
                        .ignoresSafeArea()
                }
                .offset(y:showContent ? 0 : (size.height / 1.5))
                .padding(.top,25)
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        }
        .padding(.top,100)
        .frame(maxWidth: .infinity,maxHeight:.infinity)
        .overlay(alignment:.top,content: {
            HeaderView()
                .opacity(showContent ? 1 : 0)
        })
        .background{
            Rectangle()
                //.fill(Color(red: 255/255, green: 83/255, blue: 73/255).gradient)
                .fill(LinearGradient(colors: [Color(red: 239/255, green: 71/255, blue: 58/255),Color(red: 203/255, green: 45/255, blue: 62/255)], startPoint: .topTrailing, endPoint: .bottomLeading))
                .ignoresSafeArea()
                .opacity(showContent ? 1 : 0)
        }
        .onAppear{
            withAnimation(.easeInOut(duration: 0.35).delay(0.05)){
                showContent = true
            }
        }
    }
    @ViewBuilder
    func HeaderView()->some View{
        Button{
            withAnimation(.easeInOut(duration: 0.3)){
                showContent = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.05){
                showTabBar()
                withAnimation(.easeInOut(duration: 0.35)){
                    showView = false
                }
            }
        }label:{
            Image(systemName: "chevron.left")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding(15)
        .frame(maxWidth: .infinity,alignment: .leading)
        
    }
    }


struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
