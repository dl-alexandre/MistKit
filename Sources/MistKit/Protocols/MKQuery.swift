public struct MKQuery<RecordType: MKQueryRecord>: MKQueryProtocol {
  public enum CodingKeys: String, CodingKey {
    case recordType
  }

  public let recordType: String
  public let desiredKeys: [String]?
  public init(recordType: RecordType.Type) {
    self.recordType = recordType.recordType
    desiredKeys = recordType.desiredKeys
  }
}
