//
//  NetworkController.swift
//  BigRedBounty
//
//  Created by user228377 on 12/2/22.
//

import SwiftUI

struct NetworkController {
    static func postUser(name:String,email:String,password:String){
        guard let url = URL(string:"http://34.86.92.101/api/users/")else{return}
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body:[String:Any]=[
            "name":name,
            "email":email,
            "password":password
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: body,options: [])
        }catch let error{
            print("error occurred")
        }
        
        URLSession.shared.dataTask(with: request){(data,response,error) in
            if let error = error{
                print("error",error)
                return
            }
            if let data = data{
                do{
                    if let json = try JSONSerialization.jsonObject(with: data,options:[]) as? [String:Any]{
                        print("json:",json)
                    }
                }catch let error{
                    print("whoops",error)
                }
            }
        }.resume()
                
    }
}


