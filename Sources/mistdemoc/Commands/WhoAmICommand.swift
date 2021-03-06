import ArgumentParser
import Foundation
import MistKit
import MistKitDemo
import MistKitNIO

public extension MistDemoCommand {
  struct WhoAmICommand: ParsableAsyncCommand {
    public static var configuration = CommandConfiguration(commandName: "whoami")

    @OptionGroup public private(set) var options: MistDemoArguments

    public func runAsync(_ completed: @escaping (Error?) -> Void) {
      // setup how to manager your user's web authentication token
      let manager = MKTokenManager(
        storage: MKUserDefaultsStorage(),
        client: MKNIOHTTP1TokenClient(bindTo: MistDemoCommand.defaultBinding)
      )

      // setup your database manager
      let database = MKDatabase(options: options, tokenManager: manager)

      database.perform(request: GetCurrentUserIdentityRequest()) { result in
        do {
          try print(result.get().information)
        } catch {
          completed(error)
          return
        }
        completed(nil)
      }
    }

    public init() {}
  }
}

public extension UserIdentityResponse {
  var information: String {
    """
    userRecordName: \(userRecordName.uuid)
      emailAddress: \(lookupInfo?.emailAddress ?? "(empty)")
      phoneNumber: \(lookupInfo?.phoneNumber ?? "(empty)")
      namePrefix: \(nameComponents?.namePrefix ?? "(empty)")
      givenName: \(nameComponents?.givenName ?? "(empty)")
      familyName: \(nameComponents?.familyName ?? "(empty)")
      nickname: \(nameComponents?.nickname ?? "(empty)")
      nameSuffix: \(nameComponents?.nameSuffix ?? "(empty)")
      middleName: \(nameComponents?.middleName ?? "(empty)")
      phoneticRepresentation: \(
        nameComponents?.phoneticRepresentation ?? "(empty)"
      )
    """
  }
}
