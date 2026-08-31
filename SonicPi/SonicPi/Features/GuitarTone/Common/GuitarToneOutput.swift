//
//  GuitarToneOutput.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 26/08/26.
//


@MainActor
protocol GuitarToneOutput: AnyObject {
  func prepareAudioTapped() async
  func didEndingAudioTapped()
}

