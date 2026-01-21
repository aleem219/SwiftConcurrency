//
//  RefreshableBootCamp.swift
//  SwiftConcurrency
//
//  Created by Abdul Aleem on 21/01/26.
//

import SwiftUI

class RefreshableDataService {
    
    func getData() async throws -> [String] {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
       return ["Abdul","Aleem","Usmani"].shuffled()
    }
}


@MainActor
final class RefreshableBootCampViewModel: ObservableObject {
    @Published private(set) var item: [String] = []
    let manager = RefreshableDataService()
    
    func loadData() async{
//        Task {
            do {
                item = try await manager.getData()
            } catch  {
                print(error)
            }
//        }
    }
}

struct RefreshableBootCamp: View {
    @StateObject private var viewModel = RefreshableBootCampViewModel ()
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.item, id: \.self) { item  in
                        Text(item)
                            .font(.headline)
                    }
                }
            }
            .refreshable {
               await viewModel.loadData()
            }
            .navigationTitle("Refreshable")
            .task {
               await viewModel.loadData()
            }
        }
    }
}

#Preview {
    RefreshableBootCamp()
}
