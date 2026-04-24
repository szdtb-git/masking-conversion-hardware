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

# 更新均
def update_mean_and_var(old_mean, old_var, old_count, value):
    # value = np.square(value)
    new_mean = old_mean + (value - old_mean) / (old_count + 1)
    new_var = old_var + ((value - old_mean) * (value - new_mean) - old_var) / (
            old_count + 1)
    return new_mean, new_var


# 间或计算
def t_test():
    arr = np.load(file_url + "chufa/" + trace_file_name + r"{0}.npy".format(BEGIN_FILE_INDEX))
    trace_numbers, sample_numbers = arr.shape

    print(trace_numbers, sample_numbers)

    # 初始化数组和计数器
    old_mean_fix = np.zeros(100)
    old_var_fix = np.zeros(100)
    old_mean_rnd = np.zeros(100)
    old_var_rnd = np.zeros(100)

    fix_count = 0
    rnd_count = 0

    # 间或计算采样点集的均值和方差，总样本数为 file_numbers*trace_numbers
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

    # 计算t_test
    temp1 = old_mean_fix - old_mean_rnd
    temp2 = (old_var_fix / fix_count) + (old_var_rnd / rnd_count)
    test_result = temp1 / np.sqrt(temp2)

    print(fix_count, rnd_count)
    return test_result


def t_test_function():
    plt.rcParams['figure.figsize'] = (16.0, 9.0)  # 设置画布尺寸
    f, ax = plt.subplots(1, 1)  # 划分子图，返回画布和子图片集，用ax[n,c]获取相对位置的子图
    # ax.set_title('ttest_traces')    # 设置图片名称
    # 设置横纵坐标名称
    ax.set_xlabel("Samples", fontsize=35)
    ax.set_ylabel("t-value", fontsize=35)
    plt.xticks(fontsize=25)
    plt.yticks(fontsize=25)
    # 绘制平行于x轴的水平参考线(坐标，风格，颜色，线条宽度)，绘制垂直参考线用axvline
    ax.axhline(y=4.5, ls='--', c='red', linewidth=2)
    ax.axhline(y=-4.5, ls='--', c='red', linewidth=2)

    result = t_test()
    np.save(t_test_file, result)
    ax.plot(result)
    plt.show()


if __name__ == '__main__':
    t_test_function()
