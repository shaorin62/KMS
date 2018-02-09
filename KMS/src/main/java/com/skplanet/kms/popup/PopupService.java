package com.skplanet.kms.popup;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PopupService {

	@Autowired
	private PopupDAO popupDAO;
	
	public List<Map<String,Object>> selectPopList(Map<String,String> params){
		return popupDAO.selectPopList(params);
	}
	
	public List<Map<String,Object>> selectPopMemberList(Map<String,String> params){
		return popupDAO.selectPopMemberList(params);
	}
	
	public List<Map<String,Object>> selectTeamList(Map<String,String> params){
		return popupDAO.selectTeamList(params);
	}
}
