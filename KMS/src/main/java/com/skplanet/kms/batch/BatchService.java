package com.skplanet.kms.batch;

import java.io.StringWriter;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class BatchService {

	private static final Logger logger = LoggerFactory.getLogger(BatchService.class);
	
	@Autowired
	private JavaMailSender mailSender;
	
	@Autowired
	private VelocityEngine velocityEngine;
	
	@Value("#{commonProperties['server.domain.web']}")
	private String serverDomainWeb;
	
	@Value("#{mailProperties['mail.from']}")
	private String mailFrom;
	
	@Autowired
	private BatchDAO batchDAO;
	
	public void batchMail(){
		
		// 메일 발송 대상자
		List<Map<String,Object>> memberList = batchDAO.selectMailMemberList(null);
		
		for(int i=0; i<memberList.size(); i++){
			Map<String,Object> member = memberList.get(i);
			List<Map<String,Object>> ptList = batchDAO.selectMailPtList((String)member.get("MID"));
			
			// 메일발송 실패해도 계속 진행하기 위하여 Exception catch
			try{
				MimeMessage message = mailSender.createMimeMessage();
				message.setFrom(new InternetAddress(mailFrom));
				message.addRecipient(Message.RecipientType.TO, new InternetAddress((String)member.get("EMAIL")));
				message.setSubject("[M-LIBRARY] PT Report 문서 공개일 안내");
				
				VelocityContext velocityContext = new VelocityContext();
				velocityContext.put("MEMBER_NM", member.get("MEMBER_NM"));
				velocityContext.put("TODAY", new SimpleDateFormat("yyyy.MM.dd").format(Calendar.getInstance().getTime()));
				velocityContext.put("ptList", ptList);
				
				StringWriter stringWriter = new StringWriter();
				velocityEngine.mergeTemplate("/com/skplanet/kms/batch/BatchMailPt.vm", "UTF-8", velocityContext, stringWriter); 
				message.setText(stringWriter.toString(),"utf-8","html");
				
				mailSender.send(message);
				
			}catch(Exception e){
				logger.error(e.getLocalizedMessage());
			}
			
		}
		
	}
	
	// 서버 IP와 일치하는가
	public boolean equalsServerIp(String compareIp){
		
		boolean ret = false;
		
		Enumeration<NetworkInterface> enumNif = null;
		try{
			enumNif = NetworkInterface.getNetworkInterfaces();
			while(enumNif.hasMoreElements()){
				NetworkInterface nif = enumNif.nextElement();
				Enumeration<InetAddress> enumInet = nif.getInetAddresses();
				while(enumInet.hasMoreElements()){
					InetAddress inet = enumInet.nextElement();
					String ip = inet.getHostAddress();
					
					if(ip.equals(compareIp)){
						ret = true;
						break;
					}

				}
			}
		}catch(Exception e){logger.error(e.getMessage());}
		
		return ret;
	}
}
