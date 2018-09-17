import UIKit
import BaaServiceKit

final class NodeHashSummaryView: UIView {

    private var stackView: UIStackView!
    private var hashInfoView: InfoView!
    private var hashIdentifierInfoView: InfoView!
    private var urlsInfoView: InfoView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        let stackView = UIStackView(frame: bounds)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.pinToSuperview()

        self.hashInfoView = InfoView(frame: .zero)
        self.hashIdentifierInfoView = InfoView(frame: .zero)
        self.urlsInfoView = InfoView(frame: .zero)

        stackView.addArrangedSubview(hashInfoView)
        stackView.addArrangedSubview(hashIdentifierInfoView)
        stackView.addArrangedSubview(urlsInfoView)

        self.stackView = stackView
    }

    func setUp(with nodeHash: NodeHash) {
        self.hashInfoView.configure(with: ("hash".uppercased(), nodeHash.hashValue))
        self.hashIdentifierInfoView.configure(with: ("hash identifier".uppercased(), nodeHash.hashIdentifier))
        self.urlsInfoView.configure(with: ("submitted URL".uppercased(), nodeHash.urls[0].absoluteString))
    }
}
