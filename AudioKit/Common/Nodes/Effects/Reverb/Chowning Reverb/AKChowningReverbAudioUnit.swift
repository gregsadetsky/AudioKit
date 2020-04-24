//
//  AKChowningReverbAudioUnit.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2020 AudioKit. All rights reserved.
//

import AVFoundation

public class AKChowningReverbAudioUnit: AKAudioUnitBase {

    public override func createDSP() -> AKDSPRef {
        return createChowningReverbDSP()
    }

    public override init(componentDescription: AudioComponentDescription,
                  options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)


        parameterTree = AUParameterTree.createTree(withChildren: [])

    }
}
