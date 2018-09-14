import UIKit
import BaaServiceKit

final class SaveNodeHashViewController: UIViewController {
    var nodeHash: NodeHash!
    var record: Record!

    @IBOutlet weak var summaryView: SummaryView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.summaryView.setup(with: record, and: nodeHash)
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



