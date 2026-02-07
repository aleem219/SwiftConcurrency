//
//  ObservalBootcampSwiftCocurrency.swift
//  SwiftConcurrency
//
//  Created by Abdul Aleem on 07/02/26.
//

import SwiftUI

actor TitleataBase {
    func getNewTitle() -> String {
        return "Some new title!!"
    }
}


@Observable class ObservalBootcampSwiftCocurrencyViewModel {
    
    @ObservationIgnored  let database = TitleataBase()
    @MainActor var title:String = "Some title"
    
    //    @MainActor
    //    func updatTitle() async {
    //        title = await database.getNewTitle()
    //        print(Thread.current)
    //    }
    
    
//    func updatTitle() async {
//        let  title = await database.getNewTitle()
//        await MainActor.run {
//            self.title = title
//            print(Thread.current)
//        }
//    }
    
    func updatTitle() {
        Task { @MainActor in
            title = await database.getNewTitle()
            print(Thread.current)
        }
    }
}

struct ObservalBootcampSwiftCocurrency: View {
    @State private var viewModel = ObservalBootcampSwiftCocurrencyViewModel()
    var body: some View {
        Text(viewModel.title)
//            .task {
//                await viewModel.updatTitle()
//            }
            .onAppear {
                viewModel.updatTitle()
            }
    }
}

#Preview {
    ObservalBootcampSwiftCocurrency()
}
