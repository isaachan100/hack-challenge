//
//  LoginView.swift
//  BigRedBounty
//
//  Created by user228377 on 12/1/22.
//

import SwiftUI

struct LoginView: View {
    
    @State var delayPassed:Bool = false
    
    @State var index = 0
    var body: some View {
        
        NavigationView{
            ZStack{
               
                    LinearGradient(colors: [Color(red: 239/255, green: 71/255, blue: 58/255),Color(red: 203/255, green: 45/255, blue: 62/255)], startPoint: .topTrailing, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                
                Circle()
                    .scaleEffect(delayPassed ?  1.8 : 0)
                    .animation(.interpolatingSpring(stiffness: 80, damping: 8).delay(0.2),value:delayPassed ? 1.6 : 0)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scaleEffect(delayPassed ? 1.45 : 0)
                    .animation(.interpolatingSpring(stiffness: 80, damping: 8).delay(0.3),value:delayPassed ? 1.25 : 0)
                    .foregroundColor(.white.opacity(0.1))
                GeometryReader{_ in
                    VStack{
                        ZStack{
                            SignUp(index: self.$index)
                                .zIndex(Double(self.index))
                            Login(index: self.$index)
                            
                        }
                    }
                    
                }
                .offset(y:220)
                .scaleEffect(delayPassed ? 1 : 0)
                .animation(.interpolatingSpring(stiffness: 80, damping: 10).delay(0.2),value:delayPassed ? 1 : 0)
                

            }
            .task(delayCircle)
            
        }
    }
    func delayCircle() async {
        try? await Task.sleep(nanoseconds: 200_000_000)
        delayPassed = true
    }
    
}


struct CShape:Shape{
    func path(in rect: CGRect) -> Path {
        return Path{path in
            //right side curve
            path.move(to:CGPoint(x: rect.width, y: 100))
            path.addLine(to:CGPoint(x:rect.width,y:rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
    
    
}
struct CShape1:Shape{
    func path(in rect: CGRect) -> Path {
        return Path{path in
            //left side curve
            path.move(to:CGPoint(x: 0, y: 100))
            path.addLine(to:CGPoint(x:0,y:rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
    
    
}

struct Login:View{
    @State var email = ""
    @State var pass = ""
    @State var loginSuccess: Bool = false
    @Binding var index:Int
    var body: some View{
        ZStack(alignment:.bottom){
            VStack{
                HStack{
                    
                    VStack(spacing:10){
                        Text("Login")
                            .foregroundColor(.black)
                            .font(.title)
                            .fontWeight(.bold)
                        Capsule()
                            .fill(self.index == 0 ? Color.blue : Color.clear)
                            .frame(width:100,height:5)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.top,30)
                VStack{
                    HStack(spacing:15){
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.black)
                        TextField("Email Address",text:self.$email)
                    }
                    Divider().background(.black)
                }
                .padding(.horizontal)
                .padding(.top,40)
                VStack{
                    HStack(spacing:15){
                        Image(systemName: "lock.fill")
                            .foregroundColor(.black)
                        SecureField("Password",text:self.$pass)
                    }
                    Divider().background(.black)
                }
                .padding(.horizontal)
                .padding(.top,30)
                HStack{
                    Spacer(minLength: 0)
                    Button(action:{
                        
                    }){
                        Text("Forgot Password?")
                            .foregroundColor(.black.opacity(0.6))
                    }
                }
                .padding(.horizontal)
                .padding(.top,30)
                
            }
            .padding()
            .padding(.bottom,55)
            .background(.white)
            .clipShape(CShape())
            .contentShape(CShape())
            .shadow(color:Color.black.opacity(0.3),radius: 5,x:0,y:-5)
            .onTapGesture {
                self.index = 0
            }
            .cornerRadius(35)
            .padding(.horizontal,20)
            NavigationLink(destination: ContentView(), isActive:$loginSuccess){
            Button(action:{
                loginSuccess = true
            }){
                Text("LOGIN")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal,50)
                    .background(LinearGradient(colors: [.cyan,.blue], startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                    .shadow(radius: 5,x:0,y:5)
            }
            .offset(y:15)
            .opacity(self.index == 0 ? 1 : 0)
        }
        }
    }
}
struct SignUp:View{
    @State var email = ""
    @State var pass = ""
    @State var name = ""
    @Binding var index:Int
    var body: some View{
        ZStack(alignment:.bottom){
            VStack{
                HStack{
                    Spacer(minLength: 0)
                    VStack(spacing:10){
                        Text("SignUp")
                            .foregroundColor(.black)
                            .font(.title)
                            .fontWeight(.bold)
                        Capsule()
                            .fill(self.index == 1 ? Color.blue : Color.clear)
                            .frame(width:100,height:5)
                    }
                    
                }
                .padding(.top,30)
                VStack{
                    HStack(spacing:15){
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.black)
                        TextField("Name",text:self.$name)
                    }
                    Divider().background(.black)
                }
                .padding(.horizontal)
                .padding(.top,40)
                VStack{
                    HStack(spacing:15){
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.black)
                        TextField("Email Address",text:self.$email)
                    }
                    Divider().background(.black)
                }
                .padding(.horizontal)
                .padding(.top,30)
                VStack{
                    HStack(spacing:15){
                        Image(systemName: "lock.fill")
                            .foregroundColor(.black)
                        SecureField("Password",text:self.$pass)
                    }
                    Divider().background(.black)
                }
                .padding(.horizontal)
                .padding(.top,30)
                
                
            }
            .padding()
            .padding(.bottom,55)
            .background(.white)
            .clipShape(CShape1())
            .contentShape(CShape1())
            .shadow(color:Color.black.opacity(0.3),radius: 5,x:0,y:-5)
            .onTapGesture {
                self.index = 1
            }
            .cornerRadius(35)
            .padding(.horizontal,20)
            
            Button(action:{
                NetworkController.postUser(name: name, email: email, password: pass)
            }){
                Text("SIGNUP")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal,50)
                    .background(LinearGradient(colors: [.cyan,.blue], startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                    .shadow(radius: 5,x:0,y:5)
            }
            .offset(y:15)
            
            .opacity(self.index == 1 ? 1 : 0)
        }
    }
    
    
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
