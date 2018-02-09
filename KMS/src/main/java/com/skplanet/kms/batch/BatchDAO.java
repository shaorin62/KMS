package com.skplanet.kms.batch;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class BatchDAO {

	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = BatchDAO.class.getPackage().getName() + ".";
	
	public List<Map<String,Object>> selectMailMemberList(Map<String,String> params){
		return kmsSqlSession.selectList(NS + "selectMailMemberList", params);
	}
	
	public List<Map<String,Object>> selectMailPtList(String mid){
		return kmsSqlSession.selectList(NS + "selectMailPtList", mid);
	}
}
