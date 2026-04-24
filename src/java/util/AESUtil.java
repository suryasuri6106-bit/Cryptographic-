////package util;
////
////import javax.crypto.*;
////import javax.crypto.spec.SecretKeySpec;
////import java.util.Base64;
////
////public class AESUtil {
////
////    private static final String SECRET_KEY = "1234567890abcdef"; // 16 chars = 128-bit
////
////    public static byte[] encrypt(byte[] data) throws Exception {
////        SecretKeySpec key = new SecretKeySpec(SECRET_KEY.getBytes(), "AES");
////        Cipher cipher = Cipher.getInstance("AES");
////        cipher.init(Cipher.ENCRYPT_MODE, key);
////        return cipher.doFinal(data);
////    }
////
////    public static byte[] decrypt(byte[] encryptedData) throws Exception {
////        SecretKeySpec key = new SecretKeySpec(SECRET_KEY.getBytes(), "AES");
////        Cipher cipher = Cipher.getInstance("AES");
////        cipher.init(Cipher.DECRYPT_MODE, key);
////        return cipher.doFinal(encryptedData);
////    }
////}
//
//
//package util;
//
//import javax.crypto.*;
//import javax.crypto.spec.IvParameterSpec;
//import javax.crypto.spec.SecretKeySpec;
//import java.security.*;
//import java.util.Arrays;
//
//public class AESUtil {
//
//    // Encrypt with a dynamic key (from session key)
//    public static byte[] encrypt(byte[] data, byte[] keyBytes) throws Exception {
//        SecretKeySpec key = new SecretKeySpec(keyBytes, "AES");
//
//        // Generate random IV
//        byte[] ivBytes = new byte[16];
//        SecureRandom sr = new SecureRandom();
//        sr.nextBytes(ivBytes);
//        IvParameterSpec iv = new IvParameterSpec(ivBytes);
//
//        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
//        cipher.init(Cipher.ENCRYPT_MODE, key, iv);
//        byte[] encrypted = cipher.doFinal(data);
//
//        // Prepend IV to encrypted data
//        byte[] result = new byte[ivBytes.length + encrypted.length];
//        System.arraycopy(ivBytes, 0, result, 0, ivBytes.length);
//        System.arraycopy(encrypted, 0, result, ivBytes.length, encrypted.length);
//
//        return result;
//    }
//
//    // Decrypt with the same dynamic key
//    public static byte[] decrypt(byte[] encryptedData, byte[] keyBytes) throws Exception {
//        SecretKeySpec key = new SecretKeySpec(keyBytes, "AES");
//
//        // Extract IV
//        byte[] ivBytes = Arrays.copyOfRange(encryptedData, 0, 16);
//        IvParameterSpec iv = new IvParameterSpec(ivBytes);
//
//        // Extract encrypted content
//        byte[] actualEncrypted = Arrays.copyOfRange(encryptedData, 16, encryptedData.length);
//
//        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
//        cipher.init(Cipher.DECRYPT_MODE, key, iv);
//        return cipher.doFinal(actualEncrypted);
//    }
//}


package util;

import javax.crypto.*;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.*;
import java.util.Arrays;

public class AESUtil {

    // Encrypt with a dynamic key (from session key)
    public static byte[] encrypt(byte[] data, byte[] keyBytes) throws Exception {
        SecretKeySpec key = new SecretKeySpec(keyBytes, "AES");

        // Generate random IV
        byte[] ivBytes = new byte[16];
        SecureRandom sr = new SecureRandom();
        sr.nextBytes(ivBytes);
        IvParameterSpec iv = new IvParameterSpec(ivBytes);

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key, iv);
        byte[] encrypted = cipher.doFinal(data);

        // Prepend IV to encrypted data
        byte[] result = new byte[ivBytes.length + encrypted.length];
        System.arraycopy(ivBytes, 0, result, 0, ivBytes.length);
        System.arraycopy(encrypted, 0, result, ivBytes.length, encrypted.length);

        return result;
    }

    // Decrypt with the same dynamic key
    public static byte[] decrypt(byte[] encryptedData, byte[] keyBytes) throws Exception {
        SecretKeySpec key = new SecretKeySpec(keyBytes, "AES");

        // Extract IV
        byte[] ivBytes = Arrays.copyOfRange(encryptedData, 0, 16);
        IvParameterSpec iv = new IvParameterSpec(ivBytes);

        // Extract encrypted content
        byte[] actualEncrypted = Arrays.copyOfRange(encryptedData, 16, encryptedData.length);

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.DECRYPT_MODE, key, iv);
        return cipher.doFinal(actualEncrypted);
    }
}
