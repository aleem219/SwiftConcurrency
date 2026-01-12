//
//  CheckContinuationBootcamp.swift
//  SwiftConcurrency
//
//  Created by Abdul Aleem on 12/01/26.
//

import SwiftUI

class CheckContinuationBootcampNetworkManager {
    
   func getData(url: URL) async throws -> Data {
       do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
           return data
       } catch  {
           throw error
       }
    }
    
    func getData2 (url: URL) async throws -> Data {
      return try await withCheckedThrowingContinuation { continuation in
          URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  continuation.resume(returning:  data)
              } else if let error = error {
                  continuation.resume(throwing: error)
              } else {
                  continuation.resume(throwing: URLError(.badURL))
              }
          }.resume()
        }
    }
    
    func getHeartImageFromDatabase(compilationHandler: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            compilationHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    func getHeartImageFromDatabase() async -> UIImage  {
     return await  withCheckedContinuation { continuation in
            getHeartImageFromDatabase() { image in
                continuation.resume(returning:  image)
            }
        }
    }
    

}

class CheckContinuationBootcampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let networkManager = CheckContinuationBootcampNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/200") else { return }
        
        do {
           let data = try await networkManager.getData2(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        } catch  {
           print(error)
        }
    }
    
    func getHeartImage()  async {
//        networkManager.getHeartImageFromDatabase { [weak self] image in
//            self?.image = image
//        }
        
        self.image = await networkManager.getHeartImageFromDatabase()
    }
}

struct CheckContinuationBootcamp: View {
    
    @StateObject private var viewModel = CheckContinuationBootcampViewModel()
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250,height: 250)
                    .cornerRadius(12)
            }
        }.task {
//            await viewModel.getImage()
            await viewModel.getHeartImage()
        }
    }
}

#Preview {
    CheckContinuationBootcamp()
}
