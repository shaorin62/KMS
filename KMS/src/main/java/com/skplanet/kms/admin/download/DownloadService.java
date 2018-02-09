package com.skplanet.kms.admin.download;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DownloadService {

	@Autowired
	private DownloadDAO downloadDAO;
	
	public List<Map<String,Object>> selectTop10List(Map<String, String> params) {
		return downloadDAO.selectTop10List(params);
	}
	
	public int selectDownloadCnt(Map<String, String> params) {
		return downloadDAO.selectDownloadCnt(params);
	}
	public List<Map<String,Object>> selectDownloadList(Map<String, String> params) {
		return downloadDAO.selectDownloadList(params);
	}	
}
