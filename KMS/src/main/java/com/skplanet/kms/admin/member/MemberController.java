package com.skplanet.kms.admin.member;

import java.io.File;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.skplanet.kms.common.CommonService;
import com.skplanet.kms.common.JxlsView;
import com.skplanet.kms.login.LoginService;
import com.skplanet.kms.upload.UploadService;
import com.skplanet.kms.util.ListPage;
import com.skplanet.kms.util.SHA256;

import com.skplanet.kms.admin.member.CustomerExcelReader;
import com.skplanet.kms.admin.member.CustomerVo;


@Controller
public class MemberController {
	
	//private static final Logger logger = LoggerFactory.getLogger(MemberController.class);
	
	@Autowired
	HttpServletRequest request;
	
	@Autowired
	HttpServletResponse response;
	@Autowired
	private LoginService loginService;
	@Autowired
	private CommonService commonService;
	@Autowired
	private MemberService memberService;
	@Autowired
	private	UploadService uploadService;
	
	@Value("#{commonProperties['file.upload.path']}")
	private String fileUploadPath;

	private String  excelErrMsg=null;
	
	/***************************************************
	사용자관리 리스트
	***************************************************/
	@RequestMapping(value = "/admin/member/memberList.do", method = RequestMethod.GET)
	public String memberList(@RequestParam Map<String, String> params, Model model) {
			
		params.put("sessionId", loginService.getLoginVO(request).getMid());
		
		ListPage listPage = new ListPage(params.get("pageNo"));
		
		params.put("firstRow", listPage.getFirstRow()+"");
		params.put("lastRow", listPage.getLastRow()+"");
		
		listPage.setTotalCount(memberService.selectMemberCnt(params));
		
		listPage.setList(memberService.selectMemberList(params));
		 
		
		System.out.println("===========>" + params.get("searchSort"));
		
		
		model.addAttribute("params",params);
		model.addAttribute("listPage",listPage);
		return "admin/member/memberList";
	}
	
	/***************************************************
	사용자관리 입력화면
	***************************************************/                                   
	@RequestMapping(value="/admin/member/memberInsert.do",method=RequestMethod.GET)
	public String memberInsert(@RequestParam Map<String,String> params,Model model){
		
		params.put("sessionId", loginService.getLoginVO(request).getMid());
		
		List<Map<String,String>> posCdList = commonService.selectCodeList("POS_CD");
		List<Map<String,String>> teamCdList = memberService.selectTeamCodeList("TEA");
		List<Map<String,String>> cTeamCdList = memberService.selectTeamCodeList("CEN");
		
		model.addAttribute("params",params);
		model.addAttribute("posCdList", posCdList);
		model.addAttribute("teamCdList", teamCdList);
		model.addAttribute("cTeamCdList", cTeamCdList);
		return "admin/member/memberInsert";
	}
	/***************************************************
	사용자관리 상세화면(view/update)
	***************************************************/
	@RequestMapping(value="/admin/member/memberUpdate.do",method=RequestMethod.GET)
	public String memberView(@RequestParam Map<String,String> params,Model model){
		
		params.put("sessionId", loginService.getLoginVO(request).getMid());
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap = memberService.selectMemberOne(params);
		
		List<Map<String,String>> posCdList = commonService.selectCodeList("POS_CD");
		List<Map<String,String>> selectOnlyTeamCodeList = memberService.selectOnlyTeamCodeList((String)params.get("cTeamCd"));
		List<Map<String,String>> cTeamCdList = memberService.selectTeamCodeList("CEN");
		
		model.addAttribute("params",params);
		model.addAttribute("resultMap",resultMap);
		model.addAttribute("posCdList", posCdList);
		model.addAttribute("selectOnlyTeamCodeList", selectOnlyTeamCodeList);
		model.addAttribute("cTeamCdList", cTeamCdList);
	return "admin/member/memberUpdate";	
	}
	
	/*본부변경시 해당팀 검색하기*/
	@RequestMapping(value="/admin/member/changeCteamAction.do",method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String,String>> changeCteamAction(@RequestParam Map<String,String>  params){
		
		List<Map<String,String>> cTeamOnlyCdList=null;
		
		String str=(String)params.get("cTeamCd");
		 cTeamOnlyCdList = memberService.selectOnlyTeamCodeList(str);
		 //없음상황일시/없음을 선택시 팀또한 없음이 나와야 함
		 if(cTeamOnlyCdList.size()==0){
			 Map<String, String> map=new HashMap<String,String>();
			 map.put("CD","");
			 cTeamOnlyCdList.add(0,map );	 
		 }
		return cTeamOnlyCdList; 
	} 
	
	/*기존사용자인가 셀렉트하기*/
	@RequestMapping(value="/admin/member/midCheckAction.do",method = RequestMethod.POST)
	@ResponseBody
	public Boolean midCheckAction(@RequestParam Map<String,String>  params){
		
		Boolean resultCheck;
		
		int ret = memberService.selectMidCheck(params); 
		if(ret > 0){
			resultCheck = false;
		}else{
			resultCheck = true;
		}
	return resultCheck;
	}
	
	/*입력하기*/
	@RequestMapping(value="/admin/member/memberInsertAction.do",method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> memberInsertAction(@RequestParam Map<String,String>  params){
		
		params.put("sessionId", loginService.getLoginVO(request).getMid());
		params.put("passwd", SHA256.encrypt(params.get("birthDt")));
		
		if(params.get("crAppointYn") == null){
			params.put("crAppointYn","N" );	
		}
		if(params.get("kcAppointYn") == null){
			params.put("kcAppointYn","N" );	
		}
		if(params.get("loginAbleYn") == null){
			params.put("loginAbleYn","Y" );	
		}
		
		int ret = memberService.insertMember(params);
		
		Map<String,String> returnMap = new HashMap<String,String>();
		if(ret == 1){
			returnMap.put("result","true");
		}else{
			returnMap.put("result","false");
		}
		return returnMap;
	}
	
	/*수정하기*/
	@RequestMapping(value="/admin/member/memberUpdateAction.do",method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> memberUpdateAction(@RequestParam Map<String,String>  params){
		
		params.put("sessionMid", loginService.getLoginVO(request).getMid());
		//체크값이 널값이들어올경우
		if(params.get("crAppointYn") == null){
			params.put("crAppointYn","N" );	
		}
		if(params.get("kcAppointYn") == null){
			params.put("kcAppointYn","N" );	
		}
		if(params.get("loginAbleYn") == null){
			params.put("loginAbleYn","Y" );	
		}
		
		int ret = memberService.updateMember(params);
		
		Map<String,String> returnMap = new HashMap<String,String>();
		if(ret == 1){
			returnMap.put("result","true");
		}else{
			returnMap.put("result","false");
		}
		return returnMap;
	} 
	
	/*엑셀파일업로드*/
	@RequestMapping(value="/admin/member/memberUploadFile.do", method=RequestMethod.POST)
	@ResponseBody
	public void memberUploadFile(
			@RequestParam String spanId		/* 파일명이 표시될 영역 */
			, MultipartFile uploadFile){
		
		PrintWriter out = null;
		
		response.setContentType("text/html;charset=utf-8");
		
		Date now = Calendar.getInstance().getTime();
		
		String orgFileNm = uploadFile.getOriginalFilename();
		String uploadPath = "/" + new SimpleDateFormat("yyyyMM").format(now) + "/";
		String filePath = uploadPath + new SimpleDateFormat("yyyyMMddHHmmssFFF").format(now)+"."+getExt(orgFileNm);
		String uploadFilePath = fileUploadPath + filePath;

		try{
			out = response.getWriter();
			// 파일 확장자 체크
			if(
				 !"xls".equalsIgnoreCase(getExt(orgFileNm))
				&& !"xlsx".equalsIgnoreCase(getExt(orgFileNm))
			){
				out.println("<script>");
				out.println("alert('확장자:"+getExt(orgFileNm)+"는 허용된 파일형식이 아닙니다.[.xls/.xlsx 가능]');");
				out.println("</script>");
				return;
			}
			// 파일 사이즈 체크
			boolean fileSizeCk = true;
			if( uploadFile.getSize() > 10485760 ) fileSizeCk = false;
			if( !fileSizeCk ){
				out.println("<script>");
				out.println("alert('파일 크기는 10MB를 초과할 수 없습니다.');");
				out.println("</script>");
				return;
			}
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
	    	/****************************
	    	 * 엑셀업로드
	    	 * 출력:printList(xlsList );
	    	 * **************************/
			CustomerExcelReader excelReader = new CustomerExcelReader();
			List<CustomerVo> xlsList = null;
			//엑셀읽기
			if(getExt(orgFileNm).equals("xls")){
				xlsList = excelReader.xlsToCustomerVoList(fileUploadPath+filePath);
			}else{
				xlsList = excelReader.xlsxToCustomerVoList(fileUploadPath+filePath);
			}
			
			excelErrMsg = memberService.excelFileInsert(xlsList);
			String uploadSeq = uploadParams.get("uploadSeq");
			
			if(excelErrMsg.equals("OK")){
				out.println("<script>");
				out.println("parent.uploadCallBack('"+spanId+"','"+uploadSeq+"','"+orgFileNm+"','"+xlsList.size()+"');");
				out.println("</script>");
			}else{
				if(excelErrMsg.equals(null) || excelErrMsg.equals("")){
					excelErrMsg = "엑셀데이터 형식이 잘못되었습니다.[업로드 실패]";
				}
				out.println("<script>");
				out.println("parent.uploadCallBackError('"+excelErrMsg+"');");
				out.println("</script>");
			}
		}catch(Exception e){
			
			out.println("<script>");
			out.println("parent.uploadCallBackError('"+excelErrMsg+"');");
			out.println("</script>");
		}	
	}
	
	private String getExt(String fileName){
		if(fileName.indexOf(".")>-1){
			return fileName.substring(fileName.lastIndexOf(".")+1);
		}else{
			return "";
		}
	}
	
	/***************************************************
	admin관리자 리스트
	***************************************************/
	@RequestMapping(value = "/admin/member/admMemberList.do", method = RequestMethod.GET)
	public String admMemberList(@RequestParam Map<String, String> params, Model model) {
		params.put("sessionId", loginService.getLoginVO(request).getMid());
		
		ListPage listPage = new ListPage(params.get("pageNo"));
		params.put("firstRow", listPage.getFirstRow()+"");
		params.put("lastRow", listPage.getLastRow()+"");
		listPage.setTotalCount(memberService.selectAdmMemberCnt(params));
		
		List <Map<String,Object>> str =memberService.selectAdmMemberList(params);
		listPage.setList(str);
		
		model.addAttribute("params",params);
		model.addAttribute("listPage",listPage);
		
		return "admin/admMember/admMemberList";
	}
	/***************************************************
	admin관리자 입력화면
	***************************************************/                   
	@RequestMapping(value="/admin/member/admMemberInsert.do",method=RequestMethod.GET)
	public String admMemberInsert(@RequestParam Map<String,String> params,Model model){
		params.put("sessionId", loginService.getLoginVO(request).getMid());
		model.addAttribute("params",params);
		
		return "admin/admMember/admMemberInsert";
	}
	/***************************************************
	admin관리자 상세화면 : view/update ui 같이사용함
	***************************************************/
	
	@RequestMapping(value="/admin/member/admMemberUpdate.do",method=RequestMethod.GET)
	public String admMemberUpdate(@RequestParam Map<String,String> params,Model model){
		params.put("sessionId", loginService.getLoginVO(request).getMid());
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap = memberService.selectAdmMemberOne(params);
		
		model.addAttribute("params",params);
		model.addAttribute("resultMap",resultMap);
	return "admin/admMember/admMemberUpdate";	
	}
	/*기존사용자인가 셀렉트하기*/
	@RequestMapping(value="/admin/member/admMidCheckAction.do",method = RequestMethod.POST)
	@ResponseBody
	public Boolean admMidCheckAction(@RequestParam Map<String,String>  params){
		
		Boolean resultCheck;
		int ret = memberService.selectAdmMidCheck(params); 
		if(ret > 0){
			resultCheck = false;
		}else{
			resultCheck = true;
		}
	return resultCheck;
	}
	/*insert GoGo*/
	@RequestMapping(value="/admin/member/admMemberInsertAction.do",method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> admMemberInsertAction(@RequestParam Map<String,String>  params){
		
		params.put("sessionId", loginService.getLoginVO(request).getMid());
		params.put("passwd", SHA256.encrypt(params.get("passwd")));
		if(params.get("loginAbleYn").equals("Y")){
			params.put("loginAbleYn","Y" );	
		}else{
			params.put("loginAbleYn","N" );
		}
		
		params.put("divCd"," " );
		params.put("posCd"," " );
		int ret = memberService.insertAdmMember(params);
		Map<String,String> returnMap = new HashMap<String,String>();
		if(ret == 1){
			returnMap.put("result","true");
		}else{
			returnMap.put("result","false");
		}
		return returnMap;
	}
	/*update GoGo*/
	@RequestMapping(value="/admin/member/admMemberUpdateAction.do",method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> admMemberUpdateAction(@RequestParam Map<String,String>  params){
		
		params.put("sessionMid", loginService.getLoginVO(request).getMid());
		if(params.get("admPasswd") == null || params.get("admPasswd") == ""){
			params.put("passwd",params.get("admPasswd"));
		}else{
			params.put("passwd", SHA256.encrypt(params.get("admPasswd")));	
		}
		
		if(!params.get("loginAbleYn").equals("Y")){
			params.put("loginAbleYn","N" );	
		}else{
			params.put("loginAbleYn","Y" );
		}
		params.put("divCd"," " );
		params.put("posCd"," " );
		
		int ret = memberService.updateAdmMember(params);
		
		Map<String,String> returnMap = new HashMap<String,String>();
		if(ret == 1){
			returnMap.put("result","true");
		}else{
			returnMap.put("result","false");
		}
		return returnMap;
	} 
	
	

	@RequestMapping(value = "/admin/member/memberListExcel.do", method = RequestMethod.GET)
	public ModelAndView memberListExcel(@RequestParam Map<String, String> params, Model model, ModelMap modelMap) {

		ListPage listPage = new ListPage(params.get("pageNo"));

		
		listPage.setTotalCount(memberService.selectMemberCnt(params));
		
		/* 엑셀은 페이징 없이 전체 검색결과를 출력 */
		params.put("firstRow", "1");
		params.put("lastRow", listPage.getTotalCount()+"");

		listPage.setList(memberService.selectMemberList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("listPage", listPage);
		
		// 엑셀로 출력
		model.addAttribute("viewName", "memberList");
		model.addAttribute("fileName", "memberList");
		model.addAttribute("sf", new SimpleDateFormat("yyyy-MM-dd"));
		model.addAttribute("listPage", listPage);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setView(new JxlsView());
		modelAndView.addAllObjects(modelMap);
		return modelAndView;
	}
}
