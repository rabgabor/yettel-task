import SwiftUI

struct CountySelectionView: View {
    @StateObject var viewModel: CountySelectionViewModel

    var body: some View {
        List {
            mapSection
            countyRowsSection
            if viewModel.hasIsolatedSelection { warningSection }
            totalSection
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Éves vármegyei")
        .navigationBarTitleDisplayMode(.large)
    }
}

private extension CountySelectionView {

    private var mapSection: some View {
        Section {
            HStack {
                Spacer()
                ZStack {
                    ForEach(viewModel.options, id: \.id) { option in
                        Image(option.id)
                            .renderingMode(.template)
                            .foregroundColor(viewModel.isSelected(option.id) ? .accentColor : .secondary)
                            .allowsHitTesting(false)
                    }
                    
                    Image("BP")
                        .renderingMode(.template)
                        .foregroundColor(.secondary)
                        .allowsHitTesting(false)
                }
                .aspectRatio(1, contentMode: .fit)
                .padding(.vertical, 8)
                
                Spacer()
            }
        }
    }

    private var countyRowsSection: some View {
        Section {
            ForEach(viewModel.options) { option in
                CountyRow(option: option, isSelected: viewModel.isSelected(option.id)) {
                    viewModel.toggle(option.id)
                }
            }
        }
    }

    private var warningSection: some View {
        Section {
            Label("A kijelölt vármegyék nem szomszédosak!",
                  systemImage: "exclamationmark.triangle.fill")
            .foregroundStyle(.orange)
                .font(.footnote)
        }
    }

    private var totalSection: some View {
        Section {
            HStack {
                Text("Fizetendő összeg")
                Spacer()
                Text(viewModel.totalPriceText).bold()
            }
            NavigationLink("Tovább a vásárláshoz") {
                PurchaseView(
                    viewModel: PurchaseViewModel(plate: viewModel.plate,
                                                 vignetteTypeText: "Éves vármegyei",
                                                 selectedVignettes: viewModel.selectedIDs
                        .compactMap { id in
                            viewModel.options.first { $0.id == id }
                        })
                )
            }
            .disabled(viewModel.selectedIDs.isEmpty)
            .opacity(viewModel.selectedIDs.isEmpty ? 0.4 : 1)
        }
    }
}

#if DEBUG
private let sampleCountyOptions: [CountyVignetteOption] = [
    CountyVignetteOption(id: "YEAR_11", countyName: "Bács-Kiskun", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_12", countyName: "Baranya", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_13", countyName: "Békés", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_14", countyName: "Borsod-Abaúj-Zemplén", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_15", countyName: "Csongrád", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_16", countyName: "Fejér", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_17", countyName: "Győr-Moson-Sopron", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_18", countyName: "Hajdú-Bihar", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_19", countyName: "Heves", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_20", countyName: "Jász-Nagykun-Szolnok", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_21", countyName: "Komárom-Esztergom", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_22", countyName: "Nógrád", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_23", countyName: "Pest", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_24", countyName: "Somogy", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_25", countyName: "Szabolcs-Szatmár-Bereg", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_26", countyName: "Tolna", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_27", countyName: "Vas", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_28", countyName: "Veszprém", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
    CountyVignetteOption(id: "YEAR_29", countyName: "Zala", sum: 9000.0, trxFee: 0.0, vehicleCategory: "CAR"),
]

struct CountySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CountySelectionView(viewModel: CountySelectionViewModel(options: sampleCountyOptions, plate: "ABC-123"))
        }
    }
}
#endif
