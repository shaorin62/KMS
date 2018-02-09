package com.skplanet.kms.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

public class DownloadView extends AbstractView {

	private static final Logger logger = LoggerFactory.getLogger(DownloadView.class);
	
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response)throws Exception {

		String orgFileNm = (String)model.get("orgFileNm");		
		File file = (File) model.get("downloadFile");
		
		if(orgFileNm==null || file==null){
			response.setContentType("text/html;charset=UTF-8;pageEncoding=UTF-8");
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('파일이 없습니다.');");
			pw.println("history.back();");
			pw.println("</script>");
			pw.flush();
			return;
		}
		
		response.setContentType("application/download;charset=UTF-8");
		response.setContentLength((int) file.length());
		
		String userAgent = request.getHeader("User-Agent");
		logger.info("** [before] encode fileName >>" + orgFileNm);
		
    	if(userAgent.contains("MSIE") || userAgent.contains("Trident") || userAgent.contains("Chrome")){        		
    	   orgFileNm = URLEncoder.encode(orgFileNm,"UTF-8").replaceAll("\\+", "%20");
    	} else {        		
    	   orgFileNm = new String(orgFileNm.getBytes("UTF-8"), "ISO-8859-1");
    	}
    	
    	logger.info("** [after] encode fileName >>" + orgFileNm);
		
		response.setHeader("Content-Disposition", "attachment; filename=\"" + orgFileNm + "\";");
		response.setHeader("Content-Transfer-Encoding", "binary");
		OutputStream out = response.getOutputStream();
		FileInputStream fis = null;
		
		try {
			fis = new FileInputStream(file);
			FileCopyUtils.copy(fis, out);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception e) {
				}
			}
		}
		out.flush();    	
	}

}
