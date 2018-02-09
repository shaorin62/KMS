package com.skplanet.kms.pt;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.skplanet.kms.common.CommonService;
import com.skplanet.kms.common.JxlsView;
import com.skplanet.kms.common.PointTyp;
import com.skplanet.kms.login.LoginService;
import com.skplanet.kms.popup.PopupService;
import com.skplanet.kms.upload.UploadService;
import com.skplanet.kms.util.BASE64;
import com.skplanet.kms.util.ListPage;


@Controller
public class PtController {

	private static final Logger logger = LoggerFactory.getLogger(PtController.class);
	
	@Autowired
	private LoginService loginService;
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private PopupService popupService;
	
	@Autowired
	private UploadService uploadService;
	
	@Autowired
	private PtService ptService;
	
	@Autowired
	private HttpServletRequest request;
	
	@RequestMapping(value = "/pt/ptList.do", method = RequestMethod.GET)
	public String ptList(@RequestParam Map<String, String> params, Model model) {
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		List<Map<String,String>> bizList = commonService.selectCodeList("BIZ_CD");
		List<Map<String,String>> ptResultList = commonService.selectCodeList("PT_RESULT_CD");
		List<Map<String,String>> rivalList = commonService.selectCodeListOrderName("RIVAL_CD");
		
		
		if(params.get("ptCateCd")==null || "".equals(params.get("ptCateCd"))){
			// 디폴트 탭 타사자료
			params.put("ptCateCd", "PT_00001");
		}
		
		
		ListPage listPage = new ListPage(params.get("pageNo"));
		params.put("firstRow", listPage.getFirstRow()+"");
		params.put("lastRow", listPage.getLastRow()+"");
		listPage.setTotalCount(ptService.selectPtCnt(params));
		listPage.setList(ptService.selectPtList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("bizList", bizList);
		model.addAttribute("ptResultList", ptResultList);
		model.addAttribute("rivalList", rivalList);
		model.addAttribute("listPage", listPage);
		
		return "pt/ptList";
	}

	@RequestMapping(value = "/pt/ptListExcel.do", method = RequestMethod.GET)
	public ModelAndView ptListExcel(@RequestParam Map<String, String> params, Model model, ModelMap modelMap) {
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		List<Map<String,String>> bizList = commonService.selectCodeList("BIZ_CD");
		List<Map<String,String>> ptResultList = commonService.selectCodeList("PT_RESULT_CD");
		List<Map<String,String>> rivalList = commonService.selectCodeListOrderName("RIVAL_CD");
		
		ListPage listPage = new ListPage(params.get("pageNo"));
		
		listPage.setTotalCount(ptService.selectPtCnt(params));
		
		/* 엑셀은 페이징 없이 전체 검색결과를 출력 */
		params.put("firstRow", "1");
		params.put("lastRow", listPage.getTotalCount()+"");
		
		listPage.setList(ptService.selectPtList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("bizList", bizList);
		model.addAttribute("ptResultList", ptResultList);
		model.addAttribute("rivalList", rivalList);
		model.addAttribute("listPage", listPage);

		// 엑셀로 출력
		model.addAttribute("viewName", "ptList");
		model.addAttribute("fileName", "ptList");
		model.addAttribute("sf", new SimpleDateFormat("yyyy-MM-dd"));
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setView(new JxlsView());
		modelAndView.addAllObjects(modelMap);
		return modelAndView;
	}
	
	@RequestMapping(value = "/pt/ptView.do", method = RequestMethod.GET)
	public String ptView(@RequestParam Map<String, String> params, Model model) {
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		Map<String,Object> pt = ptService.selectPt(params);
		List<Map<String,Object>> rivalList = ptService.selectPtRivalList(params);
		
		params.put("bid", params.get("ptId"));
		List<Map<String,Object>> attList = uploadService.selectAttachList(params);
		
		//------------------------------------------------StreamDocs 작업---------------------------------------------------
		for(int i =0; i < attList.size(); i++){
			String orgFileNm = attList.get(i).get("ORG_FILE_NM").toString();
			
			//영상 파일
			if("avi".equalsIgnoreCase(getExt(orgFileNm))
				|| "mp4".equalsIgnoreCase(getExt(orgFileNm))
				|| "wmv".equalsIgnoreCase(getExt(orgFileNm))
				|| "mpg".equalsIgnoreCase(getExt(orgFileNm))
				|| "mpeg".equalsIgnoreCase(getExt(orgFileNm))
				|| "mov".equalsIgnoreCase(getExt(orgFileNm))){
				
				String Filepath = attList.get(i).get("FILE_PATH").toString();
				
			    //URL 인코딩
				try {
					attList.get(i).put("Viewinfo", URLEncoder.encode(Filepath, "UTF-8"));
				} catch (UnsupportedEncodingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}else{
				//이외의 파일
				String Filepath = attList.get(i).get("FILE_PATH").toString();
				String Username = loginService.getLoginVO(request).getMemberNm();
				String Userid = loginService.getLoginVO(request).getMid();
				//StreamDocs 자료 만들기
				String Viewinfo = StreamDocsView(Filepath, Username, Userid);
				attList.get(i).put("Viewinfo", Viewinfo);
				
			}
			
			
			System.out.println("=============확인 용=============" + attList.get(i).get("Viewinfo").toString() );
			
		}
		//------------------------------------------------StreamDocs 작업---------------------------------------------------
		
		
		
		model.addAttribute("params", params);
		model.addAttribute("pt", pt);
		model.addAttribute("rivalList", rivalList);
		model.addAttribute("attList", attList);
		
		ptService.updateHit(params);
		
		return "pt/ptView";
	}
	
	@RequestMapping(value = "/pt/ptViewExcel.do", method = RequestMethod.GET)
	public ModelAndView ptViewExcel(@RequestParam Map<String, String> params, Model model, ModelMap modelMap) {
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		Map<String,Object> pt = ptService.selectPt(params);
		List<Map<String,Object>> rivalList = ptService.selectPtRivalList(params);
		
		params.put("bid", params.get("ptId"));
		//엑셀에서 파일명 가져와야 해서  한문장으로 일단 수정 
		//List<Map<String,Object>> attList = uploadService.selectAttachList(params);
		List<Map<String,Object>> attList = uploadService.selectAttachListPTRow(params);
		
		model.addAttribute("params", params);
		model.addAttribute("pt", pt);
		model.addAttribute("rivalList", rivalList);
		model.addAttribute("attList", attList);
		
		// 엑셀로 출력
		model.addAttribute("viewName", "ptView");
		model.addAttribute("fileName", "ptView");
		model.addAttribute("sf", new SimpleDateFormat("yyyy-MM-dd"));
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setView(new JxlsView());
		modelAndView.addAllObjects(modelMap);
		return modelAndView;		
	}
	
	@RequestMapping(value = "/pt/ptInsert.do", method = RequestMethod.GET)
	public String ptInsert(@RequestParam Map<String, String> params, Model model) {
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		List<Map<String,String>> bizList = commonService.selectCodeList("BIZ_CD");
		List<Map<String,String>> ptTypList = commonService.selectCodeList("PT_TYP_CD");
		List<Map<String,String>> ptResultList = commonService.selectCodeList("PT_RESULT_CD");
		

		System.out.println("===============>" + params.get("ptCateCd"));
		
		model.addAttribute("params", params);
		model.addAttribute("bizList", bizList);
		model.addAttribute("ptTypList", ptTypList);
		model.addAttribute("ptResultList", ptResultList);	
		
		return "pt/ptInsert";
	}
	
	@RequestMapping(value = "/pt/ptInsertAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> ptInsertAction(@RequestParam Map<String, String> params){
		
		String[] rivalCds = request.getParameterValues("rivalCd");
		String[] attachNormals = request.getParameterValues("ATT_NORMAL");
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		int ret = ptService.insertPt(params, rivalCds, attachNormals);
		
		// 제출 포인트 적립
		if(ret==1 && "Y".equals(params.get("submitYn"))){
			commonService.insertRegPoint(PointTyp.POI_PT_SUBMIT, params.get("mid"), params.get("ptId"));
		}
		
		Map<String, String> returnMap = new HashMap<String, String>();
		
		if(ret==1){
			returnMap.put("result", "true");
		}
		else{
			returnMap.put("result", "false");
		}
		
		return returnMap;
	}
	
	@RequestMapping(value = "/pt/ptUpdate.do", method = RequestMethod.GET)
	public String ptUpdate(@RequestParam Map<String, String> params, Model model) {
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		List<Map<String,String>> bizList = commonService.selectCodeList("BIZ_CD");
		List<Map<String,String>> ptTypList = commonService.selectCodeList("PT_TYP_CD");
		List<Map<String,String>> ptResultList = commonService.selectCodeList("PT_RESULT_CD");
		
		Map<String,Object> pt = ptService.selectPt(params);
		List<Map<String,Object>> rivalList = ptService.selectPtRivalList(params);
		
		params.put("bid", params.get("ptId"));
		List<Map<String,Object>> attList = uploadService.selectAttachList(params);
		
		model.addAttribute("params", params);
		model.addAttribute("bizList", bizList);
		model.addAttribute("ptTypList", ptTypList);		
		model.addAttribute("ptResultList", ptResultList);	
		model.addAttribute("pt", pt);
		model.addAttribute("rivalList", rivalList);
		model.addAttribute("attList", attList);
		
		return "pt/ptUpdate";
	}
	
	@RequestMapping(value = "/pt/ptUpdateAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> ptUpdateAction(@RequestParam Map<String, String> params){
		
		logger.debug(params.toString());
		
		String[] rivalCds = request.getParameterValues("rivalCd");
		String[] attachNormals = request.getParameterValues("ATT_NORMAL");
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		int ret = ptService.updatePt(params, rivalCds, attachNormals);
		
		// 제출 포인트 적립
		if(ret==1 && "Y".equals(params.get("submitYn"))){
			commonService.insertRegPoint(PointTyp.POI_PT_SUBMIT, params.get("mid"), params.get("ptId"));
		}
		
		Map<String, String> returnMap = new HashMap<String, String>();
		
		if(ret==1){
			returnMap.put("result", "true");
		}
		else{
			returnMap.put("result", "false");
			returnMap.put("msg", "시스템 오류 입니다. 잠시 후 다시 시도해 주세요.");
		}
		
		return returnMap;
	}
	
	@RequestMapping(value = "/pt/docOpenDtUpdateAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> docOpenDtUpdateAction(@RequestParam Map<String, String> params){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		int ret = ptService.updateDocOpenDt(params);
		
		Map<String, String> returnMap = new HashMap<String, String>();
		
		if(ret==1){
			returnMap.put("result", "true");
		}
		else{
			returnMap.put("result", "false");
			returnMap.put("msg", "시스템 오류 입니다. 잠시 후 다시 시도해 주세요.");
		}
		
		return returnMap;
	}
	
	@RequestMapping(value = "/pt/ptDeleteAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> ptDeleteAction(@RequestParam Map<String, String> params){

		params.put("mid", loginService.getLoginVO(request).getMid());
		
		int ret = ptService.deletePt(params);
		
		Map<String, String> returnMap = new HashMap<String, String>();
		
		if(ret==1){
			returnMap.put("result", "true");
		}
		else{
			returnMap.put("result", "false");
			returnMap.put("msg", "시스템 오류 입니다. 잠시 후 다시 시도해 주세요.");
		}
		
		return returnMap;
	}
	
	@RequestMapping(value = "/pt/lessonUpdateAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> lessonUpdateAction(@RequestParam Map<String, String> params){
		
		logger.debug(params.toString());
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		int ret = ptService.updateLesson(params);
		
		Map<String, String> returnMap = new HashMap<String, String>();
		
		if(ret==1){
			returnMap.put("result", "true");
		}
		else{
			returnMap.put("result", "false");
		}
		
		return returnMap;
	}
	

	public String StreamDocsView(String Filepath, String Username, String Userid) {

		String viewinfo ="";
			
		    viewinfo = Filepath + ";" + Username + ";" + Userid ;
		    //Base64인코딩
			viewinfo = BASE64.encrypt64(viewinfo);
		    //URL 인코딩
			try {
				viewinfo = URLEncoder.encode(viewinfo, "UTF-8");
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		
		return viewinfo;
	}
	
	private String getExt(String fileName){
		if(fileName.indexOf(".")>-1){
			return fileName.substring(fileName.lastIndexOf(".")+1);
		}else{
			return "";
		}
	}
	
}
