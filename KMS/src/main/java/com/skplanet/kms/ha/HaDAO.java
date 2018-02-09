   package com.skplanet.kms.ha;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class HaDAO {
	private static final Logger logger = LoggerFactory.getLogger(HaController.class);
	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = HaDAO.class.getPackage().getName()+".";
	
	public int insertHa(Map<String, String> params) {
		return kmsSqlSession.insert(NS+"insertHa",params);
	}
	public int updateHa(Map<String, String> params) {
		return kmsSqlSession.update(NS+"updateHa", params);
	}
	public int selectHaCnt(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectHaCnt",params);
	}
	public List<Map<String,Object>> selectHaList(Map<String, String> params) {
		return kmsSqlSession.selectList(NS+"selectHaList",params);
	}
	public Map<String, Object> selectHaOne(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectHaOne",params);
	}
	public void updateHaHit(Map<String, String> params) {
		kmsSqlSession.update(NS+"updateHaHit",params);
	}
	public int deleteHa(Map<String, String> params) {
		return kmsSqlSession.delete(NS+"deleteHa",params);
	}
	
	
}
