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
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupDataSource()
    }

    private func setupDataSource() {
        do {
            nodeHashes = try ServiceProvider.shared.blockchainService.storedHashes()
            self.tableView.reloadData()
        } catch {
            self.showAlert(for: error)
        }
    }


    @IBAction func didPressCreateButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: SequeIdentifier.showCreateRecord.rawValue, sender: self)
    }
}

extension ListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodeHashes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
