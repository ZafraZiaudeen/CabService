package com.cabservice.util;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.IOException;
import java.util.Properties;

public class EmailUtil {
    private static final Properties emailProps = new Properties();
    private static final String FROM_EMAIL;
    private static final String PASSWORD;
    private static final String HOST;
    private static final String PORT;

    static {
        try {
            // Load properties from application.properties in src/main/resources
            emailProps.load(EmailUtil.class.getClassLoader().getResourceAsStream("application.properties"));
            FROM_EMAIL = emailProps.getProperty("email.username");
            PASSWORD = emailProps.getProperty("email.password");
            HOST = emailProps.getProperty("email.host");
            PORT = emailProps.getProperty("email.port");

            if (FROM_EMAIL == null || PASSWORD == null || HOST == null || PORT == null) {
                throw new IllegalStateException("Email configuration is missing in application.properties.");
            }
        } catch (IOException e) {
            throw new RuntimeException("Failed to load application.properties: " + e.getMessage());
        }
    }

    // Existing method for verification emails
    public static void sendVerificationEmail(String toEmail, String token) {
        String subject = "Verify Your Email";
        String verificationLink = "http://localhost:8080/cabservice/user?action=verify&token=" + token;
        String body = "Please click the following link to verify your email: " + verificationLink;
        sendEmail(toEmail, subject, body);
    }

    // New general method for sending emails
    public static void sendEmail(String toEmail, String subject, String body) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
            System.out.println("Email sent to: " + toEmail);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send email: " + e.getMessage());
        }
    }
}