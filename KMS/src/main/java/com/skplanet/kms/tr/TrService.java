package com.skplanet.kms.tr;

import java.util.HashMap;
import com.skplanet.kms.upload.UploadDAO;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TrService {
	private static final Logger logger = LoggerFactory.getLogger(TrController.class);
	@Autowired
	private TrDAO trDAO;

	@Autowired
	private UploadDAO uploadDAO;

	
	public int insertTr(Map<String, String> params,String[] attachNormals) {
		
		int ret = trDAO.insertTr(params);
		
		//일반파일첨부 업데이트
		Map<String,String> attachParams = new HashMap<String,String>();
		attachParams.put("bid", params.get("bdId"));
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

	public int selectTrCnt(Map<String,String> params){
		return trDAO.selectTrCnt(params);
		
	}

	public List<Map<String,Object>> selectTrList(Map<String, String> params) {
		return trDAO.selectTrList(params);
	}

	public Map<String,Object> selectTrOne(Map<String, String> params) {
		return trDAO.selectTrOne(params);
	}

	public void updateTrHit(Map<String, String> params) {
		trDAO.updateTrHit(params);
	}
	
	public int deleteTr(Map<String, String> params) {
		return trDAO.deleteTr(params);
	}

	public int updateTr(Map<String, String> params, String[] attachNormals){
		int ret =  trDAO.updateTr(params);
		
		// 일반 파일첨부 업데이트
		Map<String,String> attachParams = new HashMap<String,String>();
		attachParams.put("bid", params.get("bdId"));
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
