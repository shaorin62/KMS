package com.skplanet.kms.admin.code;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CodeDAO {

	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = CodeDAO.class.getPackage().getName() + ".";
	
	public List<Map<String,Object>> selectCodeList(String upperCd) {
		return kmsSqlSession.selectList(NS+"selectCodeList",upperCd);
	}
	
	public int insertCode(Map<String, String> params) {
		return kmsSqlSession.insert(NS+"insertCode",params);
	}
	
	public int updateCode(Map<String, String> params) {
		return kmsSqlSession.update(NS+"updateCode",params);
	}
	
	public int deleteCode(Map<String, String> params) {
		return kmsSqlSession.update(NS+"deleteCode",params);
	}
}
