//
//  AKPitchShifterDSP.hpp
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2020 AudioKit. All rights reserved.
//

#pragma once

#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(AUParameterAddress, AKPitchShifterParameter) {
    AKPitchShifterParameterShift,
    AKPitchShifterParameterWindowSize,
    AKPitchShifterParameterCrossfade,
};

#ifndef __cplusplus

AKDSPRef createPitchShifterDSP(void);

#else

#import "AKSoundpipeDSPBase.hpp"

class AKPitchShifterDSP : public AKSoundpipeDSPBase {
private:
    struct InternalData;
    std::unique_ptr<InternalData> data;
 
public:
    AKPitchShifterDSP();

    void init(int channelCount, double sampleRate) override;

    void deinit() override;

    void reset() override;

    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override;
};

#endif
