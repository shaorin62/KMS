package com.skplanet.kms.util;


import javax.xml.bind.DatatypeConverter;

//base64 encoding 
public class BASE64 {

	public static String encrypt64(String a_origin){
		
		if(a_origin==null || "".equals(a_origin)){
			return "";
		}
		
		byte[] message = a_origin.getBytes(); 
		
		String encoded = DatatypeConverter.printBase64Binary(message); 
		//byte[] decoded = DatatypeConverter.parseBase64Binary(encoded); 
		System.out.println(encoded); 
		
		String encryptedBASE64 = "";
		encryptedBASE64 = encoded;
        
        return encryptedBASE64;
    }
	
}
