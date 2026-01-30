//
//  SaerchableBootCamp.swift
//  SwiftConcurrency
//
//  Created by Abdul Aleem on 30/01/26.
//

import SwiftUI
import Combine
struct Resturant :Identifiable, Hashable {
    let id: String
    let title: String
    let cuisine: CuisineOption
}


enum CuisineOption: String {
    case american, italian, japanese
}

final class ResturantManager {
    
    func getAllResturant() async throws -> [Resturant] {
        [
            Resturant(id: "1", title: "Burger Shack", cuisine: .american),
            Resturant(id: "2", title: "Pasta Palace", cuisine: .italian),
            Resturant(id: "3", title: "Sushi Heaven", cuisine: .japanese),
            Resturant(id: "4", title: "Local Market", cuisine: .american)
        ]
    }
    
}

@MainActor
final class SaerchableBootCampViewModel: ObservableObject {
    
    @Published private(set) var allResturnts: [Resturant] = []
    @Published private(set) var filteredResturnts: [Resturant] = []
    @Published var searchText: String = ""
    @Published var serachScope: SearchScopeOption = .all
    @Published private(set) var allSearchScope: [SearchScopeOption] = []
    
    let manager = ResturantManager()
    private var cancellable = Set<AnyCancellable>()
    
    var isSearching: Bool {
        !searchText.isEmpty
    }
    
    
    var showSearchSuggestions:Bool {
        searchText.count < 5
    }
    
    enum SearchScopeOption: Hashable {
        case all
        case cusine(option: CuisineOption)
        
        var title: String{
            switch self {
            case .all:
                return "All"
            case .cusine(option: let option):
                return option.rawValue.capitalized
            }
        }
    }
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        $searchText
            .combineLatest($serachScope)
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText, searchScope in
                self?.filterResturant(searchText: searchText, currentSearchScope: searchScope)
            }
            .store(in: &cancellable)
    }
    
    private func filterResturant(searchText: String, currentSearchScope: SearchScopeOption) {
        guard !searchText.isEmpty else {
             filteredResturnts = []
            serachScope = .all
            return
        }
        
        // Filter on search scope
        var resturantInScope = allResturnts
        switch currentSearchScope {
        case .all:
            break
        case .cusine(let option):
            resturantInScope = allResturnts.filter({$0.cuisine == option})
        }
        
        
        // Filter on search text
        let search = searchText.lowercased()
        filteredResturnts = resturantInScope.filter({ restaurants in
//        filteredResturnts = allResturnts.filter({ restaurants in
            let titleContainesSearch = restaurants.title.lowercased().contains(search)
            let cusineContainsSearch = restaurants.cuisine.rawValue.lowercased().contains(search)
            return titleContainesSearch || cusineContainsSearch
        })
    }
    
    func loadRestaurant() async {
        do {
            allResturnts = try await manager.getAllResturant()
            
            let allCusine = Set(allResturnts.map {$0.cuisine})
            allSearchScope = [.all] + allCusine.map({SearchScopeOption.cusine(option: $0)})
        } catch  {
            print(error)
        }
    }
    
    func getSearchSuggestions() -> [String] {
        
        guard showSearchSuggestions else {
           return []
        }
        
        
        var suggestions: [String] = []
        let search = searchText.lowercased()
        if search.contains("pa") {
            suggestions.append("Pasta")
        }
        if search.contains("su") {
            suggestions.append("Sushi")
        }
        if search.contains("bu") {
            suggestions.append("Burger")
        }
        suggestions.append("Market")
        suggestions.append("Grocery")
        suggestions.append(CuisineOption.italian.rawValue.capitalized)
        suggestions.append(CuisineOption.japanese.rawValue.capitalized)
        suggestions.append(CuisineOption.american.rawValue.capitalized)
        return suggestions
    }
    
    func getRestaurantSuggetions() -> [Resturant] {
        guard showSearchSuggestions else {
           return []
        }
        
        
        var suggestions: [Resturant] = []
        let search = searchText.lowercased()
        if search.contains("ita") {
            suggestions.append(contentsOf: allResturnts.filter({$0.cuisine == .italian}))
        }
        if search.contains("jap") {
            suggestions.append(contentsOf: allResturnts.filter({$0.cuisine == .japanese}))
        }
        return suggestions
    }
}

struct SaerchableBootCamp: View {
    @StateObject private var viewNOdel = SaerchableBootCampViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(viewNOdel.isSearching ? viewNOdel.filteredResturnts : viewNOdel.allResturnts) { restaurants in
                    NavigationLink(value: restaurants) {
                        restaurantRow(restaurant: restaurants)
                    }
                }
            }
            .padding()
        }
        .searchable(text: $viewNOdel.searchText,placement:  .automatic,prompt: Text("Search Restaurants..."))
        .searchScopes($viewNOdel.serachScope, scopes: {
            ForEach(viewNOdel.allSearchScope, id: \.self) { scope in
                Text(scope.title)
                    .tag(scope)
            }
        })
        .searchSuggestions({
            ForEach(viewNOdel.getSearchSuggestions(), id: \.self) { suggestion in
                Text(suggestion)
                    .searchCompletion(suggestion)
            }
            ForEach(viewNOdel.getRestaurantSuggetions(), id: \.self) { suggestion in
                NavigationLink(value: suggestion) {
                    Text(suggestion.title)
                }
            }
        })
        .navigationTitle("Restaurants")
        .task {
            await viewNOdel.loadRestaurant()
        }
        .navigationDestination(for: Resturant.self) { restaurant in
            Text(restaurant.title.uppercased())
        }
    }
    
    private func restaurantRow(restaurant: Resturant) -> some View {
        VStack(alignment: .leading,spacing: 10) {
            Text(restaurant.title)
                .font(.headline)
                .foregroundColor(Color.red)
            Text(restaurant.cuisine.rawValue.capitalized)
                .font(.caption)
        }
        .padding()
        .frame(maxWidth: .infinity,alignment: .leading)
        .background(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)).opacity(0.5))
        .tint(.primary)
    }
}


struct SearchChildView: View {
    @Environment(\.isSearching) private var isSearching
    var body: some View {
        Text("Child View is searching: \(isSearching.description)")
    }
}

#Preview {
    NavigationStack {
        SaerchableBootCamp()
    }
}
