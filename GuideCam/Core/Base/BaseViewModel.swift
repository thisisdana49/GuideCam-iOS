//
//  BaseViewModel.swift
//  GuideCam
//
//  Created by 조다은 on 4/3/25.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

class BaseViewModel {
    let disposeBag = DisposeBag()
}
