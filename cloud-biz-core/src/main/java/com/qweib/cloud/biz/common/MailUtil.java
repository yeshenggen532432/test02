package com.qweib.cloud.biz.common;

import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Properties;
import java.util.concurrent.Callable;
import java.util.concurrent.Future;

/**
 * 邮件发送工具类
 */
@Slf4j
public class MailUtil {
    private static final String MAIL_SMTP = MailConfig.mailSmtp;
    private static final Integer PORT = MailConfig.port;
    private static final String MAIL_USERNAME = MailConfig.mailUsername;
    private static final String MAIL_PASSWORD = MailConfig.mailPassword;
    private static final String MAIL_FORM = MailConfig.mailForm;
    private static final Integer timeout = MailConfig.timeout;
    private static final String MAIL_FORM_NAME = MailConfig.mailFormName;
    private static JavaMailSenderImpl mailSender = createMailSender();

    /**
     * 邮件发送器
     *
     * @return 配置好的工具
     */
    private static JavaMailSenderImpl createMailSender() {
        JavaMailSenderImpl sender = new JavaMailSenderImpl();
        sender.setHost(MAIL_SMTP);
        sender.setPort(PORT);
        sender.setUsername(MAIL_USERNAME);
        sender.setPassword(MAIL_PASSWORD);
        sender.setDefaultEncoding("Utf-8");
        Properties p = new Properties();
        p.setProperty("mail.smtp.timeout", timeout + "");
        p.setProperty("mail.smtp.auth", "true");
        sender.setJavaMailProperties(p);
        return sender;
    }


    /**
     * 发送邮件
     *
     * @param to      接受人
     * @param subject 主题
     * @param html    发送内容
     * @throws MessagingException           异常
     * @throws UnsupportedEncodingException 异常
     */
    public static void sendMail(String to, String subject, String html) throws Exception {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        // 设置utf-8或GBK编码，否则邮件会有乱码
        MimeMessageHelper messageHelper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
        messageHelper.setFrom(MAIL_FORM, MAIL_FORM_NAME);
        messageHelper.setTo(to);
        messageHelper.setSubject(subject);
        messageHelper.setText(html, false);
        //mailSender.send(mimeMessage);
        Future<Boolean> future = SysThreadPool.threadPool.submit(new MailThread(mailSender, mimeMessage));
    }

    /**
     * 发送邮件
     *
     * @param to      收件人列表，以","分割
     * @param subject 标题
     * @param body    内容
     */
    public static boolean sendMails(String to, String subject, String body) {
        try {
            if (to == null || to.trim().length() == 0) {
                log.error("收件为人空");
                return false;
            }
            // 参数修饰
            if (body == null) {
                body = "";
            }
            if (subject == null) {
                subject = "无主题";
            }
            String[] arr = to.split(",");
            MimeMessage msg = mailSender.createMimeMessage();
            msg.setFrom(new InternetAddress(MAIL_FORM_NAME + "<" + MAIL_FORM + ">"));
            // 创建收件人列表
            InternetAddress[] address = new InternetAddress[arr.length];
            for (int i = 0; i < arr.length; i++) {
                address[i] = new InternetAddress(arr[i]);
            }
            msg.addRecipients(Message.RecipientType.TO, address);
            msg.setSubject(subject);
            // 设置邮件正文
            msg.setText(body);
            // 设置信件头的发送日期
            msg.setSentDate(new Date());
            msg.saveChanges();
            // 发送信件
                /*Transport transport = msg.getSession().getTransport();
                transport.connect(MAIL_SMTP, MAIL_USERNAME, MAIL_PASSWORD);
                transport.sendMessage(msg,
                        msg.getRecipients(Message.RecipientType.TO));
                transport.close();*/
            SysThreadPool.threadPool.submit(new MailTransportThread(msg));
            return true;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }


    /**
     * 使用线程发送
     */
    public static class MailThread implements Callable<Boolean> {
        private JavaMailSenderImpl mailSender;
        private MimeMessage mimeMessage;

        public MailThread(JavaMailSenderImpl mailSender, MimeMessage mimeMessage) {
            this.mimeMessage = mimeMessage;
            this.mailSender = mailSender;
        }


        @Override
        public Boolean call() {
            try {
                mailSender.send(mimeMessage);
                return true;
            } catch (Exception ex) {
                ex.printStackTrace();
                return false;
            }
        }
    }

    /**
     * 使用线程发送
     */
    public static class MailTransportThread implements Callable<Boolean> {
        private MimeMessage mimeMessage;

        public MailTransportThread(MimeMessage mimeMessage) {
            this.mimeMessage = mimeMessage;
        }

        @Override
        public Boolean call() {
            Transport transport = null;
            try {
                // 发送信件
                transport = mimeMessage.getSession().getTransport();
                transport.connect(MAIL_SMTP, MAIL_USERNAME, MAIL_PASSWORD);
                transport.sendMessage(mimeMessage,
                        mimeMessage.getRecipients(Message.RecipientType.TO));

                return true;
            } catch (Exception ex) {
                //ex.printStackTrace();
                log.error("邮件发送出现错误", ex);
            } finally {
                if (transport != null) {
                    try {
                        transport.close();
                    } catch (MessagingException e) {
                        e.printStackTrace();
                    }
                }
            }
            return false;
        }
    }
}

