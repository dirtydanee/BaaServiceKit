import UIKit
import BaaServiceKit

final class SaveNodeHashViewController: UIViewController {
    var nodeHash: NodeHash!
    var record: Record!

    @IBOutlet private weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStackView()
    }

    func setUpStackView() {
        let recordSummary = RecordSummaryView(frame: .zero)
        recordSummary.setUp(with: record)
        let nodeHashSummary = NodeHashSummaryView(frame: .zero)
        nodeHashSummary.setUp(with: nodeHash)
        stackView.addArrangedSubview(recordSummary)
        stackView.addArrangedSubview(nodeHashSummary)
    }

    @IBAction func didPressSaveButton(_ sender: UIButton) {
        do {
            try ServiceProvider.shared.blockchainService.save(nodeHash: nodeHash)
            self.showAlert(title: "Successful save!")
        } catch {
            self.showAlert(for: error)
        }
    }
}



