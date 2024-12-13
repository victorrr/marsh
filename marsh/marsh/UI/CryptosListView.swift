import SwiftUI

struct CryptosListView: View {
    @ObservedObject var viewModel: CryptosListViewModel

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
            HStack {
                Spacer()
                dropdownView
            }
            .padding()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// MARK: - Subviews

private extension CryptosListView {

    var dropdownView: some View {
        CurrencyDropdownView(selectedOption: $viewModel.selectedCurrency)
    }

    var emptyView: some View {
        VStack {
            Spacer()
            Text("empty_view")
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
                    CryptoView(name: item.name, value: item.price, currency: viewModel.selectedCurrency)
                }
                Spacer()
            }
            .padding(.top, Constant.topScrollInset)
        }
    }
}

// MARK: - Constant

private extension CryptosListView {

    struct Constant {
        static let topScrollInset: CGFloat = 60,
                   searchPadding: CGFloat = 6
    }
}

// MARK: - Preview

private var previewNetworkService: MockNetworkService {
    let networkService = MockNetworkService()
    let items = [CryptoItem(name: "btc", price: 100)]
    networkService.mockResult = items
    return networkService
}

private var previewVM: CryptosListViewModel {
    let apiService = ApiService(networkService: previewNetworkService)
    let viewModel = CryptosListViewModel(apiService: apiService)
    return viewModel
}

#Preview {
    CryptosListView(viewModel: previewVM)
}
