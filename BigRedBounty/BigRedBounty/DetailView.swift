//
//  DetailView.swift
//  BigRedBounty
//
//  Created by user228377 on 11/25/22.
//

import SwiftUI

struct DetailView: View {
    @Binding var showView:Bool
    var animation:Namespace.ID
    var bounty:Bounty
    @State var showContent:Bool = false
    var body: some View {
        VStack(spacing:0){
        }
        .frame(maxWidth: .infinity,maxHeight:.infinity)
        .overlay(alignment:.top,content: {
            HeaderView()
                .opacity(showContent ? 1 : 0)
        })
        .background{
            Rectangle()
                .fill(Color(red: 255/255, green: 83/255, blue: 73/255).gradient)
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


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
