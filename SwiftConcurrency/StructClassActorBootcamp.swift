//
//  StructClassActorBootcamp.swift
//  SwiftConcurrency
//
//  Created by Abdul Aleem on 14/01/26.
//

import SwiftUI


actor  StructClassActorBootcampDataManager {
    
}


class StructClassActorBootcampViewModel: ObservableObject {
    @Published var title:String = ""
    
    init() {
        print("Viewmodel INIT")
    }
}

struct StructClassActorBootcamp: View {
    
    @StateObject  private var viewMOdel = StructClassActorBootcampViewModel()
    let isActive:Bool
    
    init(isActive:Bool) {
        self.isActive = isActive
        print("View INIT")
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity, maxHeight:  .infinity)
            .ignoresSafeArea()
            .background(isActive ? Color.red : Color.green)
            .onAppear {
//               runTest()
            }
    }
}

struct StructClassActorBootcampHomeView:View {
    
    @State private var isActive:Bool = false
    var body: some View {
        StructClassActorBootcamp(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
             }
    }
}



#Preview {
    StructClassActorBootcamp(isActive: true )
}

extension StructClassActorBootcamp {
    private func runTest() {
        print("Test started")
        structTest1()
        printDivider()
        classTest1()
        printDivider()
        actorTest1()
//        structTest2()
//        printDivider()
//        classTest2()
        
    }
    
    private func printDivider() {
        print("""

- - - - - - -  - - - - - - - - - - - -  - -- - - -- - - - - - -- - - - -

""")
    }
    
    private func structTest1() {
        print("structTest1")
        let objectA = MyStruct(title: "Starting title!")
        print("objectA: ",objectA.title)
        
        print("Pass the VALUES of objectA to objectB.")
        var objectB = objectA
        print("objectB: ",objectB.title)
        
        objectB.title = "Second Title!"
        print("objectB title changed.")
        
        print("objectA: ",objectA.title)
        print("objectB: ",objectB.title)
    }
    
    private func classTest1() {
        print("classTest1")
        let objectA = MyClass(title: "Starting Title!")
        print("objectA: ",objectA.title)
        
        print("Pass the REFERENCE of objectA to objectB.")
        let objectB = objectA
        print("objectB: ",objectB.title)
        
        objectB.title = "Second Title!"
        print("objectB title changed.")
        
        print("objectA: ",objectA.title)
        print("objectB: ",objectB.title)
    }
    
    private func actorTest1() {
        Task {
            print("actorTest1")
            let objectA = MyActor(title: "Starting Title!")
            await print("objectA: ",objectA.title)
            
            print("Pass the REFERENCE of objectA to objectB.")
            let objectB = objectA
            await  print("objectB: ",objectB.title)
            
           await objectB.updatingTitle(newTitle: "Second Title!")
            print("objectB title changed.")
            
            await print("objectA: ",objectA.title)
            await print("objectB: ",objectB.title)
        }
        
    }
}

struct MyStruct {
    var title: String
}

//Immutable struct
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}

struct MutatingStruct {
  private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updatingTitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActorBootcamp {
    
    private func structTest2() {
        print("structTest2")
        
        let struct1 = MyClass(title: "Title1")
        print("Struct1: ",struct1.title)
        
        struct1.title = "Title2"
        print("Struct1: ",struct1.title)
        
        var  struct2 = CustomStruct(title: "Title1")
        print("Struct2: ",struct2.title)
        
        struct2 = CustomStruct(title: "Title2")
        print("Struct2: ",struct2.title)
        
        
        var struct3 = CustomStruct(title: "Title1")
        print("Struct3: ",struct3.title)
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("Struct3: ",struct3.title)
        
        var struct4 = MutatingStruct(title: "Title4")
        print("Struct4: ",struct4.title)
        
        struct4.updatingTitle(newTitle: "Title2")
        print("Struct4: ",struct4.title)
    }
}


class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
     func updatingTitle(newTitle: String) {
        title = newTitle
    }
}

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
     func updatingTitle(newTitle: String) {
        title = newTitle
    }
}


extension StructClassActorBootcamp {
    
    private func classTest2() {
        print("classTest2")
        
        
        let class1 = MyClass(title: "Title1")
        print("class1: ",class1.title)
        class1.title = "Title2"
        print("class1: ",class1.title)
        
        
        let class2 = MyClass(title: "Title1")
        print("class2: ",class2.title)
        class2.updatingTitle(newTitle: "Title2")
        print("class2: ",class2.title)
    }
}
