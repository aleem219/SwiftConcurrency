//
//  AsyncStreamBootCamp.swift
//  SwiftConcurrency
//
//  Created by Abdul Aleem on 06/02/26.
//

import SwiftUI

class AsyncStreamDataManager {
    
    func getAsyncStream()  -> AsyncThrowingStream<Int,Error> {
        AsyncThrowingStream { [weak self] continuation in
            self?.getFakeData { value in
                continuation.yield(value)
            } onFinish: { error in
                continuation.finish(throwing: error)
            }
        }
    }
    
    func getFakeData(
        newValue: @escaping (_ value: Int) -> Void,
        onFinish: @escaping(_ error: Error?) -> Void
    ) {
        let items: [Int] = [1,2,3,4,5,6,7,8,9,10]
        for item in items {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(item), execute: {
                newValue(item)
                print("NEW DATA: \(item)")
                if item  == items.last {
                    onFinish(nil)
                }
            })
        }
    }
}

@MainActor
final class AsyncStreamBootCampViewModel:ObservableObject {
    
    let manager = AsyncStreamDataManager()
    @Published private(set) var currentNumber: Int = 0
    
    func onViewAppear() {
//        manager.getFakeDat { [weak self] value in
//            self?.currentNumber = value
//        }
      let task = Task {
            do {
                for try await value in manager.getAsyncStream() {
                    currentNumber = value
                }
            } catch {
                print(error)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5 , execute: {
            task.cancel()
            print("NEW CANCELED")
        })
    }
}

struct AsyncStreamBootCamp: View {
    @StateObject private var viewModel = AsyncStreamBootCampViewModel()
    var body: some View {
        Text("\(viewModel.currentNumber)")
            .onAppear {
                viewModel.onViewAppear()
            }
    }
}

#Preview {
    AsyncStreamBootCamp()
}
