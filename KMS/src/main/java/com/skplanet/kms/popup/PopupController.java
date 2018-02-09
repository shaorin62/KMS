package com.skplanet.kms.popup;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.skplanet.kms.common.CommonService;

@Controller
public class PopupController {

	@Autowired
	private CommonService commonService;
	
	@Autowired
	private PopupService popupService;
	
	@RequestMapping(value = "/popup/popMemberList.do", method = RequestMethod.GET)
	public String popMemberList(@RequestParam Map<String, String> params, Model model) {
		
		List<Map<String,Object>> memberList = popupService.selectPopMemberList(params);
		
		model.addAttribute("params", params);
		model.addAttribute("memberList", memberList);
		
		return "/popup/popMemberList";
	}
	
	@RequestMapping(value = "/popup/popClientList.do", method = RequestMethod.GET)
	public String popClientList(@RequestParam Map<String, String> params, Model model) {
		
		params.put("upperCd", "CLIENT_CD");
		List<Map<String,Object>> clientList = popupService.selectPopList(params);
		
		model.addAttribute("params", params);
		model.addAttribute("clientList", clientList);
		
		return "/popup/popClientList";
	}
	
	@RequestMapping(value = "/popup/popRivalList.do", method = RequestMethod.GET)
	public String popRivalList(@RequestParam Map<String, String> params, Model model) {
		
		params.put("upperCd", "RIVAL_CD");
		List<Map<String,Object>> rivalList = popupService.selectPopList(params);
		
		model.addAttribute("params", params);
		model.addAttribute("rivalList", rivalList);
		
		return "/popup/popRivalList";
	}
	
	@RequestMapping(value = "/popup/popTeamList.do", method = RequestMethod.GET)
	public String popTeamList(@RequestParam Map<String, String> params, Model model) {
		
		List<Map<String,Object>> teamList = popupService.selectTeamList(params);
		
		model.addAttribute("params", params);
		model.addAttribute("teamList", teamList);
		
		return "/popup/popTeamList";
	}
	
	//오픈시 팝업 생성
	@RequestMapping(value = "/popup/pop1.do", method = RequestMethod.GET)
	public String pop1(@RequestParam Map<String, String> params, Model model) {
		
		//List<Map<String,Object>> teamList = popupService.selectTeamList(params);
		
		//model.addAttribute("params", params);
		//model.addAttribute("teamList", teamList);
		
		return "/popup/pop1";
	}
}
