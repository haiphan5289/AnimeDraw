//
//  RealmManage.swift
//  AnimeDraw
//
//  Created by paxcreation on 12/14/20.
//

import Foundation
import RealmSwift
import Realm

enum PushNotificationKeys: String {
    case addStep
    case addTutorial
}

class RealmManage {
    static var share = RealmManage()
    var realm : Realm!
    init() {
        migrateWithCompletion()
        realm = try! Realm()
    }
    func migrateWithCompletion() {
        let config = RLMRealmConfiguration.default()
        config.schemaVersion = 7
        
        config.migrationBlock = { (migration, oldSchemaVersion) in
            if (oldSchemaVersion < 1) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
        }
        
        RLMRealmConfiguration.setDefault(config)
        print("schemaVersion after migration:\(RLMRealmConfiguration.default().schemaVersion)")
        RLMRealm.default()
    }
    private func getStepRealm() -> [StepByStepReaml] {
        let list = realm.objects(StepByStepReaml.self).toArray(ofType: StepByStepReaml.self)
        return list
    }
    func addStep(model: StepModel) {
        let itemAdd = StepByStepReaml.init(model: model, isStep: true)
        try! realm.write {
            realm.add(itemAdd)
            NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.addStep.rawValue), object: nil, userInfo: nil)
        }
    }
    
    func getStepByStep() -> [StepModel] {
        let l = self.getStepRealm()
        var listStep: [StepModel] = []
        for m in l {
            guard let model = m.product?.toCodableObject() as StepModel? else{
                return []
            }
            if m.isStep {
                listStep.append(model)
            }
        }
        return listStep
    }
    private func getTutorialRealm() -> [StepByStepReaml] {
        let list = realm.objects(StepByStepReaml.self).toArray(ofType: StepByStepReaml.self)
        return list
    }
    
    func addTutorial(model: StepModel) {
        let itemAdd = StepByStepReaml.init(model: model, isStep: false)
        try! realm.write {
            realm.add(itemAdd)
            NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.addStep.rawValue), object: nil, userInfo: nil)
        }
    }
    func getTutorial() -> [StepModel] {
        let l = self.getTutorialRealm()
        var listStep: [StepModel] = []
        for m in l {
            guard let model = m.product?.toCodableObject() as StepModel? else{
                return []
            }
            if !m.isStep {
                listStep.append(model)
            }
        }
        return listStep
    }
    
}
extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
extension Data {
    func toCodableObject<T: Codable>() -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        if let obj = try? decoder.decode(T.self, from: self) {
            return obj
        }
        return nil    }
    
}
