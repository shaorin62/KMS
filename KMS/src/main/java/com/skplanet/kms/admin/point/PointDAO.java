package com.skplanet.kms.admin.point;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class PointDAO {

	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = PointDAO.class.getPackage().getName() + ".";
	
	public Map<String,Object> selectMember(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectMember",params);
	}
	public int selectSumPoint(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectSumPoint",params);
	}
	
	public int selectPointCnt(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectPointCnt",params);
	}
	public List<Map<String,Object>> selectPointList(Map<String, String> params) {
		return kmsSqlSession.selectList(NS+"selectPointList",params);
	}
	
	public int selectPointViewCnt(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectPointViewCnt",params);
	}
	public List<Map<String,Object>> selectPointViewList(Map<String, String> params) {
		return kmsSqlSession.selectList(NS+"selectPointViewList",params);
	}
	
	public List<Map<String,Object>> selectPointTypeList(String pointTyp) {
		return kmsSqlSession.selectList(NS+"selectPointTypeList", pointTyp);
	}
	public int insertPoint(Map<String, String> params){
		return kmsSqlSession.insert(NS+"insertPoint",params);
	}
	
	public int selectPointMemberCnt(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectPointMemberCnt",params);
	}
	public List<Map<String,Object>> selectPointMemberList(Map<String, String> params) {
		return kmsSqlSession.selectList(NS+"selectPointMemberList",params);
	}
	
	public Map<String,Object> selectPointSet(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectPointSet",params);
	}
	public int updatePointSet(Map<String, String> params){
		return kmsSqlSession.update(NS+"updatePointSet",params);
	}
}
