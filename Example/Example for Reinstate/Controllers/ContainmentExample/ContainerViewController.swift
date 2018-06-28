//
//  ContainerViewController.swift
//  Reinstate_Example
//
//  Created by Connor Neville on 6/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Reinstate
import UIKit

enum ContainerViewState: Int {

    case redChild
    case yellowChild
    case cyanChild

}

class ContainerViewController: StatefulViewController<ContainerViewState> {

    private var timer: Timer?

    init() {
        super.init(initialState: .redChild)
        title = "Container"
    }

    override func childViewController(for state: ContainerViewState) -> UIViewController {
        let color: UIColor
        switch state {
        case .redChild: color = .red
        case .yellowChild: color = .yellow
        case .cyanChild: color = .cyan
        }
        return ContainerChildViewController(color: color)
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
        let nextState = ContainerViewState(rawValue: currentRawValue + 1) ?? ContainerViewState.redChild
        transition(to: nextState, animated: true)
    }

}
