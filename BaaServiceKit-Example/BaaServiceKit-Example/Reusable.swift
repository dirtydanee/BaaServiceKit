import UIKit

protocol Resuable {
    static var reuseIdentifier: String { get }
}

extension Resuable where Self: UITableViewCell {

    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }

}
