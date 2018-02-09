package com.skplanet.kms.admin.stat;

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

import com.skplanet.kms.common.JxlsView;
import com.skplanet.kms.util.ListPage;

@Controller
public class StatController {

	private static final Logger logger = LoggerFactory.getLogger(StatController.class);
	
	@Autowired
	private StatService statService;
	
	@Autowired
	private HttpServletRequest request;
	
	@RequestMapping(value = "/admin/stat/statList.do", method = RequestMethod.GET)
	public String statList(@RequestParam Map<String, String> params, Model model) {
		
		List<Map<String,Object>> centerList = statService.selectDivList("SEC_00001");
		
		ListPage listPage = new ListPage(params.get("pageNo"));
		params.put("firstRow", listPage.getFirstRow()+"");
		params.put("lastRow", listPage.getLastRow()+"");
		listPage.setTotalCount(statService.selectStatCnt(params));
		listPage.setList(statService.selectStatList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("centerList", centerList);
		model.addAttribute("listPage", listPage);
		
		model.addAttribute("listTotal", statService.selectListTotal(params));
		
		return "admin/stat/statList";
	}
	
	@RequestMapping(value = "/admin/stat/divList.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> divList(@RequestParam Map<String, String> params, Model model) {
		
		return statService.selectDivList(params.get("divCd"));
	}
	
	@RequestMapping(value = "/admin/stat/memberList.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> memberList(@RequestParam Map<String, String> params, Model model) {
		
		return statService.selectMemberList(params.get("divCd"));
	}
	
	@RequestMapping(value = "/admin/stat/statListExcel.do", method = RequestMethod.GET)
	public ModelAndView statListExcel(@RequestParam Map<String, String> params, Model model, ModelMap modelMap) {

		ListPage listPage = new ListPage(params.get("pageNo"));

		listPage.setTotalCount(statService.selectStatCnt(params));
		
		/* 엑셀은 페이징 없이 전체 검색결과를 출력 */
		params.put("firstRow", "1");
		params.put("lastRow", listPage.getTotalCount()+"");

		listPage.setList(statService.selectStatList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("listPage", listPage);
		
		// 엑셀로 출력
		model.addAttribute("viewName", "statList");
		model.addAttribute("fileName", "statList");
		model.addAttribute("sf", new SimpleDateFormat("yyyy-MM-dd"));
		model.addAttribute("listPage", listPage);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setView(new JxlsView());
		modelAndView.addAllObjects(modelMap);
		return modelAndView;
	}
}
