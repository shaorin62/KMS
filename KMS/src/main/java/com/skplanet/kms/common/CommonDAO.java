package com.skplanet.kms.common;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CommonDAO {

	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = CommonDAO.class.getPackage().getName() + ".";
	
	public List<Map<String,String>> selectCodeList(String upperCd){
		return kmsSqlSession.selectList(NS + "selectCodeList", upperCd);
	}

	public List<Map<String,String>> selectCodeListOrderName(String upperCd){
		return kmsSqlSession.selectList(NS + "selectCodeListOrderName", upperCd);
	}
	
	public int insertRegPoint(Map<String,String> params){
		return kmsSqlSession.insert(NS + "insertRegPoint", params);
	}
	
	public int insertViewPoint(Map<String,String> params){
		return kmsSqlSession.insert(NS + "insertViewPoint", params);
	}

}
