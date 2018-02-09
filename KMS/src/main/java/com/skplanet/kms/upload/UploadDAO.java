package com.skplanet.kms.upload;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UploadDAO {

	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = UploadDAO.class.getPackage().getName() + ".";
	
	public int insertUpload(Map<String,String> params){
		return kmsSqlSession.insert(NS + "insertUpload", params);
	}
	
	public List<Map<String,Object>> selectAttachList(Map<String,String> params){
		return kmsSqlSession.selectList(NS + "selectAttachList", params);
	}
	
	public List<Map<String,Object>> selectAttachListPTRow(Map<String,String> params){
		return kmsSqlSession.selectList(NS + "selectAttachListPTRow", params);
	}
	
	
	public Map<String,Object> selectAttach(Map<String,String> params){
		return kmsSqlSession.selectOne(NS + "selectAttach", params);
	}
	
	public int insertDownLog(Map<String,String> params){
		return kmsSqlSession.insert(NS + "insertDownLog", params);
	}
	
	public int deleteAttach(Map<String,String> params){
		return kmsSqlSession.update(NS + "deleteAttach", params);
	}
	
	public int insertAttach(Map<String,String> params){
		return kmsSqlSession.update(NS + "insertAttach", params);
	}
}
