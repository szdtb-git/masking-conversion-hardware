import ctypes
import secrets

import numpy as np
import time as tt
from picosdk.ps5000a import ps5000a as ps
import matplotlib.pyplot as plt
from picosdk.functions import adc2mV, assert_pico_ok, mV2adc
import serial 
from tqdm import tqdm, trange

file_number = 993
total = 7000
numEachFile = 1000

K = 24
N = 2
R = 216
T = 100
pl = N*K//8

rl = R//8

# p = 0xd01
p = 0x7fe001
# p = 0xa7496f37


# # Create chandle and status ready for use
chandle = ctypes.c_int16()
status = {}

# Open 5000 series PicoScope
# Resolution set to 12 Bit
resolution = ps.PS5000A_DEVICE_RESOLUTION["PS5000A_DR_12BIT"]
# Returns handle to chandle for use in future API functions
status["openunit"] = ps.ps5000aOpenUnit(ctypes.byref(chandle), None, resolution)

# try:
#     assert_pico_ok(status["openunit"])
# except:  # PicoNotOkError:
powerStatus = status["openunit"]

if powerStatus == 286:
    status["changePowerSourcxe"] = ps.ps5000aChangePowerSource(chandle, powerStatus)
elif powerStatus == 282:
    status["changePowerSource"] = ps.ps5000aChangePowerSource(chandle, powerStatus)
# else:
#     raise


    # assert_pico_ok(status["changePowerSource"])

# Set up channel A
handle = chandle
channel = ps.PS5000A_CHANNEL["PS5000A_CHANNEL_A"]
# enabled = 1
coupling_type = ps.PS5000A_COUPLING["PS5000A_DC"]
chARange = ps.PS5000A_RANGE["PS5000A_2V"]
# analogue offset = 0 V
status["setChA"] = ps.ps5000aSetChannel(chandle, channel, 1, coupling_type, chARange, 0)
assert_pico_ok(status["setChA"])

# Set up channel B
# handle = chandle
channel = ps.PS5000A_CHANNEL["PS5000A_CHANNEL_B"]
# enabled =
# 1
# coupling_type = ps.PS5000A_COUPLING["PS5000A_DC"]
chBRange = ps.PS5000A_RANGE["PS5000A_1V"] #PS5000A_10MV,PS50000A_20MV,PS5000A_50MV,100,200,500, 1V, 2V, 5V,10V,20V,50V
# analogue offset = 0 V
status["setChB"] = ps.ps5000aSetChannel(chandle, channel, 1, coupling_type, chBRange, 0)
assert_pico_ok(status["setChB"])

# find maximum ADC count value
# handle = chandle
# pointer to value = ctypes.byref(maxADC)
maxADC = ctypes.c_int16()
status["maximumValue"] = ps.ps5000aMaximumValue(chandle, ctypes.byref(maxADC))
assert_pico_ok(status["maximumValue"])

# Set up single trigger
# handle = chandle
# enabled = 1
source = ps.PS5000A_CHANNEL["PS5000A_CHANNEL_A"]
threshold = int(mV2adc(1000, chARange, maxADC))
# direction = PS5000A_RISING = 2
# delay = 0 s
# auto Trigger = 1000 ms
status["trigger"] = ps.ps5000aSetSimpleTrigger(chandle, 1, source, threshold, 2, 0, 10000)
assert_pico_ok(status["trigger"])

# Set number of pre and post trigger samples to be collected
preTriggerSamples = 0
postTriggerSamples = 200*T
maxSamples = preTriggerSamples + postTriggerSamples

# Get timebase information
# handle = chandle
timebase = 2
# noSamples = maxSamples
# pointer to timeIntervalNanoseconds = ctypes.byref(timeIntervalns)
# pointer to maxSamples = ctypes.byref(returnedMaxSamples)
# segment index = 0
timeIntervalns = ctypes.c_float()
returnedMaxSamples = ctypes.c_int32()
status["getTimebase2"] = ps.ps5000aGetTimebase2(chandle, timebase, maxSamples, ctypes.byref(timeIntervalns),
                                                ctypes.byref(returnedMaxSamples), 0)
assert_pico_ok(status["getTimebase2"])

portx = "COM8"

# arr = np.empty((10,))
bps = 115200

timex = 10

ser = serial.Serial(portx, bps, timeout=timex)
ser.flushInput()  


# total / numEachFile is the total number of files
for alun in range(0, total // numEachFile):
    fl = open("E:/A2Bp_Dilithium/data/testdata{0}.txt".format(alun+file_number), "w")
    # ou=np.empty(176,int).astype(np.uint8)
    plain = np.empty(pl*T, int).astype(np.uint8)
    prd = np.empty(rl*T, int).astype(np.uint8)

    counter = 0

    # arr = np.empty((0, preTriggerSamples + postTriggerSamples), float)
    # arr_tr = np.empty((0, preTriggerSamples + postTriggerSamples), float)
    arr = np.zeros((numEachFile, postTriggerSamples), dtype=np.float32)
    arr_tr = np.zeros((numEachFile, postTriggerSamples), dtype=np.float32)

    zero = '0' + hex(0).replace('0x', '').upper()
    zero = bytes.fromhex(zero)

    for j in trange(0, numEachFile):
        # Run block capture
        # handle = chandle
        # number of pre-trigger samples = preTriggerSamples
        # number of post-trigger samples = PostTriggerSamples
        # timebase = 8 = 80 ns (see Programmer's guide for mre information on timebases)
        # time indisposed ms = None (not needed in the example)
        # segment index = 0
        # lpReady = None (using ps5000aIsReady rather than ps5000aBlockReady)
        # pParameter = None
        status["runBlock"] = ps.ps5000aRunBlock(chandle, preTriggerSamples, postTriggerSamples, timebase, None, 0, None,
                                                None)
        assert_pico_ok(status["runBlock"])


        for k in range(T):
            ser.flushInput() 
            counter = np.random.randint(0, 2)
            if counter % 2 == 0:
                a0 = secrets.randbelow(p)
                a1 = (0x211985 - a0) % p
                a = (a0 << 23) + a1
                plain[6*k+0] = a & 255
                plain[6*k+1] = (a >> 8) & 255
                plain[6*k+2] = (a >> 16) & 255
                plain[6*k+3] = (a >> 24) & 255
                plain[6*k+4] = (a >> 32) & 255
                plain[6*k+5] = (a >> 40)
                fl.write("input0：")
            else:
                a0 = secrets.randbelow(p)
                a1 = secrets.randbelow(p)
                a = (a0 << 23) + a1
                plain[6*k+0] = a & 255
                plain[6*k+1] = (a >> 8) & 255
                plain[6*k+2] = (a >> 16) & 255
                plain[6*k+3] = (a >> 24) & 255
                plain[6*k+4] = (a >> 32) & 255
                plain[6*k+5] = (a >> 40)
                fl.write("input1：")

            for i in range(pl):
                ranaa = hex(plain[6*k+i]).replace('0x', '').zfill(2)
                fl.write(ranaa)
                fl.write(" ")

            fl.write("\n")
            fl.write("output：")
            fl.write("\n")

        for i in range(rl*T):
            prd[i] = np.random.randint(0, 256)
            # prd[i] = 0

        # for i in range(rl*T):
        #     ranaa = hex(prd[i]).replace('0x', '').zfill(2)
        #     fl.write(ranaa)
        #     fl.write(" ")

        ser.write(bytes(plain))
        ser.write(bytes(prd))



        # Check for data collection to finish using ps5000aIsReady
        ready = ctypes.c_int16(0)
        check = ctypes.c_int16(0)
        while ready.value == check.value:
            status["isReady"] = ps.ps5000aIsReady(chandle, ctypes.byref(ready))

        # Create buffers ready for assigning pointers for data collection
        bufferAMax = (ctypes.c_int16 * maxSamples)()
        bufferAMin = (ctypes.c_int16 * maxSamples)()  # used for downsampling which isn't in the scope of this example
        bufferBMax = (ctypes.c_int16 * maxSamples)()
        bufferBMin = (ctypes.c_int16 * maxSamples)()  # used for downsampling which isn't in the scope of this example

        # Set data buffer location for data collection from channel A
        # handle = chandle
        source = ps.PS5000A_CHANNEL["PS5000A_CHANNEL_A"]
        # pointer to buffer max = ctypes.byref(bufferAMax)
        # pointer to buffer min = ctypes.byref(bufferAMin)
        # buffer length = maxSamples
        # segment index = 0
        # ratio mode = PS5000A_RATIO_MODE_NONE = 0
        status["setDataBuffersA"] = ps.ps5000aSetDataBuffers(chandle, source, ctypes.byref(bufferAMax),
                                                             ctypes.byref(bufferAMin), maxSamples, 0, 0)
        assert_pico_ok(status["setDataBuffersA"])

        # Set data buffer location for data collection from channel B
        # handle = chandle
        source = ps.PS5000A_CHANNEL["PS5000A_CHANNEL_B"]
        # pointer to buffer max = ctypes.byref(bufferBMax)
        # pointer to buffer min = ctypes.byref(bufferBMin)
        # buffer length = maxSamples
        # segment index = 0
        # ratio mode = PS5000A_RATIO_MODE_NONE = 0
        status["setDataBuffersB"] = ps.ps5000aSetDataBuffers(chandle, source, ctypes.byref(bufferBMax),
                                                             ctypes.byref(bufferBMin), maxSamples, 0, 0)
        assert_pico_ok(status["setDataBuffersB"])

        # create overflow loaction
        overflow = ctypes.c_int16()
        # create converted type maxSamples
        cmaxSamples = ctypes.c_int32(maxSamples)

        # Retried data from scope to buffers assigned above
        # handle = chandle
        # start index = 0
        # pointer to number of samples = ctypes.byref(cmaxSamples)
        # downsample ratio = 0
        # downsample ratio mode = PS5000A_RATIO_MODE_NONE
        # pointer to overflow = ctypes.byref(overflow))
        status["getValues"] = ps.ps5000aGetValues(chandle, 0, ctypes.byref(cmaxSamples), 0, 0, 0,
                                                  ctypes.byref(overflow))
        assert_pico_ok(status["getValues"])

        # convert ADC counts data to mV
        adc2mVChAMax = adc2mV(bufferAMax, chARange, maxADC)
        adc2mVChBMax = adc2mV(bufferBMax, chBRange, maxADC)

        newArray = np.array(adc2mVChBMax)
        newArray_TR = np.array(adc2mVChAMax)

        newArray_2d = np.reshape(newArray, (1, preTriggerSamples + postTriggerSamples))
        newArray_2d_TR = np.reshape(newArray_TR, (1, preTriggerSamples + postTriggerSamples))


        # Create time data
        time = np.linspace(0, (cmaxSamples.value - 1) * timeIntervalns.value, cmaxSamples.value)

        # plot data from channel A and B
        # plt.plot(time, adc2mVChAMax[:])
        # plt.plot(time, adc2mVChBMax[:])
        # plt.xlabel('Time (ns)')
        # plt.ylabel('Voltage (mV)')
        # plt.show()
        # arr = np.append(arr, newArray_2d, axis=0)
        # arr_tr = np.append(arr_tr, newArray_2d_TR, axis=0)
        arr[j] = newArray_2d
        arr_tr[j] = newArray_2d_TR

        # print(np.shape(newArray))
        # print(np.shape(newArray_2d))
        # print(np.shape(arr[j]))
        # print(newArray_2d)
        # print(arr[j])
        # print(arr)
        # arr = np.vstack((arr, newArray))

        # fl.write("输出：")
        # fl.write(" ")
        #
        # getBytes=b''
        count = ser.inWaiting()  
        while count != pl*T:
            count = ser.inWaiting()
        getBytes = ser.read(count) 
        ser.flushInput()
        ser.flushOutput()

        # readresult = ''
        # hLen = len(getBytes)
        # for i in range(hLen):
        #     hvol = getBytes[i]
        #     hhex = '%02x' % hvol
        #     readresult += hhex + ' '
        # fl.write(readresult)
        # fl.write(" ")
        # fl.write("\n")

    # np.save(r'E:/trace/arr.npy',arr)
    np.save(r'E:/A2Bp_Dilithium/chufa/arrPart{0}.npy'.format(alun+file_number), arr)
    # np.save(r'E:/A2B/LUT_A2Bp_Dilithium/chufa/arr_trigger_Part{0}.npy'.format(alun+file_number), arr_tr)
    fl.close()
    del arr
    del arr_tr

ser.close()  
# Stop the scope
# handle = chandle
status["stop"] = ps.ps5000aStop(chandle)
assert_pico_ok(status["stop"])

# Close unit Disconnect the scope
# handle = chandle
status["close"] = ps.ps5000aCloseUnit(chandle)
assert_pico_ok(status["close"])

# display status returns
print(status)