//
//  Published.swift
//  Task
//
//  Created by Роман Мошковцев on 29.06.2021.
//

import Foundation
import Combine

private var cancellableSet: Set<AnyCancellable> = []
private var decoder: JSONDecoder = JSONDecoder()
private var encoder: JSONEncoder = JSONEncoder()

extension Published where Value: Codable {
    init(
        wrappedValue defaultValue: Value,
        _ key: String,
        store: UserDefaults = .standard
    ) {
        if let data = store.data(forKey: key),
           let value = try? decoder.decode(Value.self, from: data) {
            self.init(initialValue: value)
        } else {
            self.init(initialValue: defaultValue)
        }

        projectedValue
            .sink { newValue in
                let data = try? encoder.encode(newValue)
                store.set(data, forKey: key)
                store.synchronize()
            }
            .store(in: &cancellableSet)
    }
}
