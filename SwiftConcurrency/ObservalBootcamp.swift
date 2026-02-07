//
//  ObservalBootcamp.swift
//  SwiftConcurrency
//
//  Created by Abdul Aleem on 07/02/26.
//

import SwiftUI

@Observable class ObservalViewModel {
    
   var title: String = "Some title"
//   @ObservationIgnored var value: String = "Some title"
}

struct ObservalBootcamp: View {
    @State private var viewModel = ObservalViewModel()
    var body: some View {
        VStack(spacing: 40) {
            Button(viewModel.title) {
                viewModel.title = "new title!"
            }
            
            SomeChildView(viewModel: viewModel)
            
            SomeThirdView()
        }
        .environment(viewModel)
    }
}

struct SomeChildView: View {
    @Bindable var viewModel: ObservalViewModel
    var body: some View {
        Button(viewModel.title) {
            viewModel.title = "kjbhiyegvjhbjhgvjghvyfrdyfgvbkjn"
        }
    }
}

struct SomeThirdView: View {
    @Environment(ObservalViewModel.self )  var viewModel
    var body: some View {
        Button(viewModel.title) {
            viewModel.title = "Third View!!!!!!!! "
        }
    }
}

#Preview {
    ObservalBootcamp()
}
