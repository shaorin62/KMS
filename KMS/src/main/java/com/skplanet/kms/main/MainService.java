package com.skplanet.kms.main;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MainService {

	@Autowired
	private MainDAO mainDAO;
	
	public int selectDocCnt(String mid){
		return mainDAO.selectDocCnt(mid);
	}
	
	public int selectSumPoint(String mid){
		return mainDAO.selectSumPoint(mid);
	}
	
	public int selectPointCnt(Map<String,String> params){
		return mainDAO.selectPointCnt(params);
	}
	
	public List<Map<String,Object>> selectPointList(Map<String,String> params){
		return mainDAO.selectPointList(params);
	}	
}
