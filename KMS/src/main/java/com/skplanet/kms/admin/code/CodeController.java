package com.skplanet.kms.admin.code;

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
public class CodeController {

	@Autowired
	private CodeService codeService;
	
	@Autowired
	private LoginService loginService;
	
	@Autowired
	private HttpServletRequest request;
	
	@RequestMapping(value = "/admin/code/commonCode.do", method = RequestMethod.GET)
	public String commonCode(@RequestParam Map<String, String> params, Model model) {
		
		if(params.get("upperCd")==null || "".equals(params.get("upperCd"))){
			params.put("upperCd", "CLIENT_CD");
		}
		
		model.addAttribute("codeList", codeService.selectCodeList(params.get("upperCd")));
		
		model.addAttribute("params", params);
		
		return "admin/code/commonCode";
	}
	
	@RequestMapping(value = "/admin/code/insertCodeAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> insertCodeAction(@RequestParam Map<String, String> params, Model model) {

		params.put("mid", loginService.getLoginVO(request).getMid());
		
		int ret = codeService.insertCode(params);
		
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
	
	@RequestMapping(value = "/admin/code/updateCodeAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> updateCodeAction(@RequestParam Map<String, String> params, Model model) {

		params.put("mid", loginService.getLoginVO(request).getMid());
		
		int ret = codeService.updateCode(params);
		
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
	
	@RequestMapping(value = "/admin/code/deleteCodeAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> deleteCodeAction(@RequestParam Map<String, String> params, Model model) {

		params.put("mid", loginService.getLoginVO(request).getMid());
		
		int ret = codeService.deleteCode(params);
		
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
}
