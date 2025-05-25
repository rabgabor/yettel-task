struct VehicleInfoResponse: Codable {
    let statusCode: StatusCode
    let internationalRegistrationCode: String
    let type: VehicleCategory
    let name: String
    let plate: String
    let country: LocalizedString
    let vignetteType: VignetteCategory
}
