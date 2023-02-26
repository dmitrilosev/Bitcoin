//
//  Cancellable.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 25.02.2023.
//

import Foundation

protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable {
    // No code
}
