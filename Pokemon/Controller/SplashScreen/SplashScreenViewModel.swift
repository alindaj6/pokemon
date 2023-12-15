//
//  SplashScreenViewModel.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

class SplashScreenViewModel {

    fileprivate var countdownTimer: Timer?
    fileprivate var countTimer: Observable<Int> = Observable(0)
    var isCountdownDone: Observable<Bool> = Observable(false)

    func startTimer() {
        if countdownTimer == nil {
            countdownTimer = Timer()
        }
        self.resetTimer()
        self.setupCountdownTimer()
        self.isCountdownDone.value = false
    }

    func stopTimer() {
        self.invalidateTimer()
        self.resetTimer()
    }

    fileprivate func resetTimer() {
        self.countTimer.value = 1
    }

    fileprivate func setupCountdownTimer() {
        if countdownTimer == nil {
            countdownTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                  target: self,
                                                  selector: #selector(updateCountdown),
                                                  userInfo: nil, repeats: true)
        }
    }

    @objc fileprivate func updateCountdown() {
        if countTimer.value > 0 {
            countTimer.value -= 1
        } else if countTimer.value == 0 {
            self.stopTimer()
            self.resetTimer()
            self.isCountdownDone.value = true
        }
    }

    fileprivate func invalidateTimer() {
        if let timer = self.countdownTimer {
            timer.invalidate()
        }
        countdownTimer = nil
    }
}
