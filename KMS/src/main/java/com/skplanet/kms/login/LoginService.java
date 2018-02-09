package com.skplanet.kms.login;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LoginService {

	private static final String LOGIN_SESSION_NAME = "loginVO";
	
	@Autowired
	private LoginDAO loginDAO;
	
	/**
	 * 세션에서 로그인 정보를 가져옴
	 * @param request
	 * @return
	 */
	public LoginVO getLoginVO(HttpServletRequest request){
		
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute(LOGIN_SESSION_NAME);
		if(loginVO==null){
			loginVO = new LoginVO();
		}
		
		return loginVO;
	}
	
	/**
	 * 로그인 정보를 세션에 저장
	 * @param request
	 * @param loginVO
	 */
	public void setLoginVO(HttpServletRequest request, LoginVO loginVO){
		request.getSession().setAttribute(LOGIN_SESSION_NAME, loginVO);
	}
	
	public Map<String,Object> selectLoginMember(Map<String,String> params){
		return loginDAO.selectLoginMember(params);
	}
	
	public Map<String,Object> selectSelfAuth(Map<String,String> params){
		return loginDAO.selectSelfAuth(params);
	}
	
	public int updatePasswd(Map<String,String> params){
		return loginDAO.updatePasswd(params);
	}
	
}
