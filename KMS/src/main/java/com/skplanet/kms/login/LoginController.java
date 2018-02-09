package com.skplanet.kms.login;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.skplanet.kms.util.SHA256;

@Controller
public class LoginController {

	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
	
	@Autowired
	private LoginService loginService;
	
	@Autowired
	private HttpServletRequest request;
	
	@RequestMapping(value = "/login/login.do", method = RequestMethod.GET)
	public String login() {
		return "login/login";
	}
	
	@RequestMapping(value = "/login/isLogin.do", method = RequestMethod.POST)
	@ResponseBody
	public Boolean isLogin(@RequestParam Map<String, String> params){
		return loginService.getLoginVO(request).isLogIn();
	}
	
	@RequestMapping(value = "/login/loginAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> loginAction(@RequestParam Map<String, String> params){

		String orgPass = params.get("passwd");
		
		// 패스워드 단방향 암호화
		params.put("passwd", SHA256.encrypt(orgPass));
		
		Map<String, String> returnMap = new HashMap<String, String>();
		
		Map<String,Object> member = loginService.selectLoginMember(params);
		
		if(member==null){
			returnMap.put("result", "false");
			returnMap.put("msg", "아이디가 없거나 비밀번호가 일치하지 않습니다.");
		}
		else{
			LoginVO loginVO = new LoginVO();
			loginVO.setLogIn(true);
			loginVO.setAdmYn((String)member.get("ADM_YN"));
			loginVO.setMid((String)member.get("MID"));
			loginVO.setMemberNm((String)member.get("MEMBER_NM"));
			loginVO.setPosCd((String)member.get("POS_CD"));
			loginVO.setDivCd((String)member.get("DIV_CD"));
			
			loginVO.setCrAppointYn((String)member.get("CR_APPOINT_YN"));
			loginVO.setKcAppointYn((String)member.get("KC_APPOINT_YN"));
			loginVO.setSuperYn((String)member.get("SUPER_YN"));
			
			// 로그인 정보를 세션에 굽는다.
			loginService.setLoginVO(request, loginVO);			
			
			returnMap.put("result", "true");
			returnMap.put("admYn", loginVO.getAdmYn());
			returnMap.put("superYn", loginVO.getSuperYn());
			
			// 초기 패스워드 이면
			if(orgPass.equals(member.get("BIRTH_DT"))){
				returnMap.put("initYn", "Y");
			}
		}
		
		return returnMap;
	}
	
	@RequestMapping(value = "/login/logout.do", method = RequestMethod.GET)
	public String logout(HttpSession session) {
		
		// 세션 초기화
		session.invalidate();
		
		return "redirect:/login/login.do";
	}
	
	@RequestMapping(value = "/login/selfAuth.do", method = RequestMethod.GET)
	public String selfAuth() {
		
		LoginVO loginVO = loginService.getLoginVO(request);
		
		// 이미 로그인된 상태면 비밀번호 변경으로 바로 이동
		if(loginVO.isLogIn()){
			return "redirect:/login/newPasswd.do";
		}
		
		return "login/selfAuth";
	}
	
	@RequestMapping(value = "/login/selfAuthAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> selfAuthAction(@RequestParam Map<String, String> params){
		
		Map<String, String> returnMap = new HashMap<String, String>();
		
		Map<String,Object> member = loginService.selectSelfAuth(params);
		
		if(member==null){
			returnMap.put("result", "false");
			returnMap.put("msg", "아이디가 없거나 개인정보가 일치하지 않습니다.");
		}
		else if(!"Y".equals(member.get("LOGIN_ABLE_YN"))){
			returnMap.put("result", "false");
			returnMap.put("msg", "사용중지된 계정입니다.");
		}
		else{
			LoginVO loginVO = new LoginVO();
			loginVO.setLogIn(false);
			loginVO.setMid((String)member.get("MID"));
			
			// MID만 세션에 굽는다.
			loginService.setLoginVO(request, loginVO);			
			
			returnMap.put("result", "true");
		}
		
		return returnMap;
	}

	@RequestMapping(value = "/login/newPasswd.do", method = RequestMethod.GET)
	public String newPasswd() {
		
		LoginVO loginVO = loginService.getLoginVO(request);
		
		// 본인확인이 안된 상태면 본인확인 페이지로
		if(loginVO == null || loginVO.getMid()==null || "".equals(loginVO.getMid())){
			return "redirect:/login/selfAuth.do";
		}
		
		return "login/newPasswd";
	}
	
	@RequestMapping(value = "/login/newPasswdAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> newPasswdAction(@RequestParam Map<String, String> params){

		LoginVO loginVO = loginService.getLoginVO(request);
		
		Map<String, String> returnMap = new HashMap<String, String>();
		
		if(loginVO.getMid()==null || "".equals(loginVO.getMid())){
			returnMap.put("result", "false");
			returnMap.put("msg", "본인확인 정보가 없습니다.");
			return returnMap;
		}
		
		// 비밀번호 유효성 검증
		String passwd = params.get("passwd");
		if(passwd==null || passwd.length()<8 || passwd.length()>20 ){
			returnMap.put("result", "false");
			returnMap.put("msg", "비밀번호는 8자 이상 20자 이하 이어야 합니다.");
			return returnMap;			
		}
		
		boolean isValidPass = 
			passwd.matches("[a-zA-Z0-9!@#$%^&*?_~()]*")
			&& passwd.matches(".*[a-zA-Z].*")
			&& passwd.matches(".*[0-9].*")
			&& passwd.matches(".*[!@#$%^&*?_~()].*");
		if(!isValidPass){
			returnMap.put("result", "false");
			returnMap.put("msg", "비밀번호는 영문자, 숫자, 특수문자 !,@,#,$,%,^,&,*,?,_,~,(,) 를 포함해야 합니다.");
			return returnMap;			
		}
		
		
		params.put("mid",loginVO.getMid());
		// 패스워드 단방향 암호화
		params.put("passwd", SHA256.encrypt(params.get("passwd")));
		
		int ret = loginService.updatePasswd(params);
		
		if(ret==1){
			returnMap.put("result", "true");
		}
		else{
			returnMap.put("result", "false");
			returnMap.put("msg", "사용중지된 계정입니다.");
		}
		
		return returnMap;
	}
	
}
