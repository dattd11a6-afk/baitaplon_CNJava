package com.fruitfarmermarket.utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtil {
    // THAY BẰNG EMAIL VÀ MẬT KHẨU ỨNG DỤNG CỦA ÔNG
    private static final String EMAIL = "phatdat190505@gmail.com";
    private static final String APP_PASSWORD = "ksqb gwif suqg vwhy";

    public static boolean sendOTP(String toEmail, String otpCode) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL, APP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL, "Fruit Farmer Market"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã OTP Khôi phục mật khẩu");

            String htmlContent = "<h2 style='color:#2F6B3F;'>Fruit Farmer Market</h2>"
                    + "<p>Mã xác nhận (OTP) của bạn là: <b style='font-size:24px; color:#D35400;'>" + otpCode + "</b></p>"
                    + "<p>Mã này có hiệu lực trong 5 phút. Vui lòng không chia sẻ mã này cho bất kỳ ai.</p>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}