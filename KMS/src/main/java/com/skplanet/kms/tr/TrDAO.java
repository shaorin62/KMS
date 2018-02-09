package com.skplanet.kms.tr;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class TrDAO {
	private static final Logger logger = LoggerFactory.getLogger(TrController.class);
	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = TrDAO.class.getPackage().getName()+".";
	
	public int insertTr(Map<String, String> params) {
		return kmsSqlSession.insert(NS+"insertTr",params);
	}
	public int updateTr(Map<String, String> params) {
		return kmsSqlSession.update(NS+"updateTr", params);
	}
	public int deleteTr(Map<String, String> params) {
		return kmsSqlSession.delete(NS+"deleteTr",params);
	}
	public int selectTrCnt(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectTrCnt",params);
	}
	public List<Map<String,Object>> selectTrList(Map<String, String> params) {
		return kmsSqlSession.selectList(NS+"selectTrList",params);
	}
	public Map<String, Object> selectTrOne(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectTrOne",params);
	}
	public void updateTrHit(Map<String, String> params) {
		kmsSqlSession.update(NS+"updateTrHit",params);
	}
	
	
}
