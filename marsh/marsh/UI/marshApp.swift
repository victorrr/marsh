import SwiftUI

@main
struct marshApp: App {
    var body: some Scene {
        WindowGroup {
            MListView(viewModel: viewModel)
        }
    }

    private var viewModel: MListViewModel {
        let networkService = NetworkService()
        let apiService = ApiService(networkService: networkService)
        return MListViewModel(apiService: apiService)
    }
}
