import UIKit
import BaaServiceKit

final class CreateRecordViewController: UIViewController, ActivityDisplayer {

    private enum SequeIdentifier: String {
        case showSaveNodeHash
    }

    private var latestNodeResults: [NodeHash] = []
    private var submittedRecord: Record!

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
        self.createNodeHash(from: record)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let saveVC = segue.destination as? SaveNodeHashViewController {
            saveVC.nodeHash = self.latestNodeResults[0]
            saveVC.record = self.submittedRecord
        }
    }
}

extension CreateRecordViewController {

    func createNodeHash(from record: Record) {
        do {
            // 1. Generate SHA-256
            let hash = try ServiceProvider.shared.blockchainService.generateSHA256(from: record)

            // 2. Submit hashes
            ServiceProvider.shared.blockchainService.submit(hashes: [hash], forNumberOfNodes: 1) {  [weak self] result in
                self?.status = .loaded
                switch result {
                case .success(let nodeResults):
                    self?.latestNodeResults = nodeResults
                    self?.submittedRecord = record
                    self?.performSegue(withIdentifier: SequeIdentifier.showSaveNodeHash.rawValue, sender: self)
                case .failure(let error):
                    self?.showAlert(for: error)
                }
            }
        } catch {
            self.showAlert(for: error)
        }
    }
}
