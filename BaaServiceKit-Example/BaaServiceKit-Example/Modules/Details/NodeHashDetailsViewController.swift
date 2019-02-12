import UIKit
import BaaServiceKit

class NodeHashDetailsViewController: UIViewController {
    var nodeHash: NodeHash!
    @IBOutlet private weak var stackView: UIStackView!
    
    private enum SequeIdentifier: String {
        case showGetProofs
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStackView()
    }
    
    func setUpStackView() {
        let nodeHashSummary = NodeHashSummaryView(frame: .zero)
        nodeHashSummary.setUp(with: nodeHash)
        stackView.addArrangedSubview(nodeHashSummary)
    }
    
    @IBAction func didPressGetProof(_ sender: UIButton) {
        performSegue(withIdentifier: SequeIdentifier.showGetProofs.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SequeIdentifier.showGetProofs.rawValue,
            let targetVC = segue.destination as? GetProofViewController {
            targetVC.nodeHash = nodeHash
        }
    }
}
