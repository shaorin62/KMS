package com.skplanet.kms.kc;

import java.io.PrintWriter;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

import com.skplanet.kms.common.CommonService;
import com.skplanet.kms.login.LoginService;
import com.skplanet.kms.upload.UploadService;
import com.skplanet.kms.util.ListPage;


@Controller
public class KcController {
	
	private static final Logger logger = LoggerFactory.getLogger(KcController.class);
	
	
	@Autowired
	HttpServletResponse response;
	@Autowired
	private LoginService loginService;
	@Autowired
	private CommonService commonService;
	@Autowired
	private KcService kcService;
	@Autowired
	private HttpServletRequest request;
	@Autowired
	private UploadService uploadService;
	@Value("#{commonProperties['file.upload.path']}")
	private String fileUploadPath;

	/*리스트화면으로*/
	@RequestMapping(value="/kc/kcList.do",method = RequestMethod.GET)
	public String haList(@RequestParam Map<String,String> params, Model model){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("kcAppointYn", loginService.getLoginVO(request).getKcAppointYn());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		//본문
		ListPage listPage = new ListPage(params.get("pageNo"));
		
		params.put("firstRow", listPage.getFirstRow()+"");
		params.put("lastRow", listPage.getLastRow()+"");
		params.put("fileUploadPath",fileUploadPath);
		
		listPage.setTotalCount(kcService.selectKcCnt(params));
		listPage.setList(kcService.selectKcList(params));
		
		model.addAttribute("listPage",listPage);	
		model.addAttribute("params",params);
		
		return "kc/kcList";
	}
	
	/*입력하기*/
	@RequestMapping(value="/kc/kcInsertAction.do",method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> kcInsertAction(@RequestParam Map<String,String>  params){
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		String attachNormals = params.get("ATT_NORMAL");
		
		Map<String,String> returnMap = new HashMap<String,String>();
		if(((String)params.get("title")).equals(null) || ((String)params.get("title")) == ""){
			returnMap.put("result", "false");
			return returnMap;
		}
		
		int ret = kcService.insertKc(params,attachNormals);
		
		if(ret == 1){
			returnMap.put("result","true");
		}else{
			returnMap.put("result","false");
		}
		return returnMap;
		
	} 
	
	/*입력화면으로*/                                       
	@RequestMapping(value="/kc/kcInsert.do",method=RequestMethod.GET)
	public String kcInsert(@RequestParam Map<String,String> params,Model model){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		model.addAttribute("params",params);
	return "kc/kcInsert";
	}
	
	/*상세화면으로*/
	@RequestMapping(value="/kc/kcView.do",method=RequestMethod.GET)
	public String kcView(@RequestParam Map<String,String> params,Model model){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		Map<String, Object> returnMap = new HashMap<String,Object>();
		returnMap = kcService.selectKcOne(params);
		//파일목록
		params.put("bid", params.get("bdId"));
		List<Map<String,Object>> attList = uploadService.selectAttachList(params);
				
		model.addAttribute("params",params);
		model.addAttribute("returnMap",returnMap);
		model.addAttribute("attList", attList);
		
	return "kc/kcView";	
	}
	
	/*수정화면으로*/
	@RequestMapping(value="/kc/kcUpdate.do",method=RequestMethod.GET)
	public String kcUpdate(@RequestParam Map<String,String> params,Model model){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		Map<String,Object> resultMap = kcService.selectKcOne(params);
		
		params.put("bid", params.get("bdId"));
		List<Map<String,Object>> attList = uploadService.selectAttachList(params);
		
		//download
		File downloadFile =null;
		String orgFileNm = null;
		String filePath =null;
		
		for( int i=0 ; i<attList.size();i++){
			downloadFile = new File(fileUploadPath + attList.get(i).get("FILE_PATH"));
			orgFileNm = (String)attList.get(i).get("ORG_FILE_NM");
			filePath =(String)attList.get(i).get("FILE_PATH");
		}
		
		resultMap.put("filePath",filePath);
		resultMap.put("fileUploadPath", (String)fileUploadPath);
		model.addAttribute("resultMap",resultMap);
		model.addAttribute("params",params);
		model.addAttribute("attList", attList);
		
		return "kc/kcUpdate";
	}
	
	
	@RequestMapping(value="/kc/kcOneImgAction.do",method = RequestMethod.POST)
	@ResponseBody
	public  Map<String,Object>  kcOneImgAction(@RequestParam Map<String,String>  params) {
		PrintWriter out = null;
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		response.setContentType("text/html;charset=utf-8");
		
		Map<String,Object> resultMap = kcService.oneImgKc(params);
		
		String UPLOAD_SEQ = (String)resultMap.get("UPLOAD_SEQ");
		String FILE_PATH =  (String)resultMap.get("FILE_PATH");
		String ORG_FILE_NM =  (String)resultMap.get("ORG_FILE_NM");
		 
		resultMap.put("UPLOAD_SEQ",UPLOAD_SEQ);
		resultMap.put("FILE_PATH",FILE_PATH);
		resultMap.put("ORG_FILE_NM",ORG_FILE_NM);
		resultMap.put("fileUploadPath",fileUploadPath);
		
		return resultMap;
	}
	/*수정하기*/
	@RequestMapping(value="/kc/kcUpdateAction.do",method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> haUpdateAction(@RequestParam Map<String,String>  params){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		String attachNormals = params.get("ATT_NORMAL");
		
		int ret = kcService.updateKc(params,attachNormals);
		
		Map<String,String> returnMap = new HashMap<String,String>();
		if(ret == 1){
			returnMap.put("result","true");
		}else{
			returnMap.put("result","false");
		}
		return returnMap;
		
	} 
	/*삭제*/
	@RequestMapping(value="/kc/kcDeleteAction.do",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> kcDeleteAction(@RequestParam Map<String,String> params){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		
		int ret = kcService.deleteKc(params);
		
		Map<String,String> returnMap = new HashMap<String,String>();
		if(ret == 1){
			returnMap.put("result","true");
		}else{
			returnMap.put("result","false");
		}
		return returnMap;
	}
}
