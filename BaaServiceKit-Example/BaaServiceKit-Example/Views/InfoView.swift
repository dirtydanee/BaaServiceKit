import UIKit

final class InfoView: UIView {

    typealias PresentableInfo = (title: String, description: String)

    private var stackView: UIStackView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override var intrinsicContentSize: CGSize {
        titleLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        return CGSize(width: bounds.width, height: titleLabel.frame.height + stackView.spacing + descriptionLabel.frame.height)
    }

    private func commonInit() {
        let stackView = UIStackView(frame: bounds)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.pinToSuperview()

        let titleLabel = UILabel()
        let descriptionLabel = UILabel()

        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)

        [titleLabel, descriptionLabel].forEach {
            $0.numberOfLines = 0
            stackView.addArrangedSubview($0)
        }

        self.titleLabel = titleLabel
        self.descriptionLabel = descriptionLabel
        self.stackView = stackView


    }

    func configure(with info: PresentableInfo) {
        titleLabel.text = info.title
        descriptionLabel.text = info.description
    }
}
