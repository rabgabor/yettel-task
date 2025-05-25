@testable import Yettel
import Foundation

extension Data {

    /// Success response for `GET /v1/highway/info`
    static let highwayInfo: Data = """
    {
      "requestId": 12345678,
      "statusCode": "OK",
      "payload": {
        "highwayVignettes": [
          {
            "vignetteType": ["DAY","WEEK","MONTH","YEAR"],
            "vehicleCategory": "CAR",
            "cost": 5150.0,
            "trxFee": 200.0,
            "sum": 5350.0
          }
        ],
        "vehicleCategories": [
          {
            "category": "CAR",
            "vignetteCategory": "D1",
            "name": { "hu": "Személygépjármű", "en": "Car" }
          },
          {
            "category": "MOTORCYCLE",
            "vignetteCategory": "D1M",
            "name": { "hu": "Motorkerékpár", "en": "Motorcycle" }
          },
          {
            "category": "TRUCK",
            "vignetteCategory": "D2",
            "name": { "hu": "Tehergépkocsi", "en": "Truck" }
          }
        ],
        "counties": [
          { "id": "YEAR_11", "name": "Bács-Kiskun" },
          { "id": "YEAR_12", "name": "Baranya"     },
          { "id": "YEAR_13", "name": "Békés"       }
        ]
      }
    }
    """.data(using: .utf8)!

    /// Success response for `GET /v1/highway/vehicle`
    static let vehicleInfo: Data = """
    {
      "statusCode": "OK",
      "internationalRegistrationCode": "H",
      "type": "CAR",
      "name": "Michael Scott",
      "plate": "abc-123",
      "country": { "hu": "Magyarország", "en": "Hungary" },
      "vignetteType": "D1"
    }
    """.data(using: .utf8)!

    /// Success echo for `POST /v1/highway/order`
    static let orderAccepted: Data = """
    {
      "statusCode": "OK",
      "receivedOrders": [
        { "type": "DAY",  "category": "CAR", "cost": 5000 },
        { "type": "WEEK", "category": "CAR", "cost":  900 }
      ]
    }
    """.data(using: .utf8)!

    /// Generic error payload (used in the 500-status test)
    static let errorPayload: Data = """
    {
      "statusCode": "ERROR",
      "message": "Something went wrong"
    }
    """.data(using: .utf8)!
}
