import UIKit

enum ActivityStatus {
    case loading
    case loaded

    init(isLoading: Bool) {
        switch isLoading {
        case true:
            self = .loading
        case false:
            self = .loaded
        }
    }
}

protocol ActivityDisplayer: class {
    var status: ActivityStatus { get set }
    var activityIndicatorHandler: ActivityIndicatorHandler { get }
}

extension ActivityDisplayer {

    var activityIndicatorHandler: ActivityIndicatorHandler {
        return ActivityIndicatorHandler.shared
    }

    var status: ActivityStatus {
        get {
            return ActivityStatus(isLoading: self.activityIndicatorHandler.isLoading)
        }
        set {
            switch newValue {
            case .loaded:
                self.activityIndicatorHandler.dismissActivityIndicator()
            default:
                self.activityIndicatorHandler.presentActivityIndicator()
            }
        }
    }
}

class ActivityIndicatorHandler {
    static let shared: ActivityIndicatorHandler = ActivityIndicatorHandler()
    private var window: UIWindow? = UIApplication.shared.keyWindow
    private var activityIndicatorViewController: UIViewController?
    var isLoading: Bool { return self.activityIndicatorViewController == nil }
}

extension ActivityIndicatorHandler {

    func presentActivityIndicator() {
        guard let window = self.window else {
            fatalError("Unable to create activityIndicatorViewController, window is missing")
        }

        let activityIndicatorViewController = self.activityIndicatorViewController(withSize: window.frame.size)
        window.addSubview(activityIndicatorViewController.view)
        self.activityIndicatorViewController = activityIndicatorViewController
    }

    func dismissActivityIndicator() {
        guard let activityIndicatorViewController = self.activityIndicatorViewController else {
            print("nothing to dismiss")
            return
        }

        activityIndicatorViewController.view.removeFromSuperview()
        self.activityIndicatorViewController = nil
    }

    private func activityIndicatorViewController(withSize size: CGSize) -> UIViewController {

        let activityViewController = UIViewController()
        activityViewController.view.frame = CGRect(origin: .zero, size: size)
        activityViewController.view.alpha = 0.7
        activityViewController.view.backgroundColor = .gray
        let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(origin: .zero,
                                                                      size: CGSize(width: 30, height: 30)))
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityViewController.view.addSubview(activityIndicatorView)

        activityIndicatorView.centerXAnchor.constraint(equalTo: activityViewController.view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: activityViewController.view.centerYAnchor).isActive = true
        return activityViewController
    }
}
