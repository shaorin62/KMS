package com.skplanet.kms.pt;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class PtDAO {

	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = PtDAO.class.getPackage().getName() + ".";
	
	public int selectPtCnt(Map<String,String> params){
		return kmsSqlSession.selectOne(NS + "selectPtCnt", params);
	}
	
	public List<Map<String,Object>> selectPtList(Map<String,String> params){
		return kmsSqlSession.selectList(NS + "selectPtList", params);
	}	
	
	public Map<String,Object> selectPt(Map<String,String> params){
		return kmsSqlSession.selectOne(NS + "selectPt", params);
	}	
	
	public int updateHit(Map<String,String> params){
		return kmsSqlSession.update(NS + "updateHit", params);
	}
	
	public int insertPt(Map<String,String> params){
		return kmsSqlSession.insert(NS + "insertPt", params);
	}	
	
	public int updatePt(Map<String,String> params){
		return kmsSqlSession.update(NS + "updatePt", params);
	}	
	
	/**
	 * 부모PT를 재PT 상태로 변경
	 * */
	public int updateRePt(Map<String,String> params){
		return kmsSqlSession.update(NS + "updateRePt", params);
	}	
	
	public int updateDocOpenDt(Map<String,String> params){
		return kmsSqlSession.update(NS + "updateDocOpenDt", params);
	}	
	
	public int deletePt(Map<String,String> params){
		return kmsSqlSession.update(NS + "deletePt", params);
	}
	
	public List<Map<String,Object>> selectPtRivalList(Map<String,String> params){
		return kmsSqlSession.selectList(NS + "selectPtRivalList", params);
	}
	
	public int deletePtRival(Map<String,String> params){
		return kmsSqlSession.update(NS + "deletePtRival", params);
	}
	
	public int insertPtRival(Map<String,String> params){
		return kmsSqlSession.update(NS + "insertPtRival", params);
	}	
	
	public int updateLesson(Map<String,String> params){
		return kmsSqlSession.update(NS + "updateLesson", params);
	}	
}
