package com.skplanet.kms.cd;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CdDAO {
	private static final Logger logger = LoggerFactory.getLogger(CdController.class);
	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = CdDAO.class.getPackage().getName()+".";
	public int insertCd(Map<String, String> params) {
		return kmsSqlSession.insert(NS+"insertCd",params);
	}
	public int selectCdCnt(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectCdCnt",params);
	}
	public List<Map<String,Object>> selectCdList(Map<String, String> params) {
		return kmsSqlSession.selectList(NS+"selectCdList",params);
	}
	public Map<String, Object> selectCdOne(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectCdOne",params);
	}
	public void updateCdHit(Map<String, String> params) {
		kmsSqlSession.update(NS+"updateCdHit",params);
	}
	public int updateCd(Map<String, String> params) {
		return kmsSqlSession.insert(NS+"updateCd",params);
	}

	public int deleteCd(Map<String, String> params) {
		return kmsSqlSession.delete(NS+"deleteCd",params);
	}
	
}
