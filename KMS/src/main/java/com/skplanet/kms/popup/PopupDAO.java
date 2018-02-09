package com.skplanet.kms.popup;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class PopupDAO {

	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = PopupDAO.class.getPackage().getName() + ".";
	
	public List<Map<String,Object>> selectPopList(Map<String,String> params){
		return kmsSqlSession.selectList(NS + "selectPopList", params);
	}
	
	public List<Map<String,Object>> selectPopMemberList(Map<String,String> params){System.out.println("params="+params);
		return kmsSqlSession.selectList(NS + "selectPopMemberList", params);
	}	
	
	public List<Map<String,Object>> selectTeamList(Map<String,String> params){
		return kmsSqlSession.selectList(NS + "selectTeamList", params);
	}
}
