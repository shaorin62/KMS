package com.skplanet.kms.virtual;

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
import com.skplanet.kms.util.ListPage;

@Controller
public class VirtualController {

	private static final Logger logger = LoggerFactory.getLogger(VirtualController.class);
	
	@Autowired
	private LoginService loginService;
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private PopupService popupService;
	
	@Autowired
	private VirtualService virtualService;
	
	@Autowired
	private HttpServletRequest request;
	
	@RequestMapping(value = "/virtual/vcList.do", method = RequestMethod.GET)
	public String vcList(@RequestParam Map<String, String> params, Model model) {
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		List<Map<String,String>> contactPathList = commonService.selectCodeList("CONTACT_PATH_CD");
		List<Map<String,String>> bizList = commonService.selectCodeList("BIZ_CD");
		
		ListPage listPage = new ListPage(params.get("pageNo"));
		params.put("firstRow", listPage.getFirstRow()+"");
		params.put("lastRow", listPage.getLastRow()+"");
		listPage.setTotalCount(virtualService.selectVirtualCnt(params));
		listPage.setList(virtualService.selectVirtualList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("contactPathList", contactPathList);
		model.addAttribute("bizList", bizList);
		model.addAttribute("listPage", listPage);
		
		return "virtual/vcList";
	}
	
	@RequestMapping(value = "/virtual/vcListExcel.do", method = RequestMethod.GET)
	public ModelAndView vcListExcel(@RequestParam Map<String, String> params, Model model, ModelMap modelMap) {

		params.put("mid", loginService.getLoginVO(request).getMid());
		
		List<Map<String,String>> contactPathList = commonService.selectCodeList("CONTACT_PATH_CD");
		List<Map<String,String>> bizList = commonService.selectCodeList("BIZ_CD");
		
		ListPage listPage = new ListPage(params.get("pageNo"));

		listPage.setTotalCount(virtualService.selectVirtualCnt(params));
		
		/* 엑셀은 페이징 없이 전체 검색결과를 출력 */
		params.put("firstRow", "1");
		params.put("lastRow", listPage.getTotalCount()+"");

		listPage.setList(virtualService.selectVirtualList(params));		
		
		// 엑셀로 출력
		model.addAttribute("viewName", "vcList");
		model.addAttribute("fileName", "vcList");
		model.addAttribute("sf", new SimpleDateFormat("yyyy-MM-dd"));
		model.addAttribute("listPage", listPage);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setView(new JxlsView());
		modelAndView.addAllObjects(modelMap);
		return modelAndView;
	}
	
	@RequestMapping(value = "/virtual/vcView.do", method = RequestMethod.GET)
	public String vcView(@RequestParam Map<String, String> params, Model model) {
		
		params.put("mid", loginService.getLoginVO(request).getMid());

		model.addAttribute("params", params);
		model.addAttribute("vc", virtualService.selectVirtual(params));
		model.addAttribute("authList", virtualService.selectVirtualAuthList(params));
		model.addAttribute("fuList", virtualService.selectFuList(params));
		
		virtualService.updateHit(params);
		
		return "virtual/vcView";
	}
	
	@RequestMapping(value = "/virtual/vcInsert.do", method = RequestMethod.GET)
	public String vcInsert(@RequestParam Map<String, String> params, Model model) {
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		List<Map<String,String>> clientList = commonService.selectCodeList("CLIENT_CD");
		List<Map<String,String>> contactPathList = commonService.selectCodeList("CONTACT_PATH_CD");
		List<Map<String,String>> bizList = commonService.selectCodeList("BIZ_CD");
		
		// 부문장
		params.put("posLevel", "1");
		List<Map<String,Object>> memberList = popupService.selectPopMemberList(params);

		model.addAttribute("params", params);
		model.addAttribute("clientList", clientList);
		model.addAttribute("contactPathList", contactPathList);
		model.addAttribute("bizList", bizList);
		model.addAttribute("authList", memberList);
		
		return "virtual/vcInsert";
	}	
	
	@RequestMapping(value = "/virtual/vcInsertAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> vcInsertAction(@RequestParam Map<String, String> params){
		
		String[] authMids = request.getParameterValues("authMid");
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		int ret = virtualService.insertVirtual(params, authMids);
		
		// 등록 포인트 적립
		if(ret==1){
			commonService.insertRegPoint(PointTyp.POI_VC_REG, params.get("mid"), params.get("vcId"));
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
	
	@RequestMapping(value = "/virtual/vcUpdate.do", method = RequestMethod.GET)
	public String vcUpdate(@RequestParam Map<String, String> params, Model model) {
		
	
		List<Map<String,String>> clientList = commonService.selectCodeList("CLIENT_CD");
		List<Map<String,String>> contactPathList = commonService.selectCodeList("CONTACT_PATH_CD");
		List<Map<String,String>> bizList = commonService.selectCodeList("BIZ_CD");

		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		model.addAttribute("vc", virtualService.selectVirtual(params));
		model.addAttribute("authList", virtualService.selectVirtualAuthList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("clientList", clientList);
		model.addAttribute("contactPathList", contactPathList);
		model.addAttribute("bizList", bizList);
		
		return "virtual/vcUpdate";
	}
	
	@RequestMapping(value = "/virtual/vcUpdateAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> vcUpdateAction(@RequestParam Map<String, String> params){
		
		String[] authMids = request.getParameterValues("authMid");
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		int ret = virtualService.updateVirtual(params, authMids);
		
		Map<String, String> returnMap = new HashMap<String, String>();
		
		if(ret==1){
			returnMap.put("result", "true");
		}
		else{
			returnMap.put("result", "false");
		}
		
		return returnMap;
	}
	
	@RequestMapping(value = "/virtual/vcDeleteAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> vcDeleteAction(@RequestParam Map<String, String> params){
		
		params.put("mid", loginService.getLoginVO(request).getMid());

		Map<String, String> returnMap = new HashMap<String, String>();
		
		int ret = virtualService.deleteVirtual(params);

		if(ret==1){
			returnMap.put("result", "true");
		}
		else{
			returnMap.put("result", "false");
			returnMap.put("msg", "시스템 오류 입니다. 잠시 후 다시 시도해 주세요.");
		}
		
		return returnMap;
	}
	
	@RequestMapping(value = "/virtual/commentUpdateAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> commentUpdateAction(@RequestParam Map<String, String> params){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		int ret = virtualService.updateComment(params);
		
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
	
	@RequestMapping(value = "/virtual/fuInsertAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> fuInsertAction(@RequestParam Map<String, String> params){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		int ret = virtualService.insertFu(params);
		
		Map<String, String> returnMap = new HashMap<String, String>();
		
		if(ret==1){
			returnMap.put("result", "true");
		}
		else{
			returnMap.put("result", "false");
		}
		
		return returnMap;
	}
	
}
