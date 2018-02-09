package com.skplanet.kms.upload;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UploadService {

	@Autowired
	private UploadDAO uploadDAO;
	
	public int insertUpload(Map<String,String> params){
		return uploadDAO.insertUpload(params);
	}
	
	public List<Map<String,Object>> selectAttachList(Map<String,String> params){
		return uploadDAO.selectAttachList(params);
	}
	
	public List<Map<String,Object>> selectAttachListPTRow(Map<String,String> params){
		return uploadDAO.selectAttachListPTRow(params);
	}
	
	public Map<String,Object> selectAttach(Map<String,String> params){
		return uploadDAO.selectAttach(params);
	}
	
	public int insertDownLog(String bcd, String bid, String uploadSeq, String regId){
		
		Map<String,String> params = new HashMap<String,String>();
		params.put("bcd", bcd);
		params.put("bid", bid);
		params.put("uploadSeq", uploadSeq);
		params.put("regId", regId);
		
		return uploadDAO.insertDownLog(params);
	}
	
	public int insertAttach(Map<String,String> params){
		return uploadDAO.insertAttach(params);
	}
}
