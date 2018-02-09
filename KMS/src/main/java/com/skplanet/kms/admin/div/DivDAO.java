package com.skplanet.kms.admin.div;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class DivDAO {

	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = DivDAO.class.getPackage().getName() + ".";
	
	public List<Map<String,Object>> selectCenterList(Map<String, String> params) {
		return kmsSqlSession.selectList(NS+"selectCenterList",params);
	}
	
	public Map<String,Object> selectCenter(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectCenter",params);
	}
	
	public List<Map<String,Object>> selectTeamList(Map<String, String> params) {
		return kmsSqlSession.selectList(NS+"selectTeamList",params);
	}
	
	public int insertDiv(Map<String, String> params) {
		return kmsSqlSession.insert(NS+"insertDiv",params);
	}
	
	public int updateDiv(Map<String, String> params) {
		return kmsSqlSession.update(NS+"updateDiv",params);
	}
	
	public int deleteDiv(Map<String, String> params) {
		return kmsSqlSession.update(NS+"deleteDiv",params);
	}
	
	public int selectDivCnt(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectDivCnt",params);
	}
	
	public int selectMemberCnt(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectMemberCnt",params);
	}
}
