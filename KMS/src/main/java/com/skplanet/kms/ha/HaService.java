package com.skplanet.kms.ha;

import java.util.HashMap;
import com.skplanet.kms.upload.UploadDAO;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class HaService {
	private static final Logger logger = LoggerFactory.getLogger(HaController.class);
	@Autowired
	private HaDAO haDAO;
	@Autowired
	private UploadDAO uploadDAO;

	public int insertHa(Map<String, String> params,String[] attachNormals) {
		
		int ret = haDAO.insertHa(params);
		
		//일반파일첨부 업데이트
		Map<String,String> attachParams = new HashMap<String,String>();
		attachParams.put("bid", params.get("haId"));
		attachParams.put("attachTyp", "ATT_NORMAL");
		uploadDAO.deleteAttach(attachParams);
		
		if(attachNormals!=null){
			for(int i=0; i<attachNormals.length; i++){
				attachParams.put("uploadSeq", attachNormals[i]);
				uploadDAO.insertAttach(attachParams);
			}
		}		
		
		return ret;
	}

	public int selectHaCnt(Map<String,String> params){
		return haDAO.selectHaCnt(params);
		
	}

	public List<Map<String,Object>> selectHaList(Map<String, String> params) {
		return haDAO.selectHaList(params);
	}

	public Map<String,Object> selectHaOne(Map<String, String> params) {
		return haDAO.selectHaOne(params);
	}

	public void updateHaHit(Map<String, String> params) {
		haDAO.updateHaHit(params);
	}
	public int deleteHa(Map<String, String> params) {
		return haDAO.deleteHa(params);
	}
	public int updateHa(Map<String, String> params,String[] attachNormals) {
		int ret = haDAO.updateHa(params);
		// 일반 파일첨부 업데이트
		Map<String,String> attachParams = new HashMap<String,String>();
		attachParams.put("bid", params.get("haId"));
		attachParams.put("attachTyp", "ATT_NORMAL");
		uploadDAO.deleteAttach(attachParams);
		if(attachNormals!=null){
			for(int i=0; i<attachNormals.length; i++){
				attachParams.put("uploadSeq", attachNormals[i]);
				uploadDAO.insertAttach(attachParams);
			}
		}		
		return ret;
	}

	
}
