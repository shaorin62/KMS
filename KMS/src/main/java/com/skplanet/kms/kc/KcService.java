package com.skplanet.kms.kc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.skplanet.kms.upload.UploadDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class KcService {
	private static final Logger logger = LoggerFactory.getLogger(KcController.class);
	@Autowired
	private KcDAO kcDAO;
	@Autowired
	private UploadDAO uploadDAO;

	public int insertKc(Map<String, String> params,String attachNormals) {
		int ret = kcDAO.insertKc(params);
		
		//일반파일첨부 업데이트
		Map<String,String> attachParams = new HashMap<String,String>();
		attachParams.put("bid", params.get("bdId"));
		attachParams.put("attachTyp", "ATT_NORMAL");
		uploadDAO.deleteAttach(attachParams);
		
		if(attachNormals!=null){
				attachParams.put("uploadSeq", attachNormals);
				uploadDAO.insertAttach(attachParams);
		}		
		
		return ret;
	}

	public int selectKcCnt(Map<String,String> params){
		return kcDAO.selectKcCnt(params);
	
	}

	public List<Map<String,Object>> selectKcList(Map<String, String> params) {
		return kcDAO.selectKcList(params);
	}

	public Map<String,Object> oneImgKc(Map<String, String> params) {
		return kcDAO.oneImgKc(params);
	}

	public Map<String,Object> selectKcOne(Map<String, String> params) {
		return kcDAO.selectKcOne(params);
	}

	public void updateKcHit(Map<String, String> params) {
		kcDAO.updateKcHit(params);
	}
	public int deleteKc(Map<String, String> params) {
		return kcDAO.deleteKc(params);
	}

	public int updateKc(Map<String, String> params, String attachNormals){
		int ret =  kcDAO.updateKc(params);
		
		// 일반 파일첨부 업데이트
		Map<String,String> attachParams = new HashMap<String,String>();
		attachParams.put("bid", params.get("bdId"));
		attachParams.put("attachTyp", "ATT_NORMAL");
		uploadDAO.deleteAttach(attachParams);
		if(attachNormals!=null){
				attachParams.put("uploadSeq", attachNormals);
				uploadDAO.insertAttach(attachParams);
		}		
		return ret;
	}	
}
