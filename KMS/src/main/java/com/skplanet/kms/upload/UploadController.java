package com.skplanet.kms.upload;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tika.metadata.Metadata;
import org.apache.tika.parser.AutoDetectParser;
import org.apache.tika.parser.ParseContext;
import org.apache.tika.parser.Parser;
import org.apache.tika.sax.BodyContentHandler;
import org.bouncycastle.asn1.cms.MetaData;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.skplanet.kms.common.CommonService;
import com.skplanet.kms.common.DownloadView;
import com.skplanet.kms.common.PointTyp;
import com.skplanet.kms.login.LoginService;

@Controller
public class UploadController {

	private static final Logger logger = LoggerFactory.getLogger(UploadController.class);

	@Autowired
	HttpServletRequest request;
	
	@Autowired
	HttpServletResponse response;
	
	@Value("#{commonProperties['file.upload.path']}")
	private String fileUploadPath;
	
	@Autowired
	private LoginService loginService;
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private	UploadService uploadService;
	
	@RequestMapping(value="/upload/uploadFile.do", method=RequestMethod.POST)
	@ResponseBody
	public void uploadFile(
			@RequestParam String spanId		/* 파일명이 표시될 영역 */
			, MultipartFile uploadFile){
		
		PrintWriter out = null;
		
		response.setContentType("text/html;charset=utf-8");
		
		Date now = Calendar.getInstance().getTime();
		
		String orgFileNm = uploadFile.getOriginalFilename();
		String uploadPath = "/" + new SimpleDateFormat("yyyyMM").format(now) + "/";
		String filePath = uploadPath + new SimpleDateFormat("yyyyMMddHHmmssSSS").format(now)+"."+getExt(orgFileNm);
		String uploadFilePath = fileUploadPath + filePath;

		try{
			out = response.getWriter();
			
			// 파일 확장자 체크
			if(
				!"jpg".equalsIgnoreCase(getExt(orgFileNm))
				&& !"png".equalsIgnoreCase(getExt(orgFileNm))
				&& !"jpeg".equalsIgnoreCase(getExt(orgFileNm))				
				&& !"gif".equalsIgnoreCase(getExt(orgFileNm))
				&& !"bmp".equalsIgnoreCase(getExt(orgFileNm))
				&& !"avi".equalsIgnoreCase(getExt(orgFileNm))
				&& !"mpg".equalsIgnoreCase(getExt(orgFileNm))		
				&& !"mpeg".equalsIgnoreCase(getExt(orgFileNm))	
				&& !"mov".equalsIgnoreCase(getExt(orgFileNm))
				&& !"mp4".equalsIgnoreCase(getExt(orgFileNm))
				&& !"wmv".equalsIgnoreCase(getExt(orgFileNm))				
				&& !"doc".equalsIgnoreCase(getExt(orgFileNm))
				&& !"docx".equalsIgnoreCase(getExt(orgFileNm))
				&& !"ppt".equalsIgnoreCase(getExt(orgFileNm))
				&& !"pptx".equalsIgnoreCase(getExt(orgFileNm))
				&& !"xls".equalsIgnoreCase(getExt(orgFileNm))
				&& !"xlsx".equalsIgnoreCase(getExt(orgFileNm))
				&& !"pdf".equalsIgnoreCase(getExt(orgFileNm))
				&& !"hwp".equalsIgnoreCase(getExt(orgFileNm))
			){
				out.println("<script>");
				out.println("alert('"+getExt(orgFileNm)+" 형식의 파일은 업로드 하실 수 없습니다.');");
				out.println("parent.uploadCallBack();");
				out.println("</script>");
				return;
			}
			
			// 파일 사이즈 체크
			boolean fileSizeCk = true;
			if( uploadFile.getSize() > 2147483647 ) fileSizeCk = false;
			if( !fileSizeCk ){
				out.println("<script>");
				out.println("alert('파일 크기는 2GB를 초과할 수 없습니다.');");
				out.println("parent.uploadCallBack();");
				out.println("</script>");
				return;
			}
			
			/*if(spanId.startsWith("ATT_PT")){
				// PT 리포트 파일 내용 체크 (암호화 여부)
				if(
					"doc".equalsIgnoreCase(getExt(orgFileNm))
					|| "docx".equalsIgnoreCase(getExt(orgFileNm))
					|| "ppt".equalsIgnoreCase(getExt(orgFileNm))
					|| "pptx".equalsIgnoreCase(getExt(orgFileNm))
					|| "xls".equalsIgnoreCase(getExt(orgFileNm))
					|| "xlsx".equalsIgnoreCase(getExt(orgFileNm))
					|| "pdf".equalsIgnoreCase(getExt(orgFileNm))						
				){
					// 암호화가 안되어 식별할 수 있는 파일이면
					if(!isEncrypted(uploadFile.getInputStream())){
						out.println("<script>");
						out.println("alert('문서파일이 암호화 되어 있지 않습니다.');");
						out.println("parent.uploadCallBack();");
						out.println("</script>");
						return;					
					}
				}
			}*/
			
			// 업로드 폴더가 없으면 만들기
			File uploadFolder = new File(fileUploadPath+uploadPath);
	    	if (!uploadFolder.exists() || !uploadFolder.isFile()) {
	    		uploadFolder.mkdirs();
	    		// WEB 서버에서 접근 가능하도록 권한 부여
	    		uploadFolder.setReadable(true,false);
	    		uploadFolder.setExecutable(true, false);
	    	}
	    	
	    	// 업로드
	    	File serverFile = new File(uploadFilePath);
	    	uploadFile.transferTo(serverFile);
	    	// WEB 서버에서 접근 가능하도록 권한 부여
	    	serverFile.setReadable(true,false);
			
	    	// 업로드 테이블에 인서트
	    	Map<String,String> uploadParams = new HashMap<String,String>();
	    	uploadParams.put("mid", loginService.getLoginVO(request).getMid());
	    	uploadParams.put("filePath", filePath);
	    	uploadParams.put("orgFileNm", orgFileNm);
	    	
	    	uploadService.insertUpload(uploadParams);
	    	
	    	String uploadSeq = uploadParams.get("uploadSeq");
			out.println("<script>");
			out.println("parent.uploadCallBack('"+spanId+"','"+uploadSeq+"','"+orgFileNm+"','"+filePath+"');");
			out.println("</script>");
	    	
		}catch(Exception e){
			logger.error(e.getLocalizedMessage());
			out.println("<script>");
			out.println("alert('업로드 오류입니다.');");
			out.println("parent.uploadCallBack();");
			out.println("</script>");
		}
	}
	
	@RequestMapping(value="/upload/downloadFile.do", method=RequestMethod.GET)
	public ModelAndView downloadFile(@RequestParam Map<String, String> params, Model model){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		Map<String,Object> attach = uploadService.selectAttach(params);
		
		File downloadFile = null;
		String orgFileNm = null;
		
		if(attach!=null){
			downloadFile = new File(fileUploadPath + attach.get("FILE_PATH"));
			
			//다운로드 경로 풀path
			System.out.println("fileUploadPath ==> " + downloadFile);
			//워터마크 사명 사번 이름
			System.out.println("FILE_PATH ==> " + "SK Planet"+ loginService.getLoginVO(request).getMid() + loginService.getLoginVO(request).getMemberNm());
			
			orgFileNm = (String)attach.get("ORG_FILE_NM");
			
			uploadService.insertDownLog((String)attach.get("TB"), params.get("bid"), params.get("uploadSeq"),params.get("mid"));
			
			// TR 첨부파일 다운로드 시 포인트 적립
			if("TR".equals(attach.get("TB"))){
				// 타사자료
				if("TRC_00001".equals(attach.get("TR_CATE_CD"))){
					commonService.insertViewPoint(PointTyp.POI_OTHER_VIEW, params.get("mid"), params.get("bid"), (String)attach.get("BD_REG_ID"));
				}
				// 일반자료
				else{
					commonService.insertViewPoint(PointTyp.POI_TR_VIEW, params.get("mid"), params.get("bid"), (String)attach.get("BD_REG_ID"));
				}							
			}
			
		}
		
		logger.debug("downloadFile:"+fileUploadPath + attach.get("FILE_PATH"));
		logger.debug("downloadFile:"+downloadFile);
		logger.debug("orgFileNm:"+orgFileNm);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setView(new DownloadView());
		modelAndView.addObject("downloadFile", downloadFile);
		modelAndView.addObject("orgFileNm", orgFileNm);
		
		return modelAndView;
	}
	
	private String getExt(String fileName){
		if(fileName.indexOf(".")>-1){
			return fileName.substring(fileName.lastIndexOf(".")+1);
		}else{
			return "";
		}
	}
	
	private boolean isEncrypted(InputStream is){
		boolean ret = false;
		
		try{
			Parser parser = new AutoDetectParser();
			BodyContentHandler handler = new BodyContentHandler(10000000);
			Metadata metadata = new Metadata();
			InputStream content = is;
			parser.parse(content, handler, metadata, new ParseContext());
			String contentType = metadata.get("Content-Type");
			
			if("application/octet-stream".equals(contentType)){
				ret = true;
			}
			else{
				ret = false;
			}
			
		}catch(Exception e){
			logger.error(e.getLocalizedMessage());
			ret = false;
		}
		
		return ret;
	}
}
