import SwiftUI

struct MListView: View {
    @ObservedObject var viewModel: MListViewModel

    var body: some View {
        ZStack(alignment: .top) {
            switch viewModel.viewState {
            case .empty:
                emptyView
            case .images(let images):
                resultScrollView(images)
            case .loading:
                loadingView
            case .error(let error):
                errorView(desciption: (error as? NetworkError)?.localizedDescription)
            }
            searchTextField
        }
    }
}

// MARK: - Subviews

private extension MListView {

    var searchTextField: some View {
        TextField(LocalizedStringKey("search".localized),
                  text: $viewModel.searchTerm,
                  axis: .horizontal)
        .font(Font.title2)
        .padding(Constant.searchPadding)
        .background(Color.gray)
        .cornerRadius(Constant.searchRadius)
        .padding()
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

    func resultScrollView(_ images: [ImageItem]) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(images, id: \.self) { item in
                    MItemView(imageUrl: viewModel.imageUrl(imageItem: item),
                                  name: item.title)
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
                   searchRadius: CGFloat = 4,
                   searchPadding: CGFloat = 6
    }
}

// MARK: - Preview

private var previewNetworkService: MockNetworkService {
    let networkService = MockNetworkService()
    let expectedImageItem = ImageItem(id: "54186654298",
                                      server: "65535",
                                      secret: "8bdfbb9652",
                                      title: "Title for image")
    let photos = PhotosResponse(
        photos: Photos(
            photo: [expectedImageItem]
        )
    )
    networkService.mockResult = photos
    return networkService
}

private var previewVM: MListViewModel {
    let apiService = ApiService(networkService: previewNetworkService)
    let viewModel = MListViewModel(apiService: apiService)
    viewModel.searchTerm = "cats"
    return viewModel
}

#Preview {
    MListView(viewModel: previewVM)
}
