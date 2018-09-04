import UIKit

final class CreateRecordViewController: UIViewController, ActivityDisplayer {

    enum SequeIdentifier: String {
        case showSaveNodeHash
        case showSelectNode
    }

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!

    @IBAction func didPressSubmit(_ sender: UIButton) {
        guard let identifier = self.idTextField.text,
            let description = self.descTextField.text,
            !identifier.isEmpty,
            !description.isEmpty else {
            return
        }

        let record = Record(identifier: identifier, description: description)
        self.status = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.status = .loaded
            self.performSegue(withIdentifier: SequeIdentifier.showSaveNodeHash.rawValue, sender: self)
        }
    }

    @IBAction func didPressSelectNode(_ sender: UIButton) {
        self.performSegue(withIdentifier: SequeIdentifier.showSelectNode.rawValue, sender: self)
    }
}
