package com.skplanet.kms.admin.stat;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class StatDAO {

	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = StatDAO.class.getPackage().getName() + ".";
	
	public List<Map<String,Object>> selectDivList(String upperCd) {
		return kmsSqlSession.selectList(NS+"selectDivList",upperCd);
	}
	public List<Map<String,Object>> selectMemberList(String divCd) {
		return kmsSqlSession.selectList(NS+"selectMemberList",divCd);
	}
	
	public int selectStatCnt(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectStatCnt",params);
	}
	public List<Map<String,Object>> selectStatList(Map<String, String> params) {
		return kmsSqlSession.selectList(NS+"selectStatList",params);
	}
	public Map<String,Object> selectListTotal(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectListTotal",params);
	}
			
}
