import UIKit

extension UIView {

    func pinToSuperview() {
        guard let superview = self.superview else {
            fatalError("Superview is not available!")
        }

        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }

}
