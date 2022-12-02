//
//  LoginView.swift
//  BigRedBounty
//
//  Created by user228377 on 12/1/22.
//

import SwiftUI

struct LoginView: View {
    @State var loginSuccess: Bool = false
    @State var delayPassed:Bool = false
    
    var body: some View {
        
        NavigationView{
            ZStack{
               
                    LinearGradient(colors: [Color(red: 239/255, green: 71/255, blue: 58/255),Color(red: 203/255, green: 45/255, blue: 62/255)], startPoint: .topTrailing, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                
                Circle()
                    .scaleEffect(delayPassed ?  1.6 : 0)
                    //.animation(.linear(duration: 0.55),value:delayPassed ?  1.6 : 0)
                    .animation(.interpolatingSpring(stiffness: 80, damping: 8).delay(0.2),value:delayPassed ? 1.6 : 0)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scaleEffect(delayPassed ? 1.25 : 0)
                    //.animation(.linear(duration:0.6),value:delayPassed ? 1.25 : 0)
                    .animation(.interpolatingSpring(stiffness: 80, damping: 8).delay(0.3),value:delayPassed ? 1.25 : 0)
                    .foregroundColor(.white)
                
                
                            NavigationLink(destination:MainView(),isActive: $loginSuccess){
                                Button{
                                   loginSuccess = true
                                }label:{
                                    Text("Sign in")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .padding(15)
                                        .background(.blue)
                                        .cornerRadius(15)
                                }
                                .scaleEffect(delayPassed ? 1 : 0)
                                .animation(.interpolatingSpring(stiffness: 80, damping: 8).delay(0.3),value:delayPassed ? 1 : 0)
                                
                            }
            }
            .task(delayCircle)
            
        }
    }
    func delayCircle() async {
        try? await Task.sleep(nanoseconds: 500_000_000)
        delayPassed = true
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
