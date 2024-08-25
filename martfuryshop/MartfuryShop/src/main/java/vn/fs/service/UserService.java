package vn.fs.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import vn.fs.entity.User;
import vn.fs.repository.UserRepository;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Random;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JavaMailSender mailSender;
    private final Map<String, OtpInfo> otpStorage; 

    @Autowired
    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder, JavaMailSender mailSender) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.mailSender = mailSender;
        this.otpStorage = new HashMap<>();
    }

    public void sendOTP(String email) {
        Optional<User> user = userRepository.findByEmail(email);
        if (user == null) {
            throw new RuntimeException("Không tìm thấy người dùng với email: " + email);
        }

        // Tạo mã OTP ngẫu nhiên
        String otp = generateOTP();
        LocalDateTime expirationTime = LocalDateTime.now().plusMinutes(15); // Thời gian hết hạn 15 phút

        // Lưu vào lưu trữ tạm thời
        otpStorage.put(email, new OtpInfo(otp, expirationTime));

        // Gửi mã OTP đến email của người dùng
        sendOTPViaEmail(email, otp);
    }

    public boolean verifyOTP(String email, String enteredOTP) {
        OtpInfo otpInfo = otpStorage.get(email);
        if (otpInfo != null && otpInfo.getOtp().equals(enteredOTP) && LocalDateTime.now().isBefore(otpInfo.getExpirationTime())) {
            // Xóa OTP sau khi xác thực thành công
            otpStorage.remove(email);
            return true;
        }
        return false;
    }

    @Transactional
    public void resetPassword(String email, String newPassword) {
        User user = userRepository.findEmail(email);
        if (user == null) {
            throw new RuntimeException("Không tìm thấy người dùng với email: " + email);
        }

        // Mã hóa mật khẩu mới
        String encodedPassword = passwordEncoder.encode(newPassword);
        user.setPassword(encodedPassword);

        // Lưu lại vào cơ sở dữ liệu
        userRepository.save(user);
    }

    private String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000); // Mã OTP gồm 6 chữ số
        return String.valueOf(otp);
    }

    private void sendOTPViaEmail(String email, String otp) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email);
        message.setSubject("Xác thực OTP cho việc đặt lại mật khẩu");
        message.setText("Mã OTP của bạn là: " + otp);

        try {
            mailSender.send(message);
        } catch (MailException e) {
            throw new RuntimeException("Không thể gửi email xác thực OTP: " + e.getMessage());
        }
    }

    private static class OtpInfo {
        private String otp;
        private LocalDateTime expirationTime;

        public OtpInfo(String otp, LocalDateTime expirationTime) {
            this.otp = otp;
            this.expirationTime = expirationTime;
        }

        public String getOtp() {
            return otp;
        }

        public LocalDateTime getExpirationTime() {
            return expirationTime;
        }
    }
}
