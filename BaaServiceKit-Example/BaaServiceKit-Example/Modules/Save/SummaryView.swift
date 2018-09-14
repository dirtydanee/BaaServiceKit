import UIKit
import BaaServiceKit

final class SummaryView: UIView {

    @IBOutlet weak var identifierValue: UILabel!
    @IBOutlet weak var descriptionValue: UILabel!
    @IBOutlet weak var dataHashValue: UILabel!
    @IBOutlet weak var hashIdentifierValue: UILabel!
    @IBOutlet weak var submittedURLValue: UILabel!

    func setup(with record: Record, and nodeHash: NodeHash) {
        self.identifierValue.text = record.identifier
        self.descriptionValue.text = record.description
        self.dataHashValue.text = nodeHash.hashValue
        self.hashIdentifierValue.text = nodeHash.hashIdentifier
        self.submittedURLValue.text = nodeHash.urls[0].absoluteString
    }
}
