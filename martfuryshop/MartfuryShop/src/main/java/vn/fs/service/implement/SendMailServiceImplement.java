package vn.fs.service.implement;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import vn.fs.dto.MailInfo;
import vn.fs.service.SendMailService;

@Service
public class SendMailServiceImplement implements SendMailService {

	@Autowired
	JavaMailSender sender;
	  @Autowired
	    private JavaMailSender mailSender;

	    @Value("${spring.mail.username}")
	    private String fromEmail;
	    
	List<MailInfo> list = new ArrayList<>();

	@Override
	public void send(MailInfo mail) throws MessagingException, IOException {
		// Tạo message
		MimeMessage message = sender.createMimeMessage();
		// Sử dụng Helper để thiết lập các thông tin cần thiết cho message
		MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");
		helper.setFrom(mail.getFrom());
		helper.setTo(mail.getTo());
		helper.setSubject(mail.getSubject());
		helper.setText(mail.getBody(), true);
		helper.setReplyTo(mail.getFrom());

		if (mail.getAttachments() != null) {
			FileSystemResource file = new FileSystemResource(new File(mail.getAttachments()));
			helper.addAttachment(mail.getAttachments(), file);
		}

		// Gửi message đến SMTP server
		sender.send(message);

	}

	@Override
	public void queue(MailInfo mail) {
		list.add(mail);
	}

	@Override
	public void queue(String to, String subject, String body) {
		queue(new MailInfo(to, subject, body));
	}

	@Override
	@Scheduled(fixedDelay = 5000)
	public void run() {
		while (!list.isEmpty()) {
			MailInfo mail = list.remove(0);
			try {
				this.send(mail);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	@Override
	public void sendBanNotification(String toEmail){
		  SimpleMailMessage message = new SimpleMailMessage();
	        message.setFrom(fromEmail);
	        message.setTo(toEmail);
	        message.setSubject("Thông báo tài khoản bị band");
	        message.setText("Tài khoản của bạn đã bị band với lý do boom hàng quá nhiều. Vui lòng liên hệ với chúng tôi để biết thêm chi tiết.");

	        mailSender.send(message);
	    }
		

}
