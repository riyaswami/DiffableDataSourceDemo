//
//  NetworkLayer.swift
//  Demo List
//
//  Created by riyaswami on 21/12/23.
//

import Foundation

class MainAPIManager{
    var apiUrl: URL?
    init(url: String){
        apiUrl = URL(string: url)!
    }
    func fetchTodoListAPI(completion: ((Result<TodoObject, Error>) -> ())?){
        guard let apiUrl else {
            completion?(.failure(NSError()))
            return
        }
        URLSession.shared.dataTask(with: apiUrl) {[weak self] data, response, error in
            if let data = data, let result = self?.parseJson(obj: data){
                completion?(.success(result))
            }
            else if let error = error{
                completion?(.failure(error))
            }
        }.resume()
    }
    
    func parseJson(obj: Data) -> TodoObject?{
        let decoder = JSONDecoder()
        do{
            let result  = try decoder.decode(TodoObject.self, from: obj)
            return result
        }
        catch{
            return nil
        }
    }
}

