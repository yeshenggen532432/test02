package com.qweib.cloud;

import com.qweib.cloud.utils.DistanceUtil;
import org.junit.Test;

public class DisTest {

    @Test
    public void getDis(){
        Double lat1 = 24.466568;
        Double lng1 = 118.092652;

        Double lat2 = 24.4673;
        Double lng2 = 118.080786;

        DistanceUtil.getDistanceFromTwoPoints(lat1, lng1, lat2, lng2);
    }
}
