func priceString(_ value: Double) -> String {
    Int(value).formatted(.currency(code: "HUF"))
        .replacingOccurrences(of: ",00", with: "")
        .replacingOccurrences(of: ".00", with: "")
        .replacingOccurrences(of: "HUF", with: "Ft")
}
