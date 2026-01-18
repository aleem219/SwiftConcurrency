//
//  AsyncPublisherBootCamp.swift
//  SwiftConcurrency
//
//  Created by Abdul Aleem on 18/01/26.
//

import SwiftUI
import Combine

//actor AsyncPublisherDataManager {
class AsyncPublisherDataManager {
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Abdul Aleem")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Abdul Aleem")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Abdul Aleem")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Abdul Aleem")
    }
}


class AsyncPublisherBootCampViewModel: ObservableObject {
    @MainActor @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()

    var canceable = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    private func addSubscriber() {
        
        Task {
            for await value in manager.$myData.values {
                await MainActor.run {
                    self.dataArray = value
                }
            }
        }
        
//        Task {
//            for await value in manager.$myData.values {
//                await MainActor.run {
//                    self.dataArray = value
//                }
//                break
//            }
//        }
        
//        manager.$myData
//            .receive(on: DispatchQueue.main, options: nil)
//            .sink {  dataArray in
//                self.dataArray = dataArray
//            }
//            .store(in: &canceable)
    }
    
    func start() async {
        await  manager.addData()
    }
}

struct AsyncPublisherBootCamp: View {
    
    @StateObject private var viewModel = AsyncPublisherBootCampViewModel()
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
            await viewModel.start()
        }
    }
}

#Preview {
    AsyncPublisherBootCamp()
}
