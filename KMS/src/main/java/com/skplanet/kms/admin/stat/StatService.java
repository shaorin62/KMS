package com.skplanet.kms.admin.stat;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class StatService {

	@Autowired
	private StatDAO statDAO;
	
	public List<Map<String,Object>> selectDivList(String upperCd) {
		return statDAO.selectDivList(upperCd);
	}
	public List<Map<String,Object>> selectMemberList(String divCd) {
		return statDAO.selectMemberList(divCd);
	}
	
	public int selectStatCnt(Map<String, String> params) {
		return statDAO.selectStatCnt(params);
	}
	public List<Map<String,Object>> selectStatList(Map<String, String> params) {
		return statDAO.selectStatList(params);
	}
	public Map<String,Object> selectListTotal(Map<String, String> params) {
		return statDAO.selectListTotal(params);
	}
}
