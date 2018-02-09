package com.skplanet.kms.admin.code;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CodeService {

	@Autowired
	private CodeDAO codeDAO;
	
	public List<Map<String,Object>> selectCodeList(String upperCd) {
		return codeDAO.selectCodeList(upperCd);
	}
	
	public int insertCode(Map<String, String> params) {
		return codeDAO.insertCode(params);
	}
	
	public int updateCode(Map<String, String> params) {
		return codeDAO.updateCode(params);
	}
	
	public int deleteCode(Map<String, String> params) {
		return codeDAO.deleteCode(params);
	}
}
