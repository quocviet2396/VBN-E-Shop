package vn.fs.api;

import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import vn.fs.repository.UserRepository;
import vn.fs.service.UserService;

@RestController

public class ForgotPasswordFlutter {
	 
	@Autowired
	UserRepository userRepository;
	
	private final UserService userService;

    @Autowired
    public ForgotPasswordFlutter(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/forgot")
    public ResponseEntity<String> forgotPassword(@RequestParam("email") String email) {
        try {
        	if (!userRepository.existsByEmail(email)) {
        		 
        		  return ResponseEntity.notFound().build();
        	}
        	 userService.sendOTP(email);
        	
        	return ResponseEntity.ok("Mã OTP đã được gửi đến email của bạn.");
          
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/reset")
    public ResponseEntity<String> resetPassword(@RequestParam("email") String email,
                                                @RequestParam("otp") String otp,
                                                @RequestParam("newPassword") String newPassword) {
        try {
            // Xác thực mã OTP
            if (userService.verifyOTP(email, otp)) {
                // Đặt lại mật khẩu
                userService.resetPassword(email, newPassword);
                return ResponseEntity.ok("Mật khẩu đã được đặt lại thành công.");
            } else {
                return ResponseEntity.badRequest().body("Mã OTP không hợp lệ hoặc đã hết hạn.");
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
