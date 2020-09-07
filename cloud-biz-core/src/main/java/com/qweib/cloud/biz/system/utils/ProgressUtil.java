package com.qweib.cloud.biz.system.utils;

/**
 * 进度条工具类
 */
public class ProgressUtil {

    private double molecule;//分子
    private int start;//开始位置

    /**
     * @param goal 目标大小
     * @param size 共需要处理数据大小
     */
    public ProgressUtil(int goal, int size) {
        //if (goal > size) goal = size;
        this.molecule = Double.valueOf(goal) / Double.valueOf(size);
    }

    /**
     * @param start 起点
     * @param goal  目标大小
     * @param size  共需要处理数据大小
     */
    public ProgressUtil(int start, int goal, int size) {
        //if (goal > size) goal = size;
        goal = goal - start;
        this.start = start;
        this.molecule = Double.valueOf(goal) / Double.valueOf(size);
    }


    /**
     * 获取当前所处位置
     *
     * @param position
     * @return
     */
    public int getCurrentRaised(int position) {
        return Double.valueOf(this.start + this.molecule * position).intValue();
    }
}
