import SwiftUI

struct MListView: View {
    @ObservedObject var viewModel: MListViewModel

    var body: some View {
        ZStack(alignment: .top) {
            switch viewModel.viewState {
            case .empty:
                emptyView
            case .cryptos(let cryptos):
                resultScrollView(cryptos)
            case .loading:
                loadingView
            case .error(let error):
                errorView(desciption: (error as? NetworkError)?.localizedDescription)
            }
            HStack(spacing: 10) {
                Spacer()
                dropdownView
            }
            .padding()
        }
    }
}

// MARK: - Subviews

private extension MListView {

    var dropdownView: some View {
        CurrencyDropdownView(selectedOption: $viewModel.currency)
    }

    var emptyView: some View {
        VStack {
            Spacer()
            Text("empty_search")
                .font(.title)
                .padding()
                .multilineTextAlignment(.center)
            Spacer()
        }
    }

    var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }

    func errorView(desciption: String?) -> some View {
        VStack {
            Spacer()
            Text("something_wrong")
                .font(.title)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
            Text(desciption ?? "unknown_error")
                .font(.title3)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }

    func resultScrollView(_ items: [CryptoItem]) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(items, id: \.self) { item in
                    MItemView(name: item.baseAsset, value: item.openPrice, currency: item.quoteAsset)
                    Divider()
                }
                Spacer()
            }
            .padding(.top, Constant.topScrollInset)
        }
    }
}

// MARK: - Constant

private extension MListView {

    struct Constant {
        static let topScrollInset: CGFloat = 60,
                   searchPadding: CGFloat = 6
    }
}

// MARK: - Preview

private var previewNetworkService: MockNetworkService {
    let networkService = MockNetworkService()
    let items = [CryptoItem(symbol: "",
                            baseAsset: "",
                            quoteAsset: "",
                            openPrice: "",
                            lowPrice: "",
                            highPrice: "",
                            lastPrice: "",
                            volume: "",
                            bidPrice: "",
                            askPrice: "",
                            at: 1)]
    networkService.mockResult = items
    return networkService
}

private var previewVM: MListViewModel {
    let apiService = ApiService(networkService: previewNetworkService)
    let viewModel = MListViewModel(apiService: apiService)
    return viewModel
}

#Preview {
    MListView(viewModel: previewVM)
}
