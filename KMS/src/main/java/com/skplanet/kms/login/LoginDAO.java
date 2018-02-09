package com.skplanet.kms.login;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class LoginDAO {

	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = LoginDAO.class.getPackage().getName() + ".";
	
	public Map<String,Object> selectLoginMember(Map<String,String> params){
		return kmsSqlSession.selectOne(NS + "selectLoginMember", params);
	}
	
	public Map<String,Object> selectSelfAuth(Map<String,String> params){
		return kmsSqlSession.selectOne(NS + "selectSelfAuth", params);
	}
	
	public int updatePasswd(Map<String,String> params){
		return kmsSqlSession.update(NS + "updatePasswd", params);
	}
}
