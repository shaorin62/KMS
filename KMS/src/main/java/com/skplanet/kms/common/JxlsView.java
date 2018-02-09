package com.skplanet.kms.common;

import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.web.servlet.view.document.AbstractXlsxView;

import net.sf.jxls.transformer.XLSTransformer;

public class JxlsView extends AbstractXlsxView {

	@Override
	protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request,	HttpServletResponse response) throws Exception {
		
		String viewName = (String) model.get("viewName");
		String fileName = (String) model.get("fileName");
		response.setHeader("Content-Disposition", "attachment;filename="+URLEncoder.encode(fileName,"UTF-8")+".xlsx");
		response.setHeader("Content-Description", "JSP Generated Data");
		response.setHeader("Content-Transfer-Encoding", "binary;");
		
		XLSTransformer transformer = new XLSTransformer();
		workbook = transformer.transformXLS(
				this.getClass().getClassLoader().getResourceAsStream("../views/excel/"+viewName+".xlsx"), model);
    	// 다운로드로 보낼 워크북 객체로 변환
    	workbook.write(response.getOutputStream());
	}

}
