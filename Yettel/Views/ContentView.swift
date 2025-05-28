import SwiftUI

struct ContentView: View {
    @State private var viewModel = VehicleViewModel()

    var body: some View {
        NavigationStack {
            List {
                if let vehicleSummary = viewModel.vehicleSummary {
                    Section { VehicleSummaryRow(vehicleSummary: vehicleSummary) }
                }
                
                if !viewModel.nationalVignetteOptions.isEmpty {
                    Section(header: Text("Országos matricák")) {
                        ForEach(viewModel.nationalVignetteOptions, id: \.id) { vignette in
                            VignetteSelectRow(nationalVignetteOption: vignette, isSelected: viewModel.currentlySelectedNationalVignetteOptionID == vignette.id)
                                .onTapGesture {
                                    viewModel.currentlySelectedNationalVignetteOptionID = vignette.id
                                }
                        }
                        
                        if viewModel.currentlySelectedNationalVignetteOptionID != nil {
                            NavigationLink("Tovább a vásárláshoz") {
                                PurchaseView(viewModel: PurchaseViewModel(plate: viewModel.vehicleSummary?.plate ?? "",
                                                                          vignetteTypeText: "Országos",
                                                                          selectedVignettes: [viewModel.currentlySelectedNationalVignetteOption!])
                                )
                            }
                        }
                    }
                }
                
                if !viewModel.countyVignetteOptions.isEmpty {
                    Section {
                        NavigationLink("Éves vármegyei matricák") {
                            CountySelectionView(viewModel: CountySelectionViewModel(options: viewModel.countyVignetteOptions,
                                                                                    plate: viewModel.vehicleSummary?.plate ?? ""))
                        }
                    }
                }
                
                if let err = viewModel.errorMessage {
                    Section { Text("Hiba: \(err)").foregroundStyle(.red) }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("E-matrica")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.initialLoad()
            }
            .refreshable {
                await viewModel.load()
            }
            .overlay {
                if viewModel.initialFetch {
                    ZStack {
                        Color(.systemBackground).opacity(0.6)
                        ProgressView().scaleEffect(1.4)
                    }
                    .ignoresSafeArea()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(VehicleViewModel(api: MockHighwayService()))
}
