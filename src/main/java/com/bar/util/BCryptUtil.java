package com.bar.util;

// 需要添加jBCrypt依赖：
// <dependency>
//     <groupId>org.mindrot</groupId>
//     <artifactId>jbcrypt</artifactId>
//     <version>0.4</version>
// </dependency>

public class BCryptUtil {

    /**
     * 加密密码
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("密码不能为空");
        }
        // 使用jBCrypt库加密
        return org.mindrot.jbcrypt.BCrypt.hashpw(plainPassword,
                org.mindrot.jbcrypt.BCrypt.gensalt());
    }

    /**
     * 验证密码
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }

        try {
            // 使用jBCrypt库验证
            return org.mindrot.jbcrypt.BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            // BCrypt.checkpw会在密码不匹配时抛出异常
            return false;
        }
    }

    /**
     * 检查是否是有效的BCrypt哈希
     */
    public static boolean isValidHash(String hash) {
        if (hash == null) return false;

        // BCrypt哈希格式：$2a$[cost]$[22字符盐值][31字符哈希值]
        return hash.matches("^\\$2[aby]\\$\\d{2}\\$[./A-Za-z0-9]{53}$");
    }
}
