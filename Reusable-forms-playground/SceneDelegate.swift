//
//  SceneDelegate.swift
//  InputFormPoc
//
//  Created by Василий Клецкин on 6/7/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewController = FeatureOneFormComposer.composeFeatureOne(
            submit: submit,
            iinValidation: asyncValidateIin
        )
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

// MARK: Submission request

func submit(request: FeatureOneSubmitRequest) -> (@escaping (Result<Void, Error>) -> Void) -> Void {
    { completion in
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            completion(.success(()))
        }
    }
}

// MARK: Async validation with caching

func asyncValidateIin(_ value: String) -> (@escaping (Result<TextValidationResult, Error>) -> Void) -> Void {
    return { completion in
        if let result = Cache.getResult(forKey: value) {
            completion(.success(result))
            return
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let result = validateIin(value)
            Cache.setResult(result, forKey: value)
            completion(.success(result))
        }
    }
    
    class Cache {
        private static let cacheQueue = DispatchQueue(label: "com.example.cacheQueue", attributes: .concurrent)
        private static var results: [String: TextValidationResult] = [:]
        
        static func setResult(_ result: TextValidationResult, forKey key: String) {
            cacheQueue.async(flags: .barrier) {
                results[key] = result
            }
        }
        
        static func getResult(forKey key: String) -> TextValidationResult? {
            var result: TextValidationResult?
            cacheQueue.sync {
                result = results[key]
            }
            return result
        }
    }
}
