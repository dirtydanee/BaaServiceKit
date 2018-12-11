import UIKit
import BaaServiceKit

final class ListCell: UITableViewCell, Resuable {

    private var summaryView: NodeHashSummaryView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        summaryView = NodeHashSummaryView(frame: .zero)
        contentView.addSubview(summaryView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        summaryView.frame = bounds
    }
    
    func configure(with nodeHash: NodeHash) {
        summaryView.setUp(with: nodeHash)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let summaryViewSize = summaryView.systemLayoutSizeFitting(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        return summaryViewSize
    }
}
