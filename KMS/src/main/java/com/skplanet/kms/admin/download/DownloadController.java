package com.skplanet.kms.admin.download;

import java.text.SimpleDateFormat;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.skplanet.kms.common.JxlsView;
import com.skplanet.kms.util.ListPage;

@Controller
public class DownloadController {

	private static final Logger logger = LoggerFactory.getLogger(DownloadController.class);
	
	@Autowired
	private DownloadService downloadService;
	
	@RequestMapping(value = "/admin/download/top10List.do", method = RequestMethod.GET)
	public String top10List(@RequestParam Map<String, String> params, Model model) {
		
		model.addAttribute("params", params);
		model.addAttribute("top10List", downloadService.selectTop10List(params));
		
		return "admin/download/top10List";
	}
	
	@RequestMapping(value = "/admin/download/downloadList.do", method = RequestMethod.GET)
	public String downloadList(@RequestParam Map<String, String> params, Model model) {

		ListPage listPage = new ListPage(params.get("pageNo"));
		params.put("firstRow", listPage.getFirstRow()+"");
		params.put("lastRow", listPage.getLastRow()+"");
		listPage.setTotalCount(downloadService.selectDownloadCnt(params));
		listPage.setList(downloadService.selectDownloadList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("listPage", listPage);
		
		return "admin/download/downloadList";
	}
	
	@RequestMapping(value = "/admin/download/downloadViewList.do", method = RequestMethod.GET)
	public String downloadViewList(@RequestParam Map<String, String> params, Model model) {

		ListPage listPage = new ListPage(params.get("pageNo"));
		params.put("firstRow", listPage.getFirstRow()+"");
		params.put("lastRow", listPage.getLastRow()+"");
		listPage.setTotalCount(downloadService.selectDownloadCnt(params));
		listPage.setList(downloadService.selectDownloadList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("listPage", listPage);
		
		return "admin/download/downloadViewList";
	}
	
	
	//박그림 매니저 요청 Excel Export
	@RequestMapping(value = "/admin/download/downloadListExcel.do", method = RequestMethod.GET)
	public ModelAndView downloadListExcel(@RequestParam Map<String, String> params, Model model, ModelMap modelMap) {
		
		ListPage listPage = new ListPage(params.get("pageNo"));

		listPage.setTotalCount(downloadService.selectDownloadCnt(params));
		
		/* 엑셀은 페이징 없이 전체 검색결과를 출력 */
		params.put("firstRow", "1");
		params.put("lastRow", listPage.getTotalCount()+"");
		
		listPage.setList(downloadService.selectDownloadList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("listPage", listPage);
		
		// 엑셀로 출력
		model.addAttribute("viewName", "downloadList");
		model.addAttribute("fileName", "downloadList");
		model.addAttribute("sf", new SimpleDateFormat("yyyy-MM-dd"));
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setView(new JxlsView());
		modelAndView.addAllObjects(modelMap);
		return modelAndView;
	}
}
