//
//  Closures+Insert.swift
//  Reinstate
//
//  Created by Connor Neville on 7/6/18.
//

func insert(_ newCompletion: @escaping (() -> Void), before oldCompletion: (() -> Void)?) -> (() -> Void) {
    return {
        newCompletion()
        oldCompletion?()
    }
}
