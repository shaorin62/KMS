package com.skplanet.kms.virtual;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class VirtualDAO {

	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = VirtualDAO.class.getPackage().getName() + ".";
	
	public int selectVirtualCnt(Map<String,String> params){
		return kmsSqlSession.selectOne(NS + "selectVirtualCnt", params);
	}
	
	public List<Map<String,Object>> selectVirtualList(Map<String,String> params){
		return kmsSqlSession.selectList(NS + "selectVirtualList", params);
	}
	
	public Map<String,Object> selectVirtual(Map<String,String> params){
		return kmsSqlSession.selectOne(NS + "selectVirtual", params);
	}	
	
	public int updateHit(Map<String,String> params){
		return kmsSqlSession.update(NS + "updateHit", params);
	}
	
	public int insertVirtual(Map<String,String> params){
		return kmsSqlSession.insert(NS + "insertVirtual", params);
	}
	
	public int updateVirtual(Map<String,String> params){
		return kmsSqlSession.update(NS + "updateVirtual", params);
	}
	
	public int deleteVirtual(Map<String,String> params){
		return kmsSqlSession.update(NS + "deleteVirtual", params);
	}
	
	public List<Map<String,Object>> selectVirtualAuthList(Map<String,String> params){
		return kmsSqlSession.selectList(NS + "selectVirtualAuthList", params);
	}
	
	public int deleteVirtualAuth(Map<String,String> params){
		return kmsSqlSession.update(NS + "deleteVirtualAuth", params);
	}
	
	public int insertVirtualAuth(Map<String,String> params){
		return kmsSqlSession.update(NS + "insertVirtualAuth", params);
	}
	
	public int updateComment(Map<String,String> params){
		return kmsSqlSession.update(NS + "updateComment", params);
	}
	
	public List<Map<String,Object>> selectFuList(Map<String,String> params){
		return kmsSqlSession.selectList(NS + "selectFuList", params);
	}
	
	public int insertFu(Map<String,String> params){
		return kmsSqlSession.insert(NS + "insertFu", params);
	}
}
