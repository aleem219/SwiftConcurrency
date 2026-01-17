//
//  SendableBootCamp.swift
//  SwiftConcurrency
//
//  Created by Abdul Aleem on 17/01/26.
//

import SwiftUI

actor CurrentUserManager {
    
    func updateDataBase(userInfo: MyClassInfo) {
        
    }
}

struct MyUserInfo:Sendable {
    var name: String
}

final class MyClassInfo: @unchecked Sendable {
    private  var name: String
    let queue = DispatchQueue(label:"com.MyApp.MyClassInfo")
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
}



class SendableBootCampViewModel: ObservableObject {
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        
        let info = MyClassInfo(name: "info")
        await  manager.updateDataBase(userInfo: info)
    }
}

struct SendableBootCamp: View {
    
    @StateObject private var viewModel = SendableBootCampViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                
            }
    }
}

#Preview {
    SendableBootCamp()
}
