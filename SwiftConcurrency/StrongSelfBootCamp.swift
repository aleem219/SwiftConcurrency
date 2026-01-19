//
//  StrongSelfBootCamp.swift
//  SwiftConcurrency
//
//  Created by Abdul Aleem on 19/01/26.
//

import SwiftUI


final class StrongSelfDataService {
    
    func getData() async -> String {
        "Updated Data"
    }
}

final class StrongSelfBootCampViewModel:ObservableObject {
    @Published var data:String = "Some title!"
    let dataService = StrongSelfDataService()
    
    private var someTask: Task<Void, Never>? = nil
    private var myTask: [Task<Void, Never>] = []
    
    func cancelTask() {
        someTask?.cancel()
        someTask  = nil
        
        myTask.forEach {$0.cancel()}
        myTask = []
    }
    
    
    // This implies a strong reference...
    func updateData() {
        Task {
            data = await dataService.getData()
        }
    }
    
    // This is a strong reference...
    func updateData2() {
        Task {
            self.data = await self.dataService.getData()
        }
    }
    
    // This is a strong reference...
    func updateData3() {
        Task { [self] in
            self.data = await self.dataService.getData()
        }
    }
    
    // This is a weak reference...
    func updateData4() {
        Task { [weak self] in
            if let data = await self?.dataService.getData() {
                self?.data = data
            }
        }
    }
    
    // We do not need to manage weak/strong...
    // We can manage the Task!...
    func updateData5() {
        someTask =  Task {
            self.data = await self.dataService.getData()
        }
    }
    
    // We can manage the Task!
    func updateData6() {
        let  task1 = Task {
            self.data = await self.dataService.getData()
        }
        
        myTask.append(task1)
        
        let  task2 = Task {
            self.data = await self.dataService.getData()
        }
        myTask.append(task2)
    }
    
    
    // We purposely  do not cancel task to keep strong refrences
    func updateData7() {
        Task {
            self.data = await self.dataService.getData()
        }
        
        Task.detached {
            self.data = await self.dataService.getData()
        }
    }
    
    func updateData8() async {
        self.data = await self.dataService.getData()
    }
}


struct StrongSelfBootCamp: View {
    
    @StateObject private var viewModel = StrongSelfBootCampViewModel()
    var body: some View {
        Text(viewModel.data)
            .onAppear {
                viewModel.updateData()
            }
            .onDisappear {
                viewModel.cancelTask()
            }
        
            .task {
                await viewModel.updateData8()
            }
    }
}

#Preview {
    StrongSelfBootCamp()
}
