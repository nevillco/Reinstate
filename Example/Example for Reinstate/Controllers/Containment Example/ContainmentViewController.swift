//
//  ContainmentViewController.swift
//  Reinstate_Example
//
//  Created by Connor Neville on 6/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Reinstate
import UIKit

enum ContainmentViewState: Int {

    case redChild
    case yellowChild
    case cyanChild

}

class ContainmentViewController: StatefulViewController<ContainmentViewState> {

    private var timer: Timer?

    init() {
        super.init(initialState: .redChild)
        title = "Container"
    }

    override func childViewController(for state: ContainmentViewState) -> UIViewController {
        let color: UIColor
        switch state {
        case .redChild: color = .red
        case .yellowChild: color = .yellow
        case .cyanChild: color = .cyan
        }
        return ContainmentChildViewController(color: color)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { [weak self] _ in
            self?.goToNextState()
        })
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func goToNextState() {
        let currentRawValue = state.rawValue
        let nextState = ContainmentViewState(rawValue: currentRawValue + 1) ?? ContainmentViewState.redChild
        transition(to: nextState, animated: true)
    }

}
