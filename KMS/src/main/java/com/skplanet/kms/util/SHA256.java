package com.skplanet.kms.util;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA256 {

	public static String encrypt(String a_origin){
		
		if(a_origin==null || "".equals(a_origin)){
			return "";
		}
		
        String encryptedSHA256 = "";
        MessageDigest md = null;
        
        try {
            md = MessageDigest.getInstance("SHA-256");
            md.update(a_origin.getBytes(), 0, a_origin.length());
            encryptedSHA256 = new BigInteger(1, md.digest()).toString(16); 
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        
        return encryptedSHA256;
    }
	
}
