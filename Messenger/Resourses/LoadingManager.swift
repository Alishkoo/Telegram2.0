//
//  LoadingManager.swift
//  Messenger
//
//  Created by Alibek Baisholanov on 27.01.2025.
//

import Foundation
import UIKit

class LoadingManager {
    
    static let shared = LoadingManager()
    
    private var loadingVC: LoadingViewController?
    
    // Показываем прогрузочный экран
    func showLoading(on viewController: UIViewController) {
        guard loadingVC == nil else { return }
        
        let loadingVC = LoadingViewController()
        self.loadingVC = loadingVC
        viewController.present(loadingVC, animated: true, completion: nil)
    }
    
    // Скрываем прогрузочный экран
    func hideLoading() {
        loadingVC?.dismiss(animated: true, completion: {
            self.loadingVC = nil
        })
    }
}


class LoadingViewController: UIViewController {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .black.withAlphaComponent(0.9) // Черный полупрозрачный фон
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
}
