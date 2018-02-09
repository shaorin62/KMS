   package com.skplanet.kms.kc;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class KcDAO {
	private static final Logger logger = LoggerFactory.getLogger(KcController.class);
	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = KcDAO.class.getPackage().getName()+".";
	
	public int insertKc(Map<String, String> params) {
		return kmsSqlSession.insert(NS+"insertKc",params);
	}
	public int updateKc(Map<String, String> params) {
		return kmsSqlSession.update(NS+"updateKc", params);
	}
	public int deleteKc(Map<String, String> params) {
		return kmsSqlSession.delete(NS+"deleteKc",params);
	}
	public int selectKcCnt(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectKcCnt",params);
	}
	public List<Map<String,Object>> selectKcList(Map<String, String> params) {
		return kmsSqlSession.selectList(NS+"selectKcList",params);
	}
	
	public Map<String, Object> oneImgKc(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"oneImgKc",params);
	}
	public Map<String, Object> selectKcOne(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectKcOne",params);
	}
	public void updateKcHit(Map<String, String> params) {
		kmsSqlSession.update(NS+"updateKcHit",params);
	}
	
	
}
