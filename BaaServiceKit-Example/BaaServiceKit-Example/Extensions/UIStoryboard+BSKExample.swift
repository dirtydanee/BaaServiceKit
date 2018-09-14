import UIKit

enum UIStoryboardIdentifiers: String {
    case createRecordViewController
    case saveNodeHashViewController

    var stringValue: String {
        return self.rawValue.prefix(1).uppercased() + self.rawValue.dropFirst()

    }
}

extension UIStoryboard {

    static func instantiateViewController<ViewControllerType>(withIdentifier identifier: String, fromStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> ViewControllerType {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! ViewControllerType
    }
}
