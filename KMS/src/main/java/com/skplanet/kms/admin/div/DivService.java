package com.skplanet.kms.admin.div;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DivService {

	@Autowired
	private DivDAO divDAO;
	
	public List<Map<String,Object>> selectCenterList(Map<String, String> params) {
		return divDAO.selectCenterList(params);
	}
	
	public Map<String,Object> selectCenter(Map<String, String> params) {
		return divDAO.selectCenter(params);
	}
	
	public List<Map<String,Object>> selectTeamList(Map<String, String> params) {
		return divDAO.selectTeamList(params);
	}
	
	public int insertDiv(Map<String, String> params) {
		return divDAO.insertDiv(params);
	}
	
	public int updateDiv(Map<String, String> params) {
		return divDAO.updateDiv(params);
	}
	
	public int deleteDiv(Map<String, String> params) {
		return divDAO.deleteDiv(params);
	}
	
	public int selectDivCnt(Map<String, String> params) {
		return divDAO.selectDivCnt(params);
	}
	
	public int selectMemberCnt(Map<String, String> params) {
		return divDAO.selectMemberCnt(params);
	}
}
