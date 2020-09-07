package com.qweib.cloud.biz.system;

import com.qweib.cloud.core.domain.TheSender;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import java.util.Properties;

public class Mail {
    /**
     * 向用户发送邮件
     */
    private static final long serialVersionUID = 1L;

    private MimeMessage mimeMsg; // MIME邮件对象

    private Session session; // 邮件会话对象

    private Properties props; // 系统属性

    private String username = ""; // smtp认证用户名和密码

    private String password = "";

    private Multipart mp; // Multipart对象,邮件内容,标题,附件等内容均添加到其中后再生成

    public Mail() {

    }

    public Mail(String smtp) {
        setSmtpHost(smtp);
        createMimeMessage();
    }

    private void setSmtpHost(String hostName) {
//        System.out.println("设置系统属性：mail.smtp.host = " + hostName);
        if (props == null)
            props = System.getProperties(); // 获得系统属性对象
        props.put("mail.smtp.host", hostName); // 设置SMTP主机
        props.put("mail.smtp.port", "25");//
        props.put("mail.smtp.auth", "true");
    }

    private boolean createMimeMessage() {
        try {
            session = Session.getDefaultInstance(props, null); // 获得邮件会话对象
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("获取邮件会话对象时发生错误！" + e.getMessage());
            return false;
        }
        try {
            mimeMsg = new MimeMessage(session); // 创建MIME邮件对象
            mp = new MimeMultipart(); // mp 一个multipart对象
            // Multipart is a container that holds multiple body parts.
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("创建MIME邮件对象失败！" + e.getMessage());
            return false;
        }
    }

    private void setNeedAuth(boolean need) {
        if (props == null)
            props = System.getProperties();
        if (need) {
            props.put("mail.smtp.auth", "true");
        } else {
            props.put("mail.smtp.auth", "false");
        }
    }

    private void setNamePass(String name, String pass) {
        username = name;
        password = pass;
    }

    private boolean setSubject(String mailSubject) {
        try {
            mimeMsg.setSubject(mailSubject);
            return true;
        } catch (Exception e) {
            System.err.println("设置邮件主题发生错误！");
            return false;
        }
    }

    private boolean setBody(String mailBody) {
        try {
            BodyPart bp = new MimeBodyPart();
            // 转换成中文格式
            bp.setContent(
                    "<meta http-equiv=Content-Type content=text/html; charset=gb2312>"
                            + mailBody, "text/html;charset=GB2312");
            mp.addBodyPart(bp);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("设置邮件正文时发生错误！" + e.getMessage());
            return false;
        }
    }

    private boolean setFrom(String from) {
        try {
            String nick = javax.mail.internet.MimeUtility.encodeText("驰用T3");
            mimeMsg.setFrom(new InternetAddress(nick + "<" + from + ">")); // 设置发信人
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * private boolean setTo(String to) {
     * if (to == null)
     * return false;
     * try {
     * mimeMsg.setRecipients(Message.RecipientType.TO, InternetAddress
     * .parse(to));
     * return true;
     * } catch (Exception e) {
     * return false;
     * }
     * }
     */
    public boolean setTo(String[] tos) {
//        System.out.println("设置收信人");
        if (tos == null)
            return false;
        try {
            InternetAddress[] address = new InternetAddress[tos.length];
            for (int i = 0; i < tos.length; i++) {
                address[i] = new InternetAddress(tos[i]);
            }
            mimeMsg.setRecipients(Message.RecipientType.TO, address);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private boolean setCopyTo(String copyto) {
        if (copyto == null)
            return false;
        try {
            mimeMsg.setRecipients(Message.RecipientType.CC,
                    (Address[]) InternetAddress.parse(copyto));
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private boolean sendout() {
        try {
            mimeMsg.setContent(mp);
            mimeMsg.saveChanges();
//            System.out.println("正在发送邮件....");
            Session mailSession = Session.getInstance(props, null);
            Transport transport = mailSession.getTransport("smtp");
            transport.connect((String) props.get("mail.smtp.host"), username, password);
            transport.sendMessage(mimeMsg, mimeMsg
                    .getRecipients(Message.RecipientType.TO));
            // transport.send(mimeMsg);
//            System.out.println("发送邮件成功！");
            transport.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
//            System.err.println("邮件发送失败！", e);
            return false;
        }
    }

    public boolean sendMail(String[] string, String msg, String titile) {
        TheSender email = TokenServer.getEmail();
        Mail themail = new Mail(email.getSmtp());
        themail.setNeedAuth(true);
        if (themail.setSubject(titile) == false)
            return false;
        String mailbody = msg;
        if (themail.setBody(mailbody) == false)
            return false;
        // 收件人邮箱
        if (themail.setTo(string) == false)
            return false;
        // 发件人邮箱
        if (themail.setFrom(email.getEmails()) == false)
            return false;
        themail.setNamePass(email.getEmails(), email.getPwd()); // 用户名与密码,即您选择一个自己的电邮
        return themail.sendout();
    }

    public static void main(String[] args) {
        String[] string = new String[]{"57812027@qq.com"};
        new Mail().sendMail(string, "4564654654654", "测试");
    }
}	 
