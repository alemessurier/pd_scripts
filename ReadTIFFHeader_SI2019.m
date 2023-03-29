function [Metadata] = ReadTIFFHeader_SI2019(Metadata)

% ReadTIFFHeader_SI2019() extracts SI2019 imaging information from the TIFF fileheader
% and stores it in new fields within the Metadata structure.  These fields are:
% FrameNumberRaw(frame)      Native frame number during acquisition, ie before any online frame averaging
% FrameNumberTIFF(frame)     Frame number in TIFF, after frame averaging
% FrameTimeInMovie(frame)    Time (sec) since start-of-movie trigger.  Used for stimulus alignment.
% acqNumAveragedFrames       Number of frames averaged online during acquisition before saving TIFF
% acqScanFramePeriod         Interval (s) between raw single frame
% acqZoomFactor              Integer 1 to n.  Used to determine scale bar.
% MovieChannels              Vector containing each imaging channel interleaved frame-by-frame in the TIFF.
%                            Note: number of channels interleaved in TIFF file is length(MovieChannels).

% You must first have run LoadTIFF_SI2019 to read the Metadata.

NumberImages = length(Metadata.InfoImage);
Metadata.FrameNumberRaw = zeros([NumberImages 1]);       % 1-d vectors
Metadata.FrameNumberTIFF = zeros([NumberImages 1]);
Metadata.FrameTimeInMovie = zeros([NumberImages 1]);
Metadata.MovieChannels = zeros(4);          % 
str = Metadata.meta;

% Movie-specific parameters, read once from the first header
% expression = sprintf('acqNumAveragedFrames.+\n');
% matchStr = regexp(str,expression,'match','dotexceptnewline');    % this returns whole line
% tempindex = strfind(matchStr{1,1},'=');    % index of equal sign
% Metadata.acqNumAveragedFrames = str2double(matchStr{1,1}(tempindex+1:end));     

expression = sprintf('SI.hRoiManager.scanFramePeriod.+\n');
matchStr = regexp(str,expression,'match','dotexceptnewline');    % this returns whole line
tempindex = strfind(matchStr{1,1},'=');    % index of equal sign
Metadata.acqScanFramePeriod = str2double(matchStr{1,1}(tempindex+1:end));     

expression = sprintf('SI.hRoiManager.scanFrameRate.+\n');
matchStr = regexp(str,expression,'match','dotexceptnewline');    % this returns whole line
tempindex = strfind(matchStr{1,1},'=');    % index of equal sign
Metadata.acqScanFrameRate = str2double(matchStr{1,1}(tempindex+1:end));     

% SI.hRoiManager.scanFramePeriod = 0.0333101
% SI.hRoiManager.scanFrameRate = 30.0209
expression = sprintf('SI.hRoiManager.scanZoomFactor.+\n');
matchStr = regexp(str,expression,'match','dotexceptnewline');    % this returns whole line
tempindex = strfind(matchStr{1,1},'=');    % index of equal sign
Metadata.acqZoomFactor = str2double(matchStr{1,1}(tempindex+1:end));     

expression = sprintf('SI.hChannels.channelSave.+\n');
matchStr = regexp(str,expression,'match','dotexceptnewline');    % this returns whole line
tempindex = strfind(matchStr{1,1},'=');    % index of equal sign
matchStr = matchStr{1,1}(tempindex+2:end);   % contains [1] or [1;2] or [1;2;3;4] etc
Metadata.MovieChannels = eval(matchStr);   % this converts '[1;2]' string notation to column vector containing [1;2]
% Note on format of MovieChannels vector:
% The number of imaging channels in TIFF movie is length(Metadata.MovieChannels).  
% Imaging channels are stored in TIFF file in alternating frame, with frame 1 
% representating the imaging channel MovieChannels(1), frame 2 representing the 
% imaging channel MovieChannels(2), etc.

% Frame-specific parameters, read separately from header of each frame.
for frameindex = 1:NumberImages
    
    Metadata.FrameNumberTIFF(frameindex) = frameindex;      
    
    str = Metadata.InfoImage(frameindex).ImageDescription;
    
    expression = sprintf('frameTimestamps_sec.+\n');
    matchStr = regexp(str,expression,'match','dotexceptnewline');    % this returns whole line
    tempindex = strfind(matchStr{1,1},'=');    % index of equal sign
    Metadata.FrameTimeInMovie(frameindex) = str2double(matchStr{1,1}(tempindex+1:end));     
    
    expression = sprintf('frameNumbers.+\n');
    matchStr = regexp(str,expression,'match','dotexceptnewline');    % this returns whole line
    tempindex = strfind(matchStr{1,1},'=');    % index of equal sign
    Metadata.FrameNumberRaw(frameindex) = str2double(matchStr{1,1}(tempindex+1:end));     
      
end

end

%% ScanImage5 TIFF Header Structure  

%    This is the structure of SI2019-specific information stored in the TIFF Image header.    
%    All info is contained in InfoImage(TIFF_frame_number).ImageDescription
%    This field is a string with subfields separated by /n (=char(10))
%

% SI.LINE_FORMAT_VERSION = 1
% SI.TIFF_FORMAT_VERSION = 4
% SI.VERSION_COMMIT = '4d721e971c0ad09a425a51ff1880b4ed407e9be6'
% SI.VERSION_MAJOR = '2019b'
% SI.VERSION_MINOR = '0'
% SI.acqState = 'loop'
% SI.acqsPerLoop = 20
% SI.extTrigEnable = false
% SI.hBeams.beamCalibratedStatus = true
% SI.hBeams.directMode = false
% SI.hBeams.enablePowerBox = false
% SI.hBeams.extPowerScaleFnc = []
% SI.hBeams.flybackBlanking = true
% SI.hBeams.interlaceDecimation = 1
% SI.hBeams.interlaceOffset = 0
% SI.hBeams.lengthConstants = Inf
% SI.hBeams.powerBoxEndFrame = Inf
% SI.hBeams.powerBoxStartFrame = 1
% SI.hBeams.powerBoxes.rect = [0.25 0.25 0.5 0.5]
% SI.hBeams.powerBoxes.powers = NaN
% SI.hBeams.powerBoxes.name = ''
% SI.hBeams.powerBoxes.oddLines = true
% SI.hBeams.powerBoxes.evenLines = true
% SI.hBeams.powerLimits = 100
% SI.hBeams.powers = 50
% SI.hBeams.pzAdjust = false
% SI.hBeams.pzCustom = {[]}
% SI.hBeams.tfExtForceStreaming = 0
% SI.hChannels.channelAdcResolution = {12 12 12 12}
% SI.hChannels.channelDisplay = [1;2]
% SI.hChannels.channelInputRange = {[-1 1] [-1 1] [-1 1] [-1 1]}
% SI.hChannels.channelLUT = {[0 2047] [-1 267] [0 100] [0 100]}
% SI.hChannels.channelMergeColor = {'green';'red';'red';'red'}
% SI.hChannels.channelName = {'Channel 1' 'Channel 2' 'Channel 3' 'Channel 4'}
% SI.hChannels.channelOffset = [-48 -644 -48 -644]
% SI.hChannels.channelSave = [1;2]
% SI.hChannels.channelSubtractOffset = [true true true true]
% SI.hChannels.channelType = {'stripe' 'stripe' 'stripe' 'stripe'}
% SI.hChannels.channelsActive = [1;2]
% SI.hChannels.channelsAvailable = 4
% SI.hChannels.loggingEnable = 1
% SI.hConfigurationSaver.cfgFilename = ''
% SI.hConfigurationSaver.usrFilename = ''
% SI.hCycleManager.cycleIterIdxTotal = 0
% SI.hCycleManager.cyclesCompleted = 0
% SI.hCycleManager.enabled = false
% SI.hCycleManager.itersCompleted = 0
% SI.hCycleManager.totalCycles = 1
% SI.hDisplay.autoScaleSaturationFraction = [0.1 0.01]
% SI.hDisplay.channelsMergeEnable = 1
% SI.hDisplay.channelsMergeFocusOnly = false
% SI.hDisplay.displayRollingAverageFactor = 5
% SI.hDisplay.displayRollingAverageFactorLock = false
% SI.hDisplay.enableScanfieldDisplays = false
% SI.hDisplay.lineScanHistoryLength = 1000
% SI.hDisplay.renderer = 'auto'
% SI.hDisplay.scanfieldDisplayColumns = 5
% SI.hDisplay.scanfieldDisplayRows = 5
% SI.hDisplay.scanfieldDisplayTilingMode = 'Auto'
% SI.hDisplay.scanfieldDisplays.enable = false
% SI.hDisplay.scanfieldDisplays.name = 'Display 1'
% SI.hDisplay.scanfieldDisplays.channel = 1
% SI.hDisplay.scanfieldDisplays.roi = 1
% SI.hDisplay.scanfieldDisplays.z = 0
% SI.hDisplay.selectedZs = []
% SI.hDisplay.showScanfieldDisplayNames = true
% SI.hDisplay.volumeDisplayStyle = '3D'
% SI.hFastZ.actuatorLag = 0
% SI.hFastZ.discardFlybackFrames = false
% SI.hFastZ.enable = false
% SI.hFastZ.enableFieldCurveCorr = false
% SI.hFastZ.flybackTime = 0
% SI.hFastZ.hasFastZ = false
% SI.hFastZ.nonblockingMoveInProgress = false
% SI.hFastZ.numDiscardFlybackFrames = 0
% SI.hFastZ.positionAbsoluteRaw = NaN
% SI.hFastZ.positionTarget = 0
% SI.hFastZ.positionTargetRaw = 0
% SI.hFastZ.volumePeriodAdjustment = -0.0006
% SI.hFastZ.waveformType = 'sawtooth'
% SI.hFastZ.zAlignment = []
% SI.hIntegrationRoiManager.enable = false
% SI.hIntegrationRoiManager.enableDisplay = true
% SI.hIntegrationRoiManager.integrationHistoryLength = 1000
% SI.hIntegrationRoiManager.postProcessFcn = @scanimage.components.integrationRois.integrationPostProcessingFcn
% SI.hMotionManager.correctionBoundsXY = [-5 5]
% SI.hMotionManager.correctionBoundsZ = [-50 50]
% SI.hMotionManager.correctionDeviceXY = 'galvos'
% SI.hMotionManager.correctionDeviceZ = 'fastz'
% SI.hMotionManager.correctionEnableXY = false
% SI.hMotionManager.correctionEnableZ = false
% SI.hMotionManager.correctorClassName = 'scanimage.components.motionCorrectors.SimpleMotionCorrector'
% SI.hMotionManager.enable = false
% SI.hMotionManager.estimatorClassName = 'scanimage.components.motionEstimators.SimpleMotionEstimator'
% SI.hMotionManager.motionHistoryLength = 100
% SI.hMotionManager.motionMarkersXY = zeros(0,2)
% SI.hMotionManager.resetCorrectionAfterAcq = true
% SI.hMotionManager.zStackAlignmentFcn = @scanimage.components.motionEstimators.util.alignZRoiData
% SI.hMotors.axesPosition = [-0.5 1832 668]
% SI.hMotors.azimuth = 0
% SI.hMotors.backlashCompensation = [0 0 0]
% SI.hMotors.elevation = 0
% SI.hMotors.errorMsg = {''}
% SI.hMotors.errorTf = false
% SI.hMotors.isAligned = false
% SI.hMotors.isRelativeZeroSet = false
% SI.hMotors.minPositionQueryInterval_s = 0.001
% SI.hMotors.motorPosition = [-0.5 1832 668]
% SI.hMotors.moveInProgress = false
% SI.hMotors.moveTimeout_s = 10
% SI.hMotors.samplePosition = [0.5 -1832 -668]
% SI.hMotors.simulatedAxes = [false false false]
% SI.hMotors.userDefinedPositions = []
% SI.hPhotostim.allowMultipleOutputs = false
% SI.hPhotostim.autoTriggerPeriod = 0
% SI.hPhotostim.compensateMotionEnabled = true
% SI.hPhotostim.completedSequences = 0
% SI.hPhotostim.laserActiveSignalAdvance = 0.001
% SI.hPhotostim.lastMotion = [0 0]
% SI.hPhotostim.logging = false
% SI.hPhotostim.monitoring = false
% SI.hPhotostim.monitoringSampleRate = 9000
% SI.hPhotostim.nextStimulus = 1
% SI.hPhotostim.numOutputs = 0
% SI.hPhotostim.numSequences = Inf
% SI.hPhotostim.sequencePosition = 1
% SI.hPhotostim.sequenceSelectedStimuli = []
% SI.hPhotostim.status = 'Offline'
% SI.hPhotostim.stimImmediately = false
% SI.hPhotostim.stimSelectionAssignment = []
% SI.hPhotostim.stimSelectionDevice = ''
% SI.hPhotostim.stimSelectionTerms = []
% SI.hPhotostim.stimSelectionTriggerTerm = []
% SI.hPhotostim.stimTriggerTerm = 1
% SI.hPhotostim.stimulusMode = 'onDemand'
% SI.hPhotostim.syncTriggerTerm = []
% SI.hPhotostim.zMode = '2D'
% SI.hPmts.autoPower = [false false false false]
% SI.hPmts.bandwidths = [8e+07 8e+07 NaN NaN]
% SI.hPmts.gains = [0.5 0.5 0 0]
% SI.hPmts.names = {'Thor 1' 'Thor 2' 'Thor 3' 'Thor 4'}
% SI.hPmts.offsets = [-0.0009524 0.1629 NaN NaN]
% SI.hPmts.powersOn = [true true false false]
% SI.hPmts.tripped = [false false false false]
% SI.hRoiManager.forceSquarePixelation = true
% SI.hRoiManager.forceSquarePixels = true
% SI.hRoiManager.imagingFovDeg = [-3 -3;3 -3;3 3;-3 3]
% SI.hRoiManager.imagingFovUm = [-45 -45;45 -45;45 45;-45 45]
% SI.hRoiManager.linePeriod = 6.30874e-05
% SI.hRoiManager.linesPerFrame = 512
% SI.hRoiManager.mroiEnable = false
% SI.hRoiManager.pixelsPerLine = 512
% SI.hRoiManager.scanAngleMultiplierFast = 1
% SI.hRoiManager.scanAngleMultiplierSlow = 1
% SI.hRoiManager.scanAngleShiftFast = 0
% SI.hRoiManager.scanAngleShiftSlow = 0
% SI.hRoiManager.scanFramePeriod = 0.0333101
% SI.hRoiManager.scanFrameRate = 30.0209
% SI.hRoiManager.scanRotation = 0
% SI.hRoiManager.scanType = 'frame'
% SI.hRoiManager.scanVolumeRate = 30.0209
% SI.hRoiManager.scanZoomFactor = 3
% SI.hScan2D.beamClockDelay = 1.5e-06
% SI.hScan2D.beamClockExtend = 0
% SI.hScan2D.bidirectional = true
% SI.hScan2D.channelOffsets = [-48 -644 -48 -644]
% SI.hScan2D.channels = {}
% SI.hScan2D.channelsAdcResolution = 12
% SI.hScan2D.channelsAutoReadOffsets = true
% SI.hScan2D.channelsAvailable = 4
% SI.hScan2D.channelsDataType = 'int16'
% SI.hScan2D.channelsFilter = 'none'
% SI.hScan2D.channelsInputRanges = {[-1 1] [-1 1] [-1 1] [-1 1]}
% SI.hScan2D.channelsSubtractOffsets = [true true true true]
% SI.hScan2D.fillFractionSpatial = 0.9
% SI.hScan2D.fillFractionTemporal = 0.712867
% SI.hScan2D.flybackTimePerFrame = 0.001
% SI.hScan2D.flytoTimePerScanfield = 0.001
% SI.hScan2D.fovCornerPoints = [-23 -10;23 -10;23 10;-23 10]
% SI.hScan2D.hasResonantMirror = true
% SI.hScan2D.hasXGalvo = true
% SI.hScan2D.keepResonantScannerOn = false
% SI.hScan2D.laserTriggerDebounceTicks = 0
% SI.hScan2D.laserTriggerSampleMaskEnable = false
% SI.hScan2D.laserTriggerSampleWindow = [0 1]
% SI.hScan2D.linePhase = 2.71e-06
% SI.hScan2D.linePhaseMode = 'Nearest Neighbor'
% SI.hScan2D.logAverageFactor = 1
% SI.hScan2D.logFramesPerFile = Inf
% SI.hScan2D.logFramesPerFileLock = false
% SI.hScan2D.logOverwriteWarn = false
% SI.hScan2D.mask = [16;16;16;15;15;15;15;14;15;14;14;14;13;14;13;13;13;13;13;13;13;12;12;13;12;12;12;12;11;12;12;11;12;11;11;11;11;11;11;11;11;11;11;10;11;10;11;10;10;11;10;10;10;10;10;10;10;10;10;9;10;10;9;10;10;9;10;9;9;10;9;9;10;9;9;9;9;9;9;9;9;9;9;9;9;9;8;9;9;9;8;9;9;8;9;8;9;8;9;8;9;8;9;8;8;9;8;8;8;9;8;8;8;8;8;9;8;8;8;8;8;8;8;8;8;8;8;8;8;7;8;8;8;8;8;7;8;8;8;7;8;8;8;7;8;8;7;8;8;7;8;7;8;7;8;8;7;8;7;8;7;8;7;8;7;8;7;7;8;7;8;7;7;8;7;7;8;7;8;7;7;7;8;7;7;8;7;7;8;7;7;7;8;7;7;7;7;8;7;7;7;7;8;7;7;7;7;7;8;7;7;7;7;7;8;7;7;7;7;7;7;7;7;8;7;7;7;7;7;7;7;7;7;8;7;7;7;7;7;7;7;7;7;7;7;7;7;8;7;7;7;7;7;7;7;7;7;7;7;7;7;7;7;7;8;7;7;7;7;7;7;7;7;7;7;7;7;7;8;7;7;7;7;7;7;7;7;7;8;7;7;7;7;7;7;7;7;8;7;7;7;7;7;8;7;7;7;7;7;8;7;7;7;7;8;7;7;7;7;8;7;7;7;8;7;7;8;7;7;8;7;7;7;8;7;8;7;7;8;7;7;8;7;8;7;7;8;7;8;7;8;7;8;7;8;7;8;8;7;8;7;8;7;8;8;7;8;8;7;8;8;8;7;8;8;8;7;8;8;8;8;8;7;8;8;8;8;8;8;8;8;8;8;8;8;8;9;8;8;8;8;8;9;8;8;8;9;8;8;9;8;9;8;9;8;9;8;9;8;9;9;8;9;9;9;8;9;9;9;9;9;9;9;9;9;9;9;9;9;10;9;9;10;9;9;10;9;10;10;9;10;10;9;10;10;10;10;10;10;10;10;10;11;10;10;11;10;11;10;11;11;11;11;11;11;11;11;11;11;12;11;12;12;11;12;12;12;12;13;12;12;13;13;13;13;13;13;13;14;13;14;14;14;15;14;15;15;15;15;16;16;16]
% SI.hScan2D.maskDisableAveraging = [false false false false]
% SI.hScan2D.maxSampleRate = 1e+08
% SI.hScan2D.name = 'ImagingScanner'
% SI.hScan2D.nominalFovCornerPoints = [-23 -10;23 -10;23 10;-23 10]
% SI.hScan2D.pixelBinFactor = 1
% SI.hScan2D.sampleRate = 1e+08
% SI.hScan2D.scanMode = 'resonant'
% SI.hScan2D.scanPixelTimeMaxMinRatio = 2.28571
% SI.hScan2D.scanPixelTimeMean = 8.78516e-08
% SI.hScan2D.scannerFrequency = 7925.52
% SI.hScan2D.scannerToRefTransform = [1 0 0;0 1 0;0 0 1]
% SI.hScan2D.scannerType = 'RGG'
% SI.hScan2D.settleTimeFraction = 0
% SI.hScan2D.simulated = false
% SI.hScan2D.stripingEnable = false
% SI.hScan2D.trigAcqEdge = 'rising'
% SI.hScan2D.trigAcqInTerm = ''
% SI.hScan2D.trigNextEdge = 'rising'
% SI.hScan2D.trigNextInTerm = ''
% SI.hScan2D.trigNextStopEnable = true
% SI.hScan2D.trigStopEdge = 'rising'
% SI.hScan2D.trigStopInTerm = ''
% SI.hScan2D.uniformSampling = false
% SI.hScan2D.useNonlinearResonantFov2VoltsCurve = false
% SI.hStackManager.actualNumSlices = 1
% SI.hStackManager.actualNumVolumes = 1
% SI.hStackManager.actualStackZStepSize = []
% SI.hStackManager.arbitraryZs = [0 1]
% SI.hStackManager.centeredStack = false
% SI.hStackManager.closeShutterBetweenSlices = false
% SI.hStackManager.enable = false
% SI.hStackManager.framesPerSlice = 600
% SI.hStackManager.numFramesPerVolume = 1
% SI.hStackManager.numFramesPerVolumeWithFlyback = 1
% SI.hStackManager.numSlices = 1
% SI.hStackManager.numVolumes = 1
% SI.hStackManager.stackActuator = 'motor'
% SI.hStackManager.stackDefinition = 'uniform'
% SI.hStackManager.stackEndPower = []
% SI.hStackManager.stackFastWaveformType = 'sawtooth'
% SI.hStackManager.stackMode = 'slow'
% SI.hStackManager.stackReturnHome = true
% SI.hStackManager.stackStartPower = []
% SI.hStackManager.stackZEndPos = []
% SI.hStackManager.stackZStartPos = []
% SI.hStackManager.stackZStepSize = 1
% SI.hStackManager.useStartEndPowers = true
% SI.hStackManager.zPowerReference = -668
% SI.hStackManager.zs = -668
% SI.hStackManager.zsRelative = 0
% SI.hUserFunctions.userFunctionsCfg = []
% SI.hUserFunctions.userFunctionsUsr = []
% SI.hWSConnector.communicationTimeout = 5
% SI.hWSConnector.enable = false
% SI.hWaveformManager.optimizedScanners = {}
% SI.imagingSystem = 'ImagingScanner'
% SI.loopAcqInterval = 20
% SI.objectiveResolution = 15
% 
% {
%   "RoiGroups": {
%     "imagingRoiGroup": {
%       "ver": 1,
%       "classname": "scanimage.mroi.RoiGroup",
%       "name": "Default Imaging ROI Group",
%       "UserData": null,
%       "roiUuid": "95D41B7A572384DC",
%       "roiUuiduint64": 1.079628442e+19,
%       "rois": {
%         "ver": 1,
%         "classname": "scanimage.mroi.Roi",
%         "name": "Default Imaging Roi",
%         "UserData": {
%           "imagingSystem": "ImagingScanner",
%           "fillFractionSpatial": 0.9,
%           "forceSquarePixelation": 1,
%           "forceSquarePixels": 1,
%           "scanZoomFactor": 3,
%           "scanAngleShiftFast": 0,
%           "scanAngleMultiplierSlow": 1,
%           "scanAngleShiftSlow": 0,
%           "scanRotation": 0,
%           "pixelsPerLine": 512,
%           "linesPerFrame": 512
%         },
%         "roiUuid": "8C165125F5941F72",
%         "roiUuiduint64": 1.009434484e+19,
%         "zs": 0,
%         "scanfields": {
%           "ver": 1,
%           "classname": "scanimage.mroi.scanfield.fields.RotatedRectangle",
%           "name": "Default Imaging Scanfield",
%           "UserData": null,
%           "roiUuid": "414DE9DBC05309BA",
%           "roiUuiduint64": 4.705674316e+18,
%           "centerXY": [0,0],
%           "sizeXY": [6,6],
%           "rotationDegrees": 0,
%           "enable": 1,
%           "pixelResolutionXY": [512,512],
%           "pixelToRefTransform": [
%             [0.01171875,0,-3.005859375],
%             [0,0.01171875,-3.005859375],
%             [0,0,1]
%           ],
%           "affine": [
%             [6,0,-3],
%             [0,6,-3],
%             [0,0,1]
%           ]
%         },
%         "discretePlaneMode": 0,
%         "powers": null,
%         "pzAdjust": null,
%         "Lzs": null,
%         "interlaceDecimation": null,
%         "interlaceOffset": null,
%         "enable": 1
%       }
%     },
%     "photostimRoiGroups": null,
%     "integrationRoiGroup": {
%       "ver": 1,
%       "classname": "scanimage.mroi.RoiGroup",
%       "name": "",
%       "UserData": null,
%       "roiUuid": "7D61330F2FD6E20D",
%       "roiUuiduint64": 9.034558468e+18,
%       "rois": {
%         "_ArrayType_": "double",
%         "_ArraySize_": [1,0],
%         "_ArrayData_": null
%       }
%     }
%   }
% }



