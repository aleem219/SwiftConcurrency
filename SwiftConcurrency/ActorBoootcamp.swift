//
//  ActorBoootcamp.swift
//  SwiftConcurrency
//
//  Created by Abdul Aleem on 14/01/26.
//

import SwiftUI


class MyDataManager {
    static let instance = MyDataManager()
    private init() { }
    
    var data: [String] = []
    private let queue  = DispatchQueue(label: "com.MyApp.MyDataManager")
    
    func getRandomData(compilationHandler: @escaping (_ title : String?) -> ()) {
        queue.sync {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            compilationHandler(self.data.randomElement())
        }
    }
    
    
}

actor MyActorDataManager {
    static let instance = MyActorDataManager()
    private init() { }
    
    var data: [String] = []
    nonisolated let myRandomText = "gfxgdfxggcgfcfgcgggfcgfc"
    
    func getRandomData() -> String?  {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return self.data.randomElement()
    }
    
   nonisolated func getSavedData() -> String {
        return "NEW DATA "
    }
}


struct HomeView: View {
//    let manager = MyDataManager.instance
    let manager = MyActorDataManager.instance
    @State private var text:String = ""
    let timer = Timer.publish(every: 0.1,tolerance: nil, on: .main, in: .common,options: nil).autoconnect()
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onAppear(perform: {
            let newString = manager.myRandomText
            Task {
//               await manager.data
                let newString = await manager.getSavedData()
            }
   
        })
        .onReceive(timer) { _ in
//            DispatchQueue.global(qos: .background).async {
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//            }
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
            
        }
    }
}

struct BrouseView: View {
    
//    let manager = MyDataManager.instance
    let manager = MyActorDataManager.instance
    @State private var text:String = ""
    let timer = Timer.publish(every: 0.01,tolerance: nil, on: .main, in: .common,options: nil).autoconnect()
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onAppear(perform: {
            Task {
               await manager.data
            }
   
        })
        .onReceive(timer) { _ in
 
//            DispatchQueue.global(qos: .default).async {
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//            }
            
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
        }
    }
}

struct ActorBoootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            BrouseView()
                .tabItem {
                    Label("Brouse", systemImage: "magnifyingglass")
                }
        }
        
    }
}

#Preview {
    ActorBoootcamp()
}
