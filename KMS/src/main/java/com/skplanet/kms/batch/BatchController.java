package com.skplanet.kms.batch;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class BatchController {

	private static final Logger logger = LoggerFactory.getLogger(BatchController.class);
	
	@Autowired
	private BatchService batchService;
	
	@Value("#{commonProperties['server.batch.ip']}")
	private String serverBatchIp;
	
	@Scheduled(cron="00 00 07 * * *")
	public void batchMail(){
		
		// 배치작업할 서버이면 실행함
		if(batchService.equalsServerIp(serverBatchIp)){
			batchService.batchMail();
		}
		
	}

	/*
	@RequestMapping(value = "/batch/mailTest.do", method = RequestMethod.GET)
	public void mailTest(@RequestParam Map<String, String> params, Model model) throws Exception{
		
		batchService.batchMail();
	}
	*/
}
