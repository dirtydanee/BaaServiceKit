import UIKit
import BaaServiceKit

class GetProofViewController: UIViewController {
    var nodeHash: NodeHash!
    
    private var proof: Proof? {
        didSet {
            
        }
    }
    
    @IBOutlet private weak var stackView: UIStackView!
    
    private enum SequeIdentifier: String {
        case showProof
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        proof(for: nodeHash)
    }
    
    private func proof(for nodeHash: NodeHash) {
        ServiceProvider.shared.blockchainService.proof(for: [nodeHash]) { [weak self] results in
            switch results.first! {
            case .success(let proof):
                self?.proof = proof
            case .failure(let error):
                self?.showAlert(for: error)
            }
        }
    }
    
    @IBAction func didPressSaveProof(_ sender: UIButton) {
        guard let proof = proof else { return }
        do {
            try ServiceProvider.shared.blockchainService.save(proof: proof)
        } catch {
            showAlert(for: error)
        }
    }
}
