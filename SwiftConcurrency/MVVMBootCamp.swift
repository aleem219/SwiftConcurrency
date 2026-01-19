//
//  MVVMBootCamp.swift
//  SwiftConcurrency
//
//  Created by Abdul Aleem on 19/01/26.
//

import SwiftUI

final class MyManagerClass {
    
    func getData() async throws -> String {
        "Some Data"
    }
}

actor MyManagerActor {
    func getData() async throws -> String {
        "Some Data"
    }
}

@MainActor
final class MVVMBootCampViewMOdel: ObservableObject {
    let managerclass = MyManagerClass()
    let managerActor = MyManagerActor()
    
   /*@MainActor*/ @Published private(set) var myData: String = "Starting Text"
    private var tasks: [Task<Void, Never>] = []
    
    
    func cancelTask() {
        tasks.forEach {  $0.cancel() }
        tasks = []
    }
    
//    @MainActor
    func onCallToActionButtonPressed() {
      let task = Task { /*@MainActor in*/
          do {
              myData = try await managerclass.getData()
              myData = try await managerActor.getData()
          } catch {
              print(error)
          }
        }
        tasks.append(task)
    }
}

struct MVVMBootCamp: View {
    @StateObject private var viewModel = MVVMBootCampViewMOdel()
    
    var body: some View {
        VStack {
            Button(viewModel.myData) {
                viewModel.onCallToActionButtonPressed()
            }
        }
        
        .onDisappear {
            
        }
    }
}

#Preview {
    MVVMBootCamp()
}
