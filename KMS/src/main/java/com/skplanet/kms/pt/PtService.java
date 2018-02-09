package com.skplanet.kms.pt;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.skplanet.kms.upload.UploadDAO;

@Service
public class PtService {

	@Autowired
	private UploadDAO uploadDAO;
	
	@Autowired
	private PtDAO ptDAO; 
	
	public int selectPtCnt(Map<String,String> params){
		return ptDAO.selectPtCnt(params);
	}
	
	public List<Map<String,Object>> selectPtList(Map<String,String> params){
		return ptDAO.selectPtList(params);
	}
	
	public Map<String,Object> selectPt(Map<String,String> params){
		return ptDAO.selectPt(params);
	}
	
	public int updateHit(Map<String,String> params){
		return ptDAO.updateHit(params);
	}
	
	public List<Map<String,Object>> selectPtRivalList(Map<String,String> params){
		return ptDAO.selectPtRivalList(params);
	}
	
	@Transactional
	public int insertPt(Map<String,String> params, String[] rivalCds, String[] attachNormals){
		
		/* 부모 상태 변경하지 않음 2017-01-06
		// 재PT일 경우 부모PT를 재PT상태로 변경 
		String upperPtId = params.get("upperPtId");
		if(upperPtId!=null && !"".equals(upperPtId)){
			ptDAO.updateRePt(params);
		}
		*/
		
		int ret = ptDAO.insertPt(params);
		
		// 참여사 업데이트
		ptDAO.deletePtRival(params);
		if(rivalCds!=null){
			for(int i=0; i<rivalCds.length; i++){
				Map<String,String> rivalParams = new HashMap<String,String>();
				rivalParams.put("ptId", params.get("ptId"));
				rivalParams.put("rivalCd", rivalCds[i]);
				rivalParams.put("dispOrd", (i+1)+"");
				ptDAO.insertPtRival(rivalParams);
			}
		}
		
		// 일반 파일첨부 업데이트
		Map<String,String> attachParams = new HashMap<String,String>();
		attachParams.put("bid", params.get("ptId"));
		attachParams.put("attachTyp", "ATT_NORMAL");
		uploadDAO.deleteAttach(attachParams);
		if(attachNormals!=null){
			for(int i=0; i<attachNormals.length; i++){
				attachParams.put("uploadSeq", attachNormals[i]);
				uploadDAO.insertAttach(attachParams);
			}
		}		
		
		String attPt01 = params.get("ATT_PT_01");
		if(attPt01!=null && !"".equals(attPt01)){
			attachParams.put("attachTyp", "ATT_PT_01");
			uploadDAO.deleteAttach(attachParams);
			attachParams.put("uploadSeq", attPt01);
			uploadDAO.insertAttach(attachParams);
		}
		
		String attPt02 = params.get("ATT_PT_02");
		if(attPt02!=null && !"".equals(attPt02)){
			attachParams.put("attachTyp", "ATT_PT_02");
			uploadDAO.deleteAttach(attachParams);
			attachParams.put("uploadSeq", attPt02);
			uploadDAO.insertAttach(attachParams);
		}
		
		String attPt03 = params.get("ATT_PT_03");
		if(attPt03!=null && !"".equals(attPt03)){
			attachParams.put("attachTyp", "ATT_PT_03");
			uploadDAO.deleteAttach(attachParams);
			attachParams.put("uploadSeq", attPt03);
			uploadDAO.insertAttach(attachParams);
		}
		
		String attPt04 = params.get("ATT_PT_04");
		if(attPt04!=null && !"".equals(attPt04)){
			attachParams.put("attachTyp", "ATT_PT_04");
			uploadDAO.deleteAttach(attachParams);
			attachParams.put("uploadSeq", attPt04);
			uploadDAO.insertAttach(attachParams);
		}
		
		String attPt05 = params.get("ATT_PT_05");
		if(attPt05!=null && !"".equals(attPt05)){
			attachParams.put("attachTyp", "ATT_PT_05");
			uploadDAO.deleteAttach(attachParams);
			attachParams.put("uploadSeq", attPt05);
			uploadDAO.insertAttach(attachParams);
		}
		
		String attPt06 = params.get("ATT_PT_06");
		if(attPt06!=null && !"".equals(attPt06)){
			attachParams.put("attachTyp", "ATT_PT_06");
			uploadDAO.deleteAttach(attachParams);
			attachParams.put("uploadSeq", attPt06);
			uploadDAO.insertAttach(attachParams);
		}
		
		String attPt99 = params.get("ATT_PT_99");
		if(attPt99!=null && !"".equals(attPt99)){
			attachParams.put("attachTyp", "ATT_PT_99");
			uploadDAO.deleteAttach(attachParams);
			attachParams.put("uploadSeq", attPt99);
			uploadDAO.insertAttach(attachParams);
		}
		
		return ret;
	}
	
	@Transactional
	public int updatePt(Map<String,String> params, String[] rivalCds, String[] attachNormals){
		
		int ret = ptDAO.updatePt(params);
		
		// 참여사 업데이트
		ptDAO.deletePtRival(params);
		if(rivalCds!=null){
			for(int i=0; i<rivalCds.length; i++){
				Map<String,String> rivalParams = new HashMap<String,String>();
				rivalParams.put("ptId", params.get("ptId"));
				rivalParams.put("rivalCd", rivalCds[i]);
				rivalParams.put("dispOrd", (i+1)+"");
				ptDAO.insertPtRival(rivalParams);
			}
		}
		
		// 일반 파일첨부 업데이트
		Map<String,String> attachParams = new HashMap<String,String>();
		attachParams.put("bid", params.get("ptId"));
		attachParams.put("attachTyp", "ATT_NORMAL");
		uploadDAO.deleteAttach(attachParams);
		if(attachNormals!=null){
			for(int i=0; i<attachNormals.length; i++){
				attachParams.put("uploadSeq", attachNormals[i]);
				uploadDAO.insertAttach(attachParams);
			}
		}		
		
		String attPt01 = params.get("ATT_PT_01");
		if(attPt01!=null && !"".equals(attPt01)){
			attachParams.put("attachTyp", "ATT_PT_01");
			uploadDAO.deleteAttach(attachParams);
			attachParams.put("uploadSeq", attPt01);
			uploadDAO.insertAttach(attachParams);
		}
		
		String attPt02 = params.get("ATT_PT_02");
		if(attPt02!=null && !"".equals(attPt02)){
			attachParams.put("attachTyp", "ATT_PT_02");
			uploadDAO.deleteAttach(attachParams);
			attachParams.put("uploadSeq", attPt02);
			uploadDAO.insertAttach(attachParams);
		}
		
		String attPt03 = params.get("ATT_PT_03");
		if(attPt03!=null && !"".equals(attPt03)){
			attachParams.put("attachTyp", "ATT_PT_03");
			uploadDAO.deleteAttach(attachParams);
			attachParams.put("uploadSeq", attPt03);
			uploadDAO.insertAttach(attachParams);
		}
		
		String attPt04 = params.get("ATT_PT_04");
		if(attPt04!=null && !"".equals(attPt04)){
			attachParams.put("attachTyp", "ATT_PT_04");
			uploadDAO.deleteAttach(attachParams);
			attachParams.put("uploadSeq", attPt04);
			uploadDAO.insertAttach(attachParams);
		}
		
		String attPt05 = params.get("ATT_PT_05");
		if(attPt05!=null && !"".equals(attPt05)){
			attachParams.put("attachTyp", "ATT_PT_05");
			uploadDAO.deleteAttach(attachParams);
			attachParams.put("uploadSeq", attPt05);
			uploadDAO.insertAttach(attachParams);
		}
		
		String attPt06 = params.get("ATT_PT_06");
		if(attPt06!=null && !"".equals(attPt06)){
			attachParams.put("attachTyp", "ATT_PT_06");
			uploadDAO.deleteAttach(attachParams);
			attachParams.put("uploadSeq", attPt06);
			uploadDAO.insertAttach(attachParams);
		}
		
		String attPt99 = params.get("ATT_PT_99");
		if(attPt99!=null && !"".equals(attPt99)){
			attachParams.put("attachTyp", "ATT_PT_99");
			uploadDAO.deleteAttach(attachParams);
			attachParams.put("uploadSeq", attPt99);
			uploadDAO.insertAttach(attachParams);
		}
		
		return ret;
	}	

	public int updateDocOpenDt(Map<String,String> params){
		return ptDAO.updateDocOpenDt(params);
	}
	
	public int deletePt(Map<String,String> params){
		return ptDAO.deletePt(params);
	}
	
	public int updateLesson(Map<String,String> params){
		return ptDAO.updateLesson(params);
	}
}
