package com.computerstore.services;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.UnsupportedEncodingException;
import java.util.Properties;
import java.util.Date;

public class EmailService {
    private final String host;
    private final int port;
    private final String username;
    private final String password;
    private final String fromEmail;
    private final String fromName;
    private final boolean auth;
    private final boolean starttls;

    public EmailService() {
        // Default config - override via setters or properties file
        this.host = "smtp.gmail.com";
        this.port = 587;
        this.username = System.getenv("MAIL_USERNAME");
        this.password = System.getenv("MAIL_PASSWORD");
        this.fromEmail = System.getenv("MAIL_FROM_EMAIL");
        this.fromName = "Computer Store System";
        this.auth = true;
        this.starttls = true;
    }

    public EmailService(String host, int port, String username, String password,
            String fromEmail, String fromName, boolean auth, boolean starttls) {
        this.host = host;
        this.port = port;
        this.username = username;
        this.password = password;
        this.fromEmail = fromEmail;
        this.fromName = fromName;
        this.auth = auth;
        this.starttls = starttls;
    }

    public void sendHtmlEmail(String to, String subject, String htmlContent) throws MessagingException {
        sendEmail(to, subject, htmlContent, true);
    }

    public void sendTextEmail(String to, String subject, String textContent) throws MessagingException {
        sendEmail(to, subject, textContent, false);
    }

    private void sendEmail(String to, String subject, String content, boolean isHtml)
            throws MessagingException {
        if (username == null || password == null || fromEmail == null) {
            throw new IllegalStateException(
                    "Email configuration not set. Please configure MAIL_USERNAME, MAIL_PASSWORD, MAIL_FROM_EMAIL environment variables.");
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", auth);
        props.put("mail.smtp.starttls.enable", starttls);
        props.put("mail.smtp.ssl.trust", host);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        Message message = new MimeMessage(session);
        try {
            message.setFrom(new InternetAddress(fromEmail, fromName, "UTF-8"));
        } catch (UnsupportedEncodingException e) {
            // Fallback without name encoding
            message.setFrom(new InternetAddress(fromEmail));
        }
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setSentDate(new Date());

        if (isHtml) {
            message.setContent(content, "text/html; charset=UTF-8");
        } else {
            message.setContent(content, "text/plain; charset=UTF-8");
        }

        Transport.send(message);
    }

    // Getters for configuration
    public String getHost() {
        return host;
    }

    public int getPort() {
        return port;
    }

    public String getUsername() {
        return username;
    }

    public String getFromEmail() {
        return fromEmail;
    }

    public String getFromName() {
        return fromName;
    }
}
