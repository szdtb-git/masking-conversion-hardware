#!/usr/bin/env python
# -*- coding: UTF-8 -*-
'''
@Project ：sca
@File    ：suiqian.py.py
@Author  ：suyang
@Date    ：2022/5/6 16:06
'''
import matplotlib.pyplot as plt
import numpy as np
from tqdm import tqdm, trange


np.seterr(divide='ignore', invalid='ignore')
FILE_NUMBER = 900
BEGIN_FILE_INDEX = 92
T = 100

t_test_file = "E:/A2Bp_Dilithium/result_ttest.py"
file_url = "E:/A2Bp_Dilithium/"
trace_file_name = "arrPart"


def update_mean_and_var(old_mean, old_var, old_count, value):
    # value = np.square(value)
    new_mean = old_mean + (value - old_mean) / (old_count + 1)
    new_var = old_var + ((value - old_mean) * (value - new_mean) - old_var) / (
            old_count + 1)
    return new_mean, new_var


def t_test():
    arr = np.load(file_url + "chufa/" + trace_file_name + r"{0}.npy".format(BEGIN_FILE_INDEX))
    trace_numbers, sample_numbers = arr.shape

    print(trace_numbers, sample_numbers)

    old_mean_fix = np.zeros(100)
    old_var_fix = np.zeros(100)
    old_mean_rnd = np.zeros(100)
    old_var_rnd = np.zeros(100)

    fix_count = 0
    rnd_count = 0

    for j in trange(BEGIN_FILE_INDEX, BEGIN_FILE_INDEX + FILE_NUMBER):
        arr = np.load(file_url + "chufa/" + trace_file_name + r"{0}.npy".format(j))

        f = open(file_url + "data/testdata{0}.txt".format(j), "r")
        for i in range(trace_numbers):
            for k in range(T):
                str = f.readline()
                f.readline()
                if str[2] == "0":
                    new_mean, new_var = update_mean_and_var(old_mean_fix, old_var_fix, fix_count, arr[i][k*200: k*200+100])
                    fix_count += 1
                    old_mean_fix = new_mean
                    old_var_fix = new_var
                else:
                    new_mean, new_var = update_mean_and_var(old_mean_rnd, old_var_rnd, rnd_count, arr[i][k*200: k*200+100])
                    rnd_count += 1
                    old_mean_rnd = new_mean
                    old_var_rnd = new_var
            # end if
        # end for
        f.close()
    # end for

    temp1 = old_mean_fix - old_mean_rnd
    temp2 = (old_var_fix / fix_count) + (old_var_rnd / rnd_count)
    test_result = temp1 / np.sqrt(temp2)

    print(fix_count, rnd_count)
    return test_result


def t_test_function():
    plt.rcParams['figure.figsize'] = (16.0, 9.0)  
    f, ax = plt.subplots(1, 1)  
    # ax.set_title('ttest_traces')   
    ax.set_xlabel("Samples", fontsize=35)
    ax.set_ylabel("t-value", fontsize=35)
    plt.xticks(fontsize=25)
    plt.yticks(fontsize=25)
    ax.axhline(y=4.5, ls='--', c='red', linewidth=2)
    ax.axhline(y=-4.5, ls='--', c='red', linewidth=2)

    result = t_test()
    np.save(t_test_file, result)
    ax.plot(result)
    plt.show()


if __name__ == '__main__':
    t_test_function()
