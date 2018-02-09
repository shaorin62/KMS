package com.skplanet.kms.admin.download;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class DownloadDAO {

	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = DownloadDAO.class.getPackage().getName()+".";
	
	public List<Map<String,Object>> selectTop10List(Map<String, String> params) {
		return kmsSqlSession.selectList(NS+"selectTop10List",params);
	}	
	
	public int selectDownloadCnt(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectDownloadCnt",params);
	}
	public List<Map<String,Object>> selectDownloadList(Map<String, String> params) {
		return kmsSqlSession.selectList(NS+"selectDownloadList",params);
	}	
}
