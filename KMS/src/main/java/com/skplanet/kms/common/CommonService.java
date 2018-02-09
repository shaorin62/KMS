package com.skplanet.kms.common;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CommonService {

	private static final Logger logger = LoggerFactory.getLogger(CommonService.class);
			
	@Autowired
	private CommonDAO commonDAO;
	
	public List<Map<String,String>> selectCodeList(String upperCd){
		return commonDAO.selectCodeList(upperCd);
	}
	
	public List<Map<String,String>> selectCodeListOrderName(String upperCd){
		return commonDAO.selectCodeListOrderName(upperCd);
	}
	
	// 등록 포인트 적립
	public int insertRegPoint(String pointTyp, String mid, String bid){
		
		Map<String,String> params = new HashMap<String,String>();
		params.put("pointTyp", pointTyp);
		params.put("mid", mid);
		params.put("bid", bid);
		params.put("regId", mid);
		
		return commonDAO.insertRegPoint(params);
	}
	
	// 조회 포인트 적립
	public int insertViewPoint(String pointTyp, String mid, String bid, String regId){
		
		Map<String,String> params = new HashMap<String,String>();
		params.put("pointTyp", pointTyp);
		params.put("mid", mid);
		params.put("bid", bid);
		params.put("regId", regId);
		
		logger.debug(params+"");
		
		return commonDAO.insertViewPoint(params);		
	}

	
}
