package com.skplanet.kms.admin.div;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.skplanet.kms.login.LoginService;

@Controller
public class DivController {
	
	@Autowired
	private LoginService loginService;
	
	@Autowired
	private DivService divService;
	
	@Autowired
	private HttpServletRequest request;
	
	@RequestMapping(value = "/admin/div/centerCode.do", method = RequestMethod.GET)
	public String centerCode(@RequestParam Map<String, String> params, Model model) {
		
		model.addAttribute("params", params);
		model.addAttribute("centerList", divService.selectCenterList(params));
		
		return "admin/div/centerCode";
	}
	
	@RequestMapping(value = "/admin/div/teamCode.do", method = RequestMethod.GET)
	public String teamCode(@RequestParam Map<String, String> params, Model model) {
		
		model.addAttribute("params", params);
		model.addAttribute("center", divService.selectCenter(params));
		model.addAttribute("centerList", divService.selectCenterList(params));
		model.addAttribute("teamList", divService.selectTeamList(params));
		
		return "admin/div/teamCode";
	}
	
	@RequestMapping(value = "/admin/div/insertDivAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> insertDivAction(@RequestParam Map<String, String> params, Model model) {

		params.put("mid", loginService.getLoginVO(request).getMid());
		
		int ret = divService.insertDiv(params);
		
		Map<String, String> returnMap = new HashMap<String, String>();
		
		if(ret==1){
			returnMap.put("result", "true");
		}
		else{
			returnMap.put("result", "false");
			returnMap.put("msg", "시스템 오류입니다. 잠시 후 다시 시도해 주세요.");
		}
		
		return returnMap;
	}
	
	@RequestMapping(value = "/admin/div/updateDivAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> updateDivAction(@RequestParam Map<String, String> params, Model model) {

		params.put("mid", loginService.getLoginVO(request).getMid());
		
		int ret = divService.updateDiv(params);
		
		Map<String, String> returnMap = new HashMap<String, String>();
		
		if(ret==1){
			returnMap.put("result", "true");
		}
		else{
			returnMap.put("result", "false");
			returnMap.put("msg", "시스템 오류입니다. 잠시 후 다시 시도해 주세요.");
		}
		
		return returnMap;
	}
	
	@RequestMapping(value = "/admin/div/deleteDivAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> deleteDivAction(@RequestParam Map<String, String> params, Model model) {

		Map<String, String> returnMap = new HashMap<String, String>();
		
		// 하위 부서가 남아있으면
		if(divService.selectDivCnt(params)>0){
			returnMap.put("result", "false");
			returnMap.put("msg", "하위 부서가 남아있어서 삭제할 수 없습니다.");
			return returnMap;
		}
		
		// 하위 임직원이 남아있으면
		if(divService.selectMemberCnt(params)>0){
			returnMap.put("result", "false");
			returnMap.put("msg", "해당 부서 소속의 임직원이 남아 있어서 삭제할 수 없습니다.");
			return returnMap;
		}
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		
		int ret = divService.deleteDiv(params);
		
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
