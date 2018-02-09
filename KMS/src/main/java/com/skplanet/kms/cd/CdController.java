package com.skplanet.kms.cd;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
import org.springframework.web.servlet.ModelAndView;

import com.skplanet.kms.common.CommonService;
import com.skplanet.kms.common.DownloadView;
import com.skplanet.kms.login.LoginService;
import com.skplanet.kms.upload.UploadService;
import com.skplanet.kms.util.ListPage;


@Controller
public class CdController {
	
	private static final Logger logger = LoggerFactory.getLogger(CdController.class);
	
	
	
	@Autowired
	private LoginService loginService;
	@Autowired
	private CommonService commonService;
	@Autowired
	private CdService cdService;
	@Autowired
	private HttpServletRequest request;
	@Autowired
	private UploadService uploadService;
	@Value("#{commonProperties['file.upload.path']}")
	private String fileUploadPath;
	
	/*리스트화면으로*/
	@RequestMapping(value="/cd/cdList.do",method = RequestMethod.GET)
	public String cdList(@RequestParam Map<String,String> params, Model model){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("crAppointYn", loginService.getLoginVO(request).getCrAppointYn());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		List<Map<String,String>> trCateCdList = commonService.selectCodeList("BIZ_CD");
		
		/*본문*/
		ListPage listPage = new ListPage(params.get("pageNo"));
		
		params.put("firstRow", listPage.getFirstRow()+"");
		params.put("lastRow", listPage.getLastRow()+"");
		
		listPage.setTotalCount(cdService.selectCdCnt(params));
		listPage.setList(cdService.selectCdList(params));
		
		model.addAttribute("params",params);
		model.addAttribute("trCateCdList",trCateCdList);
		model.addAttribute("listPage",listPage);
		
		return "cd/cdList";
	}
	
	/*입력하기*/
	@RequestMapping(value="/cd/cdInsertAction.do",method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> cdInsertAction(@RequestParam Map<String,String>  params){

		String[] attachNormals = request.getParameterValues("ATT_NORMAL");
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		Map<String,String> returnMap = new HashMap<String,String>();
		if(((String)params.get("title")).equals(null) || ((String)params.get("title")) == ""){
			returnMap.put("result", "false");
			return returnMap;
		}
		
		int ret = cdService.insertCd(params,attachNormals);
		
		if(ret == 1){
			returnMap.put("result","true");
		}else{
			returnMap.put("result","false");
		}
		return returnMap;
	} 
	
	/*입력화면으로*/                                       
	@RequestMapping(value="/cd/cdInsert.do",method=RequestMethod.GET)
	public String cdInsert(@RequestParam Map<String,String> params,Model model){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		List<Map<String,String>> trCateCdList = commonService.selectCodeList("BIZ_CD");
		model.addAttribute("params",params);
		model.addAttribute("trCateCdList", trCateCdList);
		return "cd/cdInsert";
	}
	
	/*상세화면오로*/
	@RequestMapping(value="/cd/cdView.do",method=RequestMethod.GET)
	public String cdView(@RequestParam Map<String,String> params,Model model){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		cdService.updateCdHit(params);
		
		Map<String, Object> returnMap = new HashMap<String,Object>();
		returnMap = cdService.selectCdOne(params);
		
		
		//파일목록
		params.put("bid", params.get("bdId"));
		List<Map<String,Object>> attList = uploadService.selectAttachList(params);
		
		model.addAttribute("params",params);
		model.addAttribute("returnMap",returnMap);
		model.addAttribute("attList", attList);
		
	return "cd/cdView";	
	}
	
	/*수정화면으로*/
	@RequestMapping(value="/cd/cdUpdate.do",method=RequestMethod.GET)
	public String cdUpdate(@RequestParam Map<String,String> params,Model model){

		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		List<Map<String,String>> trCateCdList = commonService.selectCodeList("BIZ_CD");
		
		Map<String,Object> resultMap = cdService.selectCdOne(params);
		
		params.put("bid", params.get("bdId"));
		List<Map<String,Object>> attList = uploadService.selectAttachList(params);
		
		model.addAttribute("trCateCdList",trCateCdList);
		model.addAttribute("resultMap",resultMap);
		model.addAttribute("params",params);
		model.addAttribute("attList", attList);
		
		return "cd/cdUpdate";
	}

	/*수정하기*/
	@RequestMapping(value="/cd/cdUpdateAction.do",method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> cdUpdateAction(@RequestParam Map<String,String>  params,Model model){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		String[] attachNormals = request.getParameterValues("ATT_NORMAL");
		
		int ret =  cdService.updateCd(params,attachNormals);
		
		Map<String,String> returnMap = new HashMap<String,String>();
		if(ret >= 1){
			returnMap.put("result","true");
		}else{
			returnMap.put("result","false");
		}
		
		return returnMap;
	} 

	/*삭제*/
	@RequestMapping(value="/cd/cdDeleteAction.do",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> cdDeleteAction(@RequestParam Map<String,String> params){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		int ret = cdService.deleteCd(params);
		
		Map<String,String> returnMap = new HashMap<String,String>();
		if(ret== 1){
			returnMap.put("result","true");
		}else{
			returnMap.put("result","false");
		}
		return returnMap;
	}
	@RequestMapping(value="/cd/cdDownLoadAction.do",method=RequestMethod.POST)
	public ModelAndView cdDownLoadAction(@RequestParam Map<String,String> params, ModelAndView modelAndView){
	
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		//파일목록
		params.put("bid", params.get("bdId"));
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		List<Map<String,Object>> attList = uploadService.selectAttachList(params);
		
		File downloadFile = null;
		String orgFileNm = null;
		
		for( int i=0 ; i<attList.size();i++){
			downloadFile = new File(fileUploadPath + attList.get(i).get("FILE_PATH"));
			orgFileNm = (String)attList.get(i).get("ORG_FILE_NM");
		
			modelAndView.setView(new DownloadView());
			modelAndView.addObject("downloadFile", downloadFile);
			modelAndView.addObject("orgFileNm", orgFileNm);
		
		}
		return modelAndView;
	}
}
