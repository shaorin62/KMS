package com.skplanet.kms.admin.point;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PointService {

	private static final Logger logger = LoggerFactory.getLogger(PointService.class);
	
	@Autowired
	private PointDAO pointDAO;
	
	public Map<String,Object> selectMember(Map<String, String> params) {
		return pointDAO.selectMember(params);
	}
	public int selectSumPoint(Map<String, String> params) {
		return pointDAO.selectSumPoint(params);
	}
	
	public int selectPointCnt(Map<String, String> params) {
		return pointDAO.selectPointCnt(params);
	}
	public List<Map<String,Object>> selectPointList(Map<String, String> params) {
		return pointDAO.selectPointList(params);
	}

	public int selectPointViewCnt(Map<String, String> params) {
		return pointDAO.selectPointViewCnt(params);
	}
	public List<Map<String,Object>> selectPointViewList(Map<String, String> params) {
		return pointDAO.selectPointViewList(params);
	}
	
	public List<Map<String,Object>> selectPointTypeList(String pointTyp) {
		return pointDAO.selectPointTypeList(pointTyp);
	}
	public int insertPoint(Map<String, String> params){
		return pointDAO.insertPoint(params);
	}
	
	public int selectPointMemberCnt(Map<String, String> params) {
		return pointDAO.selectPointMemberCnt(params);
	}
	public List<Map<String,Object>> selectPointMemberList(Map<String, String> params) {
		return pointDAO.selectPointMemberList(params);
	}
	
	public Map<String,Object> selectPointSet(Map<String, String> params) {
		return pointDAO.selectPointSet(params);
	}
	
	@Transactional
	public int updatePointSet(Map<String, String> params){
		int retSum = 0;
		
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("mid", params.get("mid"));

		// VC 등록
		paramMap.put("pointTyp", "POI_VC_REG");
		paramMap.put("pointSet", params.get("poiVcReg"));
		logger.debug("paramMap=[{}]",paramMap);
		retSum += pointDAO.updatePointSet(paramMap);

		// PT 제출
		paramMap.put("pointTyp", "POI_PT_SUBMIT");
		paramMap.put("pointSet", params.get("poiPtSubmit"));
		logger.debug("paramMap=[{}]",paramMap);
		retSum += pointDAO.updatePointSet(paramMap);
		
		// TR 조회
		paramMap.put("pointTyp", "POI_TR_VIEW");
		paramMap.put("pointSet", params.get("poiTrView"));
		logger.debug("paramMap=[{}]",paramMap);
		retSum += pointDAO.updatePointSet(paramMap);
		
		// TR 등록
		paramMap.put("pointTyp", "POI_TR_REG");
		paramMap.put("pointSet", params.get("poiTrReg"));
		logger.debug("paramMap=[{}]",paramMap);
		retSum += pointDAO.updatePointSet(paramMap);
		
		// 타사 조회
		paramMap.put("pointTyp", "POI_OTHER_VIEW");
		paramMap.put("pointSet", params.get("poiOtherView"));
		logger.debug("paramMap=[{}]",paramMap);
		retSum += pointDAO.updatePointSet(paramMap);
		
		// 타사 등록
		paramMap.put("pointTyp", "POI_OTHER_REG");
		paramMap.put("pointSet", params.get("poiOtherReg"));
		logger.debug("paramMap=[{}]",paramMap);
		retSum += pointDAO.updatePointSet(paramMap);
		
		// HA 등록
		paramMap.put("pointTyp", "POI_HA_REG");
		paramMap.put("pointSet", params.get("poiHaReg"));
		logger.debug("paramMap=[{}]",paramMap);
		retSum += pointDAO.updatePointSet(paramMap);
		
		if(retSum==7){
			return 1;
		}else{
			return 0;
		}
	}
}
