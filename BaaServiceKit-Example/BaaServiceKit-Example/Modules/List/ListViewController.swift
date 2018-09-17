import UIKit
import BaaServiceKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var nodeHashes: [NodeHash] = []

    private enum SequeIdentifier: String {
        case showCreateRecord
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDataSource()
    }

    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
    }

    private func updateDataSource() {
        do {
            nodeHashes = try ServiceProvider.shared.blockchainService.storedHashes()
            tableView.reloadData()
        } catch {
            showAlert(for: error)
        }
    }


    @IBAction func didPressCreateButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: SequeIdentifier.showCreateRecord.rawValue, sender: self)
    }
}

extension ListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodeHashes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nodeHash = nodeHashes[indexPath.row]
        let cell: ListCell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier)
        cell.configure(with: nodeHash)
        cell.sizeToFit()
        cell.layoutIfNeeded()
        return cell
    }
}

extension ListViewController: UITableViewDelegate {}

extension ListViewController {
    func configExample() {
        // Config example
        let configURL = URL(string: "http://35.230.179.171")
        ServiceProvider.shared.blockchainService.configuration(ofNodeAtURL: configURL!) { (result) in
            switch result {
            case .success(let config):

                print("==== CONFIG ====")
                print(config)
                print("==== ====== ====")

            case .failure(let error):
                print(error)
            }
        }
    }

    func proof(for nodeHashes: [NodeHash]) {
        ServiceProvider.shared.blockchainService.proof(for: nodeHashes) { results in
            for result in results {
                switch result {
                case .success(let proof):
                    print(proof)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
