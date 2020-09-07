package com.qweib.cloud;

import com.qweibframework.commons.Encodes;
import com.wf.captcha.GifCaptcha;
import com.wf.captcha.SpecCaptcha;
import com.wf.captcha.base.Captcha;
import org.junit.Test;

import java.awt.*;
import java.io.FileOutputStream;
import java.io.IOException;

import static com.wf.captcha.base.Captcha.TYPE_ONLY_NUMBER;

/**
 * @author: jimmy.lin
 * @time: 2019/9/26 16:38
 * @description:
 */
public class CaptchaTest {

    @Test
    public void base64(){
        System.out.println(Encodes.encodeBase64URLSafeString("FBBVW0415000668018"));
    }

    @Test
    public void gen() throws IOException, FontFormatException {
        int width = 130, height = 48;


        GifCaptcha captcha = new GifCaptcha(width, height, 4);
        captcha.setFont(Captcha.FONT_1);
        captcha.setCharType(TYPE_ONLY_NUMBER);

        SpecCaptcha c = new SpecCaptcha(width, height, 4);
        c.setFont(Captcha.FONT_1);
        c.setCharType(TYPE_ONLY_NUMBER);


        captcha.out(new FileOutputStream("F:/tmp/captcha.gif"));
        c.out(new FileOutputStream("F:/tmp/captcha.png"));
    }
}
