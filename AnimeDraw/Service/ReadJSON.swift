//
//  ReadJSON.swift
//  AnimeDraw
//
//  Created by haiphan on 12/11/20.
//

import UIKit
import SwiftyJSON
import RxSwift
import RxCocoa

class ReadJSON {
    static var shared = ReadJSON()
    private let disposeBag = DisposeBag()
    func readJSONObs<T: Codable>(offType: T.Type, name: String, type: String) -> Observable<APIResult<T, Error>> {
        return Observable.create { (observe) -> Disposable in
            if let path = Bundle.main.path(forResource: "Step by Step", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    let objec = try JSONDecoder().decode(T.self, from: data)
                    observe.onNext(.success(objec))
                    observe.onCompleted()
                } catch let error {
                    observe.onNext(.failure(error))
                    observe.onCompleted()
                }
            } else {
                print("Invalid filename/path.")
            }
//            if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
//                do {
//                    let data = try Data(contentsOf: url)
//                    let decoder = JSONDecoder()
//                    let jsonData = try decoder.decode(ResponseData.self, from: data)
//                    return jsonData.person
//                } catch {
//                    print("error:\(error)")
//                }
//            }
            return Disposables.create()
        }
    }
}

enum APIResult<Value, Error> {
    case success(Value)
    case failure(Error)
    
    init(value: Value) {
        self = .success(value)
    }
    init(err: Error) {
        self = .failure(err)
    }
}
