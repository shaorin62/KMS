package com.skplanet.kms.virtual;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class VirtualService {

	@Autowired
	private VirtualDAO virtualDAO;
	
	public int selectVirtualCnt(Map<String,String> params){
		return virtualDAO.selectVirtualCnt(params);
	}
	
	public List<Map<String,Object>> selectVirtualList(Map<String,String> params){
		return virtualDAO.selectVirtualList(params);
	}
	
	public Map<String,Object> selectVirtual(Map<String,String> params){
		return virtualDAO.selectVirtual(params);
	}	
	
	public int updateHit(Map<String,String> params){
		return virtualDAO.updateHit(params);
	}
	
	public List<Map<String,Object>> selectVirtualAuthList(Map<String,String> params){
		return virtualDAO.selectVirtualAuthList(params);
	}
	
	@Transactional
	public int insertVirtual(Map<String,String> params, String[] authMids){
		
		int ret = virtualDAO.insertVirtual(params);
		
		virtualDAO.deleteVirtualAuth(params);
		
		if(authMids!=null){
			for(int i=0; i<authMids.length; i++){
				Map<String,String> authParams = new HashMap<String,String>();
				authParams.put("vcId", params.get("vcId"));
				authParams.put("authMid", authMids[i]);
				authParams.put("dispOrd", (i+1)+"");
				virtualDAO.insertVirtualAuth(authParams);
			}
		}
		
		return ret;
	}
	
	@Transactional
	public int updateVirtual(Map<String,String> params, String[] authMids){
		
		int ret = virtualDAO.updateVirtual(params);
		
		virtualDAO.deleteVirtualAuth(params);
		
		if(authMids!=null){
			for(int i=0; i<authMids.length; i++){
				Map<String,String> authParams = new HashMap<String,String>();
				authParams.put("vcId", params.get("vcId"));
				authParams.put("authMid", authMids[i]);
				authParams.put("dispOrd", (i+1)+"");
				virtualDAO.insertVirtualAuth(authParams);
			}
		}
		
		return ret;
	}
	
	public int deleteVirtual(Map<String,String> params){
		return virtualDAO.deleteVirtual(params);
	}
	
	public int updateComment(Map<String,String> params){
		return virtualDAO.updateComment(params);
	}
	
	public List<Map<String,Object>> selectFuList(Map<String,String> params){
		return virtualDAO.selectFuList(params);
	}
	
	public int insertFu(Map<String,String> params){
		return virtualDAO.insertFu(params);
	}	
}
