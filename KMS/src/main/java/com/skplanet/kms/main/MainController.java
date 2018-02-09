package com.skplanet.kms.main;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.skplanet.kms.ha.HaService;
import com.skplanet.kms.kc.KcService;
import com.skplanet.kms.login.LoginService;
import com.skplanet.kms.pt.PtService;
import com.skplanet.kms.tr.TrService;
import com.skplanet.kms.util.ListPage;
import com.skplanet.kms.virtual.VirtualService;

@Controller
public class MainController {

	private static final Logger logger = LoggerFactory.getLogger(MainController.class);
	
	@Autowired
	private LoginService loginService;
	
	@Autowired
	private VirtualService virtualService;
	
	@Autowired
	private PtService ptService;
	
	@Autowired
	private TrService trService;
	
	@Autowired
	private HaService haService;
	
	@Autowired
	private KcService kcService;
	
	@Autowired
	private MainService mainService;
	
	@Autowired
	private HttpServletRequest request;
	
	@RequestMapping(value = "/main/main.do", method = RequestMethod.GET)
	public String main(@RequestParam Map<String, String> params, Model model) {
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("firstRow", "1");
		
		// Potential Client
		ListPage vcPage = new ListPage("1");
		params.put("lastRow", "7");
		vcPage.setTotalCount(virtualService.selectVirtualCnt(params));
		vcPage.setList(virtualService.selectVirtualList(params));
		
		// PT Report
		ListPage ptPage = new ListPage("1");
		params.put("lastRow", "7");
		ptPage.setTotalCount(ptService.selectPtCnt(params));
		ptPage.setList(ptService.selectPtList(params));		
		
		// Trend Report
		ListPage trPage = new ListPage("1");
		params.put("lastRow", "7");
		trPage.setTotalCount(trService.selectTrCnt(params));
		trPage.setList(trService.selectTrList(params));
		
		// 지식채널
		ListPage kcPage = new ListPage("1");
		params.put("lastRow", "4");
		kcPage.setTotalCount(kcService.selectKcCnt(params));
		kcPage.setList(kcService.selectKcList(params));
		
		// History Archive
		params.put("haCateCd","HAC_00001");		// 영상만
		ListPage haPage = new ListPage("1");
		params.put("lastRow", "4");
		haPage.setTotalCount(haService.selectHaCnt(params));
		haPage.setList(haService.selectHaList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("vcPage", vcPage);
		model.addAttribute("ptPage", ptPage);
		model.addAttribute("trPage", trPage);
		model.addAttribute("kcPage", kcPage);
		model.addAttribute("haPage", haPage);
		
		return "main/main";
	}
	
	@RequestMapping(value = "/main/search.do", method = RequestMethod.GET)
	public String search(@RequestParam Map<String, String> params, Model model) {
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("firstRow", "1");
		params.put("lastRow", "5");
		
		// Potential Client
		ListPage vcPage = new ListPage("1");
		vcPage.setTotalCount(virtualService.selectVirtualCnt(params));
		vcPage.setList(virtualService.selectVirtualList(params));
		
		// PT Report
		ListPage ptPage = new ListPage("1");
		ptPage.setTotalCount(ptService.selectPtCnt(params));
		ptPage.setList(ptService.selectPtList(params));		
		
		// Trend Report
		ListPage trPage = new ListPage("1");
		trPage.setTotalCount(trService.selectTrCnt(params));
		trPage.setList(trService.selectTrList(params));
		
		// History Archive
		ListPage haPage = new ListPage("1");
		haPage.setTotalCount(haService.selectHaCnt(params));
		haPage.setList(haService.selectHaList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("vcPage", vcPage);
		model.addAttribute("ptPage", ptPage);
		model.addAttribute("trPage", trPage);
		model.addAttribute("haPage", haPage);
		
		return "main/search";
	}
	
	@RequestMapping(value = "/main/mySearch.do", method = RequestMethod.GET)
	public String mySearch(@RequestParam Map<String, String> params, Model model) {

		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("searchRegId", loginService.getLoginVO(request).getMid());	// 내가 쓴 글
		params.put("firstRow", "1");
		params.put("lastRow", "5");
		
		// Potential Client
		ListPage vcPage = new ListPage("1");
		vcPage.setTotalCount(virtualService.selectVirtualCnt(params));
		vcPage.setList(virtualService.selectVirtualList(params));
		
		// PT Report
		ListPage ptPage = new ListPage("1");
		ptPage.setTotalCount(ptService.selectPtCnt(params));
		ptPage.setList(ptService.selectPtList(params));		
		
		// Trend Report
		ListPage trPage = new ListPage("1");
		trPage.setTotalCount(trService.selectTrCnt(params));
		trPage.setList(trService.selectTrList(params));
		
		// History Archive
		ListPage haPage = new ListPage("1");
		haPage.setTotalCount(haService.selectHaCnt(params));
		haPage.setList(haService.selectHaList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("vcPage", vcPage);
		model.addAttribute("ptPage", ptPage);
		model.addAttribute("trPage", trPage);
		model.addAttribute("haPage", haPage);
		
		return "main/mySearch";
	}
	
	@RequestMapping(value = "/main/myPointList.do", method = RequestMethod.GET)
	public String myPointList(@RequestParam Map<String, String> params, Model model) {
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		ListPage listPage = new ListPage(params.get("pageNo"));
		params.put("firstRow", listPage.getFirstRow()+"");
		params.put("lastRow", listPage.getLastRow()+"");
		listPage.setTotalCount(mainService.selectPointCnt(params));
		listPage.setList(mainService.selectPointList(params));
		
		model.addAttribute("params", params);
		model.addAttribute("listPage", listPage);
		
		return "main/myPointList";
	}
}
