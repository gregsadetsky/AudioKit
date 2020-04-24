//
//  AKPeakingParametricEqualizerFilter.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2020 AudioKit. All rights reserved.
//

/// This is an implementation of Zoelzer's parametric equalizer filter.
///
open class AKPeakingParametricEqualizerFilter: AKNode, AKToggleable, AKComponent, AKInput {
    public typealias AKAudioUnitType = AKPeakingParametricEqualizerFilterAudioUnit
    /// Four letter unique description of the node
    public static let ComponentDescription = AudioComponentDescription(effect: "peq0")

    // MARK: - Properties
    public private(set) var internalAU: AKAudioUnitType?

    /// Lower and upper bounds for Center Frequency
    public static let centerFrequencyRange: ClosedRange<Double> = 12.0 ... 20000.0

    /// Lower and upper bounds for Gain
    public static let gainRange: ClosedRange<Double> = 0.0 ... 10.0

    /// Lower and upper bounds for Q
    public static let qRange: ClosedRange<Double> = 0.0 ... 2.0

    /// Initial value for Center Frequency
    public static let defaultCenterFrequency: Double = 1000

    /// Initial value for Gain
    public static let defaultGain: Double = 1.0

    /// Initial value for Q
    public static let defaultQ: Double = 0.707

    /// Center frequency.
    open var centerFrequency: Double = defaultCenterFrequency {
        willSet {
            let clampedValue = AKPeakingParametricEqualizerFilter.centerFrequencyRange.clamp(newValue)
            guard centerFrequency != clampedValue else { return }
            internalAU?.centerFrequency.value = AUValue(clampedValue)
        }
    }

    /// Amount at which the center frequency value shall be increased or decreased. A value of 1 is a flat response.
    open var gain: Double = defaultGain {
        willSet {
            let clampedValue = AKPeakingParametricEqualizerFilter.gainRange.clamp(newValue)
            guard gain != clampedValue else { return }
            internalAU?.gain.value = AUValue(clampedValue)
        }
    }

    /// Q of the filter. sqrt(0.5) is no resonance.
    open var q: Double = defaultQ {
        willSet {
            let clampedValue = AKPeakingParametricEqualizerFilter.qRange.clamp(newValue)
            guard q != clampedValue else { return }
            internalAU?.q.value = AUValue(clampedValue)
        }
    }

    /// Tells whether the node is processing (ie. started, playing, or active)
    open var isStarted: Bool {
        return internalAU?.isStarted ?? false
    }

    // MARK: - Initialization

    /// Initialize this equalizer node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///   - centerFrequency: Center frequency.
    ///   - gain: Amount at which the center frequency value shall be increased or decreased. A value of 1 is a flat response.
    ///   - q: Q of the filter. sqrt(0.5) is no resonance.
    ///
    public init(
        _ input: AKNode? = nil,
        centerFrequency: Double = defaultCenterFrequency,
        gain: Double = defaultGain,
        q: Double = defaultQ
        ) {
        super.init()

        _Self.register()
        AVAudioUnit._instantiate(with: _Self.ComponentDescription) { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit
            self.internalAU = avAudioUnit.auAudioUnit as? AKAudioUnitType
            input?.connect(to: self)

            self.centerFrequency = centerFrequency
            self.gain = gain
            self.q = q
        }
    }

    // MARK: - Control

    /// Function to start, play, or activate the node, all do the same thing
    open func start() {
        internalAU?.start()
    }

    /// Function to stop or bypass the node, both are equivalent
    open func stop() {
        internalAU?.stop()
    }
}
