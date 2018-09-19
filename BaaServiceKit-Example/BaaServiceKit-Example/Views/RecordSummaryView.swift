import UIKit

final class RecordSummaryView: UIView {

    private var stackView: UIStackView!
    private var identifierInfoView: InfoView!
    private var descriptionInfoView: InfoView!

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
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.pinToSuperview()

        self.identifierInfoView = InfoView(frame: .zero)
        self.descriptionInfoView = InfoView(frame: .zero)

        stackView.addArrangedSubview(identifierInfoView)
        stackView.addArrangedSubview(descriptionInfoView)
        self.stackView = stackView
    }

    func setUp(with record: Record) {
        self.identifierInfoView.configure(with: ("identifier".uppercased(), record.identifier))
        self.descriptionInfoView.configure(with: ("description".uppercased(), record.description))
    }
}
