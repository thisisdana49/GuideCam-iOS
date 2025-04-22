//
//  CoordinatorProtocol.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}
