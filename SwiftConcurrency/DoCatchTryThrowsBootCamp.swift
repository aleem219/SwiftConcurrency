//
//  DoCatchTryThrowsBootCamp.swift
//  SwiftConcurrency
//
//  Created by Abdul Aleem on 05/01/26.
//

import SwiftUI

class DoCatchTryThrowsBootCampDataManager {
    
    let isActive:Bool = true
    
    func getTitle() -> (title:String?, error: Error?) {
        if isActive {
            return ("New Text", nil)
        } else {
            return (nil,URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("New Text")
        } else {
            return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    
    func getTitle3() throws -> String {
//        if isActive {
//            return "New Text"
//        } else {
            throw URLError(.badServerResponse)
//        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "Final Text"
        } else {
            throw URLError(.badServerResponse)
        }
    }
}

class DoCatchTryThrowsBootCampViewModel: ObservableObject {
    @Published var text: String = "Starting text"
    let manager = DoCatchTryThrowsBootCampDataManager()
    
    func fetchTitle() {
        /*
         let returnedValue = manager.getTitle()
         
         if let newTitle = returnedValue.title {
         self.text = newTitle
         } else if let error = returnedValue.error {
         self.text = error.localizedDescription
         }
         */
        
        /*
        let result = manager.getTitle2()
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
         */
        
//        let newTitle = try? manager.getTitle3()
//        if let newTitle = newTitle {
//            self.text = newTitle
//        }
        
        
//        let newTitle = try! manager.getTitle3()
//        self.text = newTitle
        
       do {
            let newTitle = try? manager.getTitle3()
           if let newTitle = newTitle {
               self.text = newTitle
           }
           
           let finalTital = try manager.getTitle4()
           self.text = finalTital
        } catch { // let error
            self.text = error.localizedDescription
        }
    }
}

struct DoCatchTryThrowsBootCamp: View {
    @StateObject private var viewModel = DoCatchTryThrowsBootCampViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.green.opacity(0.5))
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

#Preview {
    DoCatchTryThrowsBootCamp()
}
