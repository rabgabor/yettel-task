import SwiftUI

struct PurchaseView: View {
    @State var viewModel: PurchaseViewModel

    var body: some View {
        List {
            headerSection
            itemsSection
            totalSection
            buttonSection
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Összegzés")
        .navigationBarTitleDisplayMode(.large)
        .alert("Hiba", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .fullScreenCover(isPresented: $viewModel.showSuccess) {
            SuccessView {
                viewModel.showSuccess = false
            }
        }
    }

    private var headerSection: some View {
        Section {
            HStack {
                Text("Rendszám")
                Spacer()
                Text(viewModel.plateText)
            }
            
            HStack {
                Text("Matrica típusa")
                Spacer()
                Text(viewModel.typeText)
            }
        }
    }
    
    private var itemsSection: some View {
        Section {
            ForEach(viewModel.rows) { row in
                HStack { Text(row.title); Spacer(); Text(row.price) }
            }
        }
    }
    
    private var totalSection: some View {
        Section {
            HStack {
                Text("Fizetendő összeg")
                Spacer()
                Text(viewModel.totalPayableText).bold()
            }
        }
    }
    
    private var buttonSection: some View {
        Section {
            Button(action: {
                Task {
                    await viewModel.purchase()
                }
            }) {
                Text("Vásárlás")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isBusy)
            
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        
        .headerProminence(.increased)
    }
}

#if DEBUG
private let sampleNational = NationalVignetteOption(id: "CAR-WEEK",
                                                    code: "D1",
                                                    duration: "Heti (10 napos)",
                                                    sum: 6_400,
                                                    trxFee: 200,
                                                    vehicleCategory: "CAR",
                                                    vignetteType: "Month"
)

struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PurchaseView(viewModel: PurchaseViewModel(plate: "ABC-123",
                                                      vignetteTypeText: "Országos",
                                                      selectedVignettes: [sampleNational])
            )
        }
    }
}
#endif
