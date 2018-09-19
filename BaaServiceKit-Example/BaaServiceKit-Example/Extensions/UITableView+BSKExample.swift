import UIKit

extension UITableView {
    func dequeueReusableCell<T>(withIdentifier identifier: String) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? T else {
            fatalError("Unable to deque cell with identifier: \(identifier)")
        }

        return cell
    }
}
