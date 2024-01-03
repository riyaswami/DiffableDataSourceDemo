//
//  ViewController.swift
//  Demo List
//
//  Created by riyaswami on 21/12/23.
//

import UIKit

enum HashableSection{
    case SectionOne
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<HashableSection, HashableCells>?
    
    
    
    var viewModel: MainViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        viewModel = MainViewModel(networkObject: MainAPIManager(url: "https://dummyjson.com/todos"))
        viewModel?.delegate = self
        tableView.delegate = self
        setUpDataSource()
        viewModel?.getTodoList()
        
    }
    
    private func setUpDataSource(){
        dataSource = UITableViewDiffableDataSource<HashableSection, HashableCells>(tableView: self.tableView, cellProvider: {tableView,indexPath,itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath)
            if let todoCell = cell as? MainTableViewCell, let vm = itemIdentifier as? MainCellVM{
                todoCell.initializeVM(vm: vm)
                todoCell.updateLabel()
                return todoCell
            }
            return UITableViewCell()
        })
    }
    
    private func updateDataSource(){
        if let vms = self.viewModel?.cellVMs{
            var snapshot = NSDiffableDataSourceSnapshot<HashableSection, HashableCells>()
            snapshot.appendSections([.SectionOne])
            snapshot.appendItems(vms, toSection: .SectionOne)
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
        
    }
    
    func showToast(message: String) {
        let toast = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(toast, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            toast.dismiss(animated: true, completion: nil)
        }
    }


}

extension ViewController: MainViewDelegate{
    func loadData() {
        updateDataSource()
    }
    
    func showError(errorString: String) {
        showToast(message: "Something Went Wrong")
    }
    
    func deleteCell(id: UUID) {
        viewModel?.cellVMs = viewModel?.cellVMs?.filter({ cell in
            cell.id != id
        })
        updateDataSource()
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Todo List"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        label.backgroundColor = .black
        return label
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let val = viewModel?.cellVMs?.count, indexPath.row == val - 2{
            viewModel?.getTodoList()
        }
    }
}




