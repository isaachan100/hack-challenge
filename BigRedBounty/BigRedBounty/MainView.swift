//
//  MainView.swift
//  BigRedBounty
//
//  Created by user228377 on 11/23/22.
//

import SwiftUI

struct MainView: View {
    @State var currentTab:Tab = .home
    @Namespace var animation
    init(){
        UITabBar.appearance().isHidden = true
    }
    @State var showTabBar: Bool = true
    var body: some View {
        ZStack(alignment: .bottom){
            TabView(selection: $currentTab){
                Home()
                    .setTabBarBackground(color: Color("BG"))
                    .tag(Tab.home)
                Post()
                    .setTabBarBackground(color: Color("BG"))
                    .tag(Tab.plus)
                Profile()
                    .setTabBarBackground(color: Color("BG"))
                    .tag(Tab.profile)
            }
            TabBar()
                .offset(y:showTabBar ? 0 : 130)
                .animation(.interactiveSpring(response:0.6,dampingFraction:0.7,blendDuration: 0.7), value: showTabBar)
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.keyboard,edges:.bottom)
        .onReceive(NotificationCenter.default.publisher(for: .init("SHOWTABBAR"))){_ in
            showTabBar = true
            
        }
        .onReceive(NotificationCenter.default.publisher(for: .init("HIDETABBAR"))){_ in
            showTabBar = false
            
        }
    }
    
    @ViewBuilder
    func TabBar()->some View{
        HStack(spacing:0){
            ForEach(Tab.allCases,id:\.rawValue){tab in
                Image(systemName:"\(tab.rawValue)")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24,height:24)
                    .foregroundColor(currentTab == tab ? .white : .gray.opacity(0.5))
                    .offset(y: currentTab == tab ? -30 : 0)
                    .background(content:{
                        if currentTab == tab{
                            Circle()
                                .fill(Color(red: 239/255, green: 71/255, blue: 58/255))
                                .scaleEffect(2.5)
                                .shadow(color: .black.opacity(0.3),radius:8,x:5,y:10)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                                .offset(y: currentTab == tab ? -30 : 0)
                        }
                    })
                    .frame(maxWidth:.infinity)
                    .padding(.top,15)
                    .padding(.bottom,10)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        currentTab = tab
                    }
                    
            }
        }
        
        .padding(.horizontal,15)
        .animation(.interactiveSpring(response:0.5,dampingFraction: 0.65,blendDuration: 0.65),value:currentTab)
        .background{
            CustomCorner(corners: [.topLeft,.topRight], radius: 25)
                .fill(.gray.opacity(0.2))
                
                .ignoresSafeArea()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View{
    
    func showTabBar(){
        NotificationCenter.default.post(name: NSNotification.Name("SHOWTABBAR"), object: nil)
    }
    
    func hideTabBar(){
        NotificationCenter.default.post(name: NSNotification.Name("HIDETABBAR"), object: nil)
    }
    @ViewBuilder
    func setTabBarBackground(color:Color)->some View{
        self
            .frame(maxWidth:.infinity,maxHeight: .infinity)
            .background{
                color
                    .ignoresSafeArea()
            }
    }
}
