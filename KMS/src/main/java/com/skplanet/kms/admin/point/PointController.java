package com.skplanet.kms.admin.point;

import java.text.SimpleDateFormat;
import java.util.HashMap;
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

import com.skplanet.kms.common.JxlsView;
import com.skplanet.kms.login.LoginService;
import com.skplanet.kms.util.ListPage;

@Controller
public class PointController {

	private static final Logger logger = LoggerFactory.getLogger(PointController.class);
	
	@Autowired
	private LoginService loginService;
	
	@Autowired
	private PointService pointService;
	
	@Autowired
	private HttpServletRequest request;
	
	@RequestMapping(value = "/admin/point/pointList.do", method = RequestMethod.GET)
	public String pointList(@RequestParam Map<String, String> params, Model model) {
		
		ListPage listPage = new ListPage(params.get("pageNo"));
		params.put("firstRow", listPage.getFirstRow()+"");
		params.put("lastRow", listPage.getLastRow()+"");
		listPage.setTotalCount(pointService.selectPointCnt(params));
		listPage.setList(pointService.selectPointList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("listPage", listPage);
		
		return "admin/point/pointList";
	}
	
	@RequestMapping(value = "/admin/point/pointListExcel.do", method = RequestMethod.GET)
	public ModelAndView pointListExcel(@RequestParam Map<String, String> params, Model model, ModelMap modelMap) {
		
		ListPage listPage = new ListPage(params.get("pageNo"));

		listPage.setTotalCount(pointService.selectPointCnt(params));
		
		/* 엑셀은 페이징 없이 전체 검색결과를 출력 */
		params.put("firstRow", "1");
		params.put("lastRow", listPage.getTotalCount()+"");
		
		listPage.setList(pointService.selectPointList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("listPage", listPage);
		
		// 엑셀로 출력
		model.addAttribute("viewName", "pointList");
		model.addAttribute("fileName", "pointList");
		model.addAttribute("sf", new SimpleDateFormat("yyyy-MM-dd"));
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setView(new JxlsView());
		modelAndView.addAllObjects(modelMap);
		return modelAndView;
	}
	
	@RequestMapping(value = "/admin/point/pointViewList.do", method = RequestMethod.GET)
	public String pointViewList(@RequestParam Map<String, String> params, Model model) {
		
		ListPage listPage = new ListPage(params.get("pageNo"));
		params.put("firstRow", listPage.getFirstRow()+"");
		params.put("lastRow", listPage.getLastRow()+"");
		listPage.setTotalCount(pointService.selectPointViewCnt(params));
		listPage.setList(pointService.selectPointViewList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("listPage", listPage);
		model.addAttribute("member", pointService.selectMember(params));
		model.addAttribute("sumPoint", pointService.selectSumPoint(params));
		
		model.addAttribute("regTypList", pointService.selectPointTypeList("POI_ADM_REG_"));
		model.addAttribute("useTypList", pointService.selectPointTypeList("POI_ADM_USE_"));
		
		return "admin/point/pointViewList";
	}

	/**
	 * 관리자 적립/차감
	 */
	@RequestMapping(value = "/admin/point/pointSaveAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> pointSaveAction(@RequestParam Map<String, String> params){
		
		logger.debug("params=[{}]",params);
		
		params.put("regId", loginService.getLoginVO(request).getMid());
		
		// 차감이면 마이너스 포인트
		if(params.get("pointTyp").startsWith("POI_ADM_USE")){
			params.put("point", "-" + params.get("point"));
		}
		
		Map<String, String> returnMap = new HashMap<String, String>();

		int ret = pointService.insertPoint(params);
		
		if(ret==1){
			returnMap.put("result", "true");
		}
		else{
			returnMap.put("result", "false");
			returnMap.put("msg", "시스템 오류입니다. 잠시 후 다시 시도해 주세요.");
		}
	
		return returnMap;
	}
	
	@RequestMapping(value = "/admin/point/pointMemberList.do", method = RequestMethod.GET)
	public String pointMemberList(@RequestParam Map<String, String> params, Model model) {

		ListPage listPage = new ListPage(params.get("pageNo"));
		params.put("firstRow", listPage.getFirstRow()+"");
		params.put("lastRow", listPage.getLastRow()+"");
		listPage.setTotalCount(pointService.selectPointMemberCnt(params));
		listPage.setList(pointService.selectPointMemberList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("listPage", listPage);
		
		return "admin/point/pointMemberList";
	}
	
	@RequestMapping(value = "/admin/point/pointMemberListExcel.do", method = RequestMethod.GET)
	public ModelAndView pointMemberListExcel(@RequestParam Map<String, String> params, Model model, ModelMap modelMap) {
		
		ListPage listPage = new ListPage(params.get("pageNo"));

		listPage.setTotalCount(pointService.selectPointMemberCnt(params));
		
		/* 엑셀은 페이징 없이 전체 검색결과를 출력 */
		params.put("firstRow", "1");
		params.put("lastRow", listPage.getTotalCount()+"");
		
		listPage.setList(pointService.selectPointMemberList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("listPage", listPage);
		
		// 엑셀로 출력
		model.addAttribute("viewName", "pointMemberList");
		model.addAttribute("fileName", "pointMemberList");
		model.addAttribute("sf", new SimpleDateFormat("yyyy-MM-dd"));
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setView(new JxlsView());
		modelAndView.addAllObjects(modelMap);
		return modelAndView;
	}
	
	@RequestMapping(value = "/admin/point/pointSet.do", method = RequestMethod.GET)
	public String pointSet(@RequestParam Map<String, String> params, Model model) {

		Map<String,Object> pointSet = pointService.selectPointSet(params);
		model.addAttribute("pointSet", pointSet);
		
		return "admin/point/pointSet";
	}
	
	@RequestMapping(value = "/admin/point/pointSetAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> pointSetAction(@RequestParam Map<String, String> params) throws Exception{
		
		logger.debug("params=[{}]",params);
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		Map<String, String> returnMap = new HashMap<String, String>();

		int ret = pointService.updatePointSet(params);
		
		if(ret==1){
			returnMap.put("result", "true");
		}
		else{
			returnMap.put("result", "false");
			returnMap.put("msg", "시스템 오류입니다. 잠시 후 다시 시도해 주세요.");
		}
	
		return returnMap;
	}	
}
