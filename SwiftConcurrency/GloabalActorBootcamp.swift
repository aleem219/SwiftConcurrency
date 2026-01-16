//
//  GloabalActorBootcamp.swift
//  SwiftConcurrency
//
//  Created by Abdul Aleem on 16/01/26.
//

import SwiftUI

//@globalActor struct MyFirstGlobalActor {
@globalActor final class MyFirstGlobalActor {
    static var shared = MyNewDataManager()
}

actor MyNewDataManager {
    
    func getMnangerDatabase() ->[String] {
        
        return["One","Two","Three","Four","Five","Six"]
    }
    
}

@MainActor class GloabalActorBootcampViewModel:ObservableObject {
    @MainActor @Published var dataArray:[String] = []
//    @Published var dataArray2:[String] = []
//    @Published var dataArra3:[String] = []
//    @Published var dataArray4:[String] = []
    let manager = MyFirstGlobalActor.shared
    
//    @MyFirstGlobalActor
   nonisolated func getData() {
        
        Task {
            let data = await manager.getMnangerDatabase()
            await MainActor.run {
                self.dataArray = data
            }
        }
    }
    
}

struct GloabalActorBootcamp: View {
    @StateObject private var viewModel = GloabalActorBootcampViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
             viewModel.getData()
        }
    }
}

#Preview {
    GloabalActorBootcamp()
}
