import XCTest
@testable import IndieBuilderKit

final class UserDefaultsWrapperTests: XCTestCase {
    func testUserDefaultStoresAndReads() {
        let defaults = UserDefaults(suiteName: "IndieBuilderKitTests.UserDefaults")!
        defaults.removePersistentDomain(forName: "IndieBuilderKitTests.UserDefaults")

        struct TestStore {
            @UserDefault(key: "flag", defaultValue: false, userDefaults: UserDefaults(suiteName: "IndieBuilderKitTests.UserDefaults")!)
            static var flag: Bool
        }

        XCTAssertEqual(TestStore.flag, false)
        TestStore.flag = true
        XCTAssertEqual(TestStore.flag, true)
    }

    func testCodableUserDefaultRoundTrip() throws {
        let defaults = UserDefaults(suiteName: "IndieBuilderKitTests.CodableUserDefaults")!
        defaults.removePersistentDomain(forName: "IndieBuilderKitTests.CodableUserDefaults")

        struct Model: Codable, Equatable {
            let id: Int
            let name: String
        }

        struct TestStore {
            @CodableUserDefault(key: "model", defaultValue: nil, userDefaults: UserDefaults(suiteName: "IndieBuilderKitTests.CodableUserDefaults")!)
            static var model: Model?
        }

        XCTAssertNil(TestStore.model)
        TestStore.model = Model(id: 1, name: "A")
        XCTAssertEqual(TestStore.model, Model(id: 1, name: "A"))
    }
}
