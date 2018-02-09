package com.skplanet.kms.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.skplanet.kms.login.LoginService;
import com.skplanet.kms.login.LoginVO;
import com.skplanet.kms.main.MainController;
import com.skplanet.kms.main.MainService;

public class LoginInterceptor extends HandlerInterceptorAdapter {

	private static final Logger logger = LoggerFactory.getLogger(LoginInterceptor.class);
	
	@Autowired
	private LoginService loginService;
	
	@Autowired
	private MainService mainService;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		LoginVO loginVO = loginService.getLoginVO(request);
		
		if(loginVO.isLogIn() && loginVO.getAdmYn().equals("N")){
			
			// 접속 로그
			String requestURL = request.getRequestURL().toString();
			String queryString = request.getQueryString();
			if(queryString!=null && !"".equals(queryString)){
				requestURL += "?"+queryString;
			}
			logger.info("[{}] requestUrl : {}", loginVO.getMid(), requestURL);
			
			if("GET".equals(request.getMethod())){
				// 내가 쓴글
				request.setAttribute("docCnt", mainService.selectDocCnt(loginVO.getMid()));
				// 적립포인트
				request.setAttribute("sumPoint", mainService.selectSumPoint(loginVO.getMid()));
			}
			return true;
		}
		else{
			response.sendRedirect("/login/login.do");
			return false;
		}
		
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub
		super.postHandle(request, response, handler, modelAndView);
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)	throws Exception {
		// TODO Auto-generated method stub
		super.afterCompletion(request, response, handler, ex);
	}

	@Override
	public void afterConcurrentHandlingStarted(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		// TODO Auto-generated method stub
		super.afterConcurrentHandlingStarted(request, response, handler);
	}
}
