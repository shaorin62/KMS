package com.skplanet.kms.cd;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.skplanet.kms.upload.UploadDAO;

@Service
public class CdService {
	private static final Logger logger = LoggerFactory.getLogger(CdController.class);
	@Autowired
	private CdDAO cdDAO;
	@Autowired
	private UploadDAO uploadDAO;

	public int insertCd(Map<String, String> params,String[] attachNormals) {
		
		int ret = cdDAO.insertCd(params);
		
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

	public int selectCdCnt(Map<String,String> params){
		return cdDAO.selectCdCnt(params);
		
	}

	public List<Map<String,Object>> selectCdList(Map<String, String> params) {
		return cdDAO.selectCdList(params);
	}

	public Map<String,Object> selectCdOne(Map<String, String> params) {
		return cdDAO.selectCdOne(params);
	}

	public void updateCdHit(Map<String, String> params) {
		cdDAO.updateCdHit(params);
	}
	public int deleteCd(Map<String, String> params) {
		return cdDAO.deleteCd(params);
	}
	public int updateCd(Map<String, String> params, String[] attachNormals){
		int ret =  cdDAO.updateCd(params);
		
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
