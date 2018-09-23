import UIKit
import BaaServiceKit

final class DiscoverNodesViewController: UIViewController, ActivityDisplayer {

    @IBOutlet weak var tableView: UITableView!
    private var nodes = [URL]()

    override func viewDidLoad() {
        super.viewDidLoad()
        discoverNodeURLs()
        setUpTableView()
    }
}

private extension DiscoverNodesViewController {

    func setUpTableView() {
        tableView.register(NodeCell.self, forCellReuseIdentifier: NodeCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    func discoverNodeURLs() {
        status = .loading
        ServiceProvider.shared.blockchainService.discoverPublicNodeURLs { [weak self] result in
            switch result {
            case .success(let urls):
                self?.nodes = urls
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showAlert(for: error)
            }
            self?.status = .loaded
        }
    }
}

extension DiscoverNodesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NodeCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "Node URL"
        cell.detailTextLabel?.text = nodes[indexPath.row].absoluteString
        return cell
    }
}

extension DiscoverNodesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        status = .loading
        ServiceProvider.shared.blockchainService.configuration(ofNodeAtURL: nodes[indexPath.row]) { [weak self] result in
            switch result {
            case .success(let node):
                self?.showAlert(title: "Configuration", message: node.debugDescription)
            case .failure(let error):
                self?.showAlert(for: error)
            }
            self?.status = .loaded
        }
    }
}


