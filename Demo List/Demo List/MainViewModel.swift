//
//  MainViewModel.swift
//  Demo List
//
//  Created by riyaswami on 21/12/23.
//

import Foundation

protocol MainViewDelegate{
    func showError(errorString: String)
    func loadData()
    func deleteCell(id: UUID)
}

class HashableCells: Hashable{
    var id: UUID
    static func == (lhs: HashableCells, rhs: HashableCells) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
    }
    
    init(){
        id = UUID()
    }
    
}

class MainViewModel{
    var cellVMs: [HashableCells]? = []
    var networkObject: MainAPIManager
    var delegate: MainViewDelegate?
    
    init(networkObject: MainAPIManager){
        self.networkObject = networkObject
    }
    func getTodoList(){
        // call API for todoList
        networkObject.fetchTodoListAPI { [weak self] result in
            switch result{
            case .success(let model):
                // create cellVMs from Model
                for i in model.todos{
                    let vm = MainCellVM(labelText: i.todo, isDone: i.completed)
                    vm.delegate = self
                    self?.cellVMs?.append(vm)
                }
                self?.delegate?.loadData()
            case .failure(let error):
                self?.delegate?.showError(errorString: error.localizedDescription)
            }
        }
    }
    
    func removeTask(index: Int){
        cellVMs?.remove(at: index)
    }
    
    
    
}

extension MainViewModel: CellDelegate{
    func deleteCell(id: UUID){
        delegate?.deleteCell(id: id)
    }
}

