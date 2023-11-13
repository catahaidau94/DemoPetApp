//
//  AppDelegate.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 09.11.2023.
//

import UIKit
import RxCocoa
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let navigationController = UINavigationController()
        let navigator = DefaultAnimalsNavigator(services: DefaultUseCaseProvider(),
                                                navigationController: navigationController,
                                                storyBoard: storyboard)
        window.rootViewController = navigationController
        
        let remote = Remote("https://api.petfinder.com/v2/")
        remote.getAuthToken("oauth2/token") { result in
            switch result {
            case .success(let token):
                TokenManager.shared.token = token
                
                DispatchQueue.main.async {
                    navigator.toAllAnimals()
                }
            case .failure(_):
                break
            }
        }
        
        self.window = window
        return true
    }
}
