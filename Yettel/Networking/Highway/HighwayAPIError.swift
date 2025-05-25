public enum HighwayAPIError: Error {
    case invalidStatus(Int)
    case decoding(Error)
}
