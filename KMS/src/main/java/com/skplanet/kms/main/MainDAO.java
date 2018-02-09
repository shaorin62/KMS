package com.skplanet.kms.main;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MainDAO {

	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = MainDAO.class.getPackage().getName() + ".";
	
	public int selectDocCnt(String mid){
		return kmsSqlSession.selectOne(NS + "selectDocCnt", mid);
	}
	
	public int selectSumPoint(String mid){
		return kmsSqlSession.selectOne(NS + "selectSumPoint", mid);
	}
	
	public int selectPointCnt(Map<String,String> params){
		return kmsSqlSession.selectOne(NS + "selectPointCnt", params);
	}
	
	public List<Map<String,Object>> selectPointList(Map<String,String> params){
		return kmsSqlSession.selectList(NS + "selectPointList", params);
	}	
}
