import Foundation
import BaaServiceKit

final class ServiceProvider {
    static let shared = ServiceProvider()

    let blockchainService = try! BaaService()
}
