//
//  LoginView.swift
//  BigRedBounty
//
//  Created by user228377 on 12/1/22.
//

import SwiftUI

struct LoginView: View {
    @State var loginSuccess: Bool = false
    var body: some View {
        NavigationView{
            NavigationLink(destination:MainView(),isActive: $loginSuccess){
                Button("Hello"){
                    loginSuccess = true
                }
            }
            
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
