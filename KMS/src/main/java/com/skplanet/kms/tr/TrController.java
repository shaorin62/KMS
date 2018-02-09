package com.skplanet.kms.tr;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.skplanet.kms.common.CommonService;
import com.skplanet.kms.common.PointTyp;
import com.skplanet.kms.login.LoginService;
import com.skplanet.kms.upload.UploadService;
import com.skplanet.kms.util.ListPage;


@Controller
public class TrController {
	
	private static final Logger logger = LoggerFactory.getLogger(TrController.class);
	
	
	
	@Autowired
	private LoginService loginService;
	@Autowired
	private CommonService commonService;
	@Autowired
	private TrService trService;
	@Autowired
	private HttpServletRequest request;

	@Autowired
	private UploadService uploadService;
	@Value("#{commonProperties['file.upload.path']}")
	private String fileUploadPath;
	
	/*리스트화면으로*/
	@RequestMapping(value="/tr/trList.do",method = RequestMethod.GET)
	public String trList(@RequestParam Map<String,String> params, Model model){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		List<Map<String,String>> trCateCdList = commonService.selectCodeList("TR_CATE_CD");
		
		if(params.get("trCateCd")==null || "".equals(params.get("trCateCd"))){
			// 디폴트 탭 타사자료
			//params.put("trCateCd", "TRC_00001");
			// 디폴트 탭 임시 탭 구성 박그림매니저 요청
			params.put("trCateCd", "TRC_00002");
		}
		
		System.out.println("========================>" + params.get("trCateCd"));
		
		/*본문*/
		ListPage listPage = new ListPage(params.get("pageNo"));
		
		params.put("firstRow", listPage.getFirstRow()+"");
		params.put("lastRow", listPage.getLastRow()+"");
		
		listPage.setTotalCount(trService.selectTrCnt(params));
		listPage.setList(trService.selectTrList(params));
		
		model.addAttribute("params",params);
		model.addAttribute("trCateCdList",trCateCdList);
		
		model.addAttribute("listPage",listPage);
		return "tr/trList";
	}
	
	/*입력하기*/
	@RequestMapping(value="/tr/trInsertAction.do",method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> trInsertAction(@RequestParam Map<String,String>  params){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		String[] attachNormals = request.getParameterValues("ATT_NORMAL");
		
		Map<String,String> returnMap = new HashMap<String,String>();
		if(((String)params.get("title")).equals(null) || ((String)params.get("title")) == ""){
			returnMap.put("result", "false");
			return returnMap;
		}
		
		int ret = trService.insertTr(params,attachNormals);
		
		// 등록 포인트 적립
		if(ret==1){
			// 타사자료
			if("TRC_00001".equals(params.get("trCateCd"))){
				commonService.insertRegPoint(PointTyp.POI_OTHER_REG, params.get("mid"), params.get("bdId"));
			}
			// 일반자료
			else{
				commonService.insertRegPoint(PointTyp.POI_TR_REG, params.get("mid"), params.get("bdId"));
			}
		}
		
		
		if(ret == 1){
			returnMap.put("result","true");
		}else{
			returnMap.put("result","false");
		}
		return returnMap;
	} 
	
	/*입력화면으로*/                                       
	@RequestMapping(value="/tr/trInsert.do",method=RequestMethod.GET)
	public String trInsert(@RequestParam Map<String,String> params,Model model){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		List<Map<String,String>> trCateCdList = commonService.selectCodeList("TR_CATE_CD");
		model.addAttribute("params",params);
		model.addAttribute("trCateCdList", trCateCdList);
		return "tr/trInsert";
	}
	
	/*상세화면으로*/
	@RequestMapping(value="/tr/trView.do",method=RequestMethod.GET)
	public String trView(@RequestParam Map<String,String> params,Model model){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		trService.updateTrHit(params);
		
		Map<String, Object> returnMap = new HashMap<String,Object>();
		
		returnMap = trService.selectTrOne(params);
		
		/* 파일 다운로드 시 포인트 적립으로 로직 변경 2017-01-04
		// 조회 포인트 적립
		if(returnMap!=null && returnMap.get("BD_ID")!=null){
			// 타사자료
			if("TRC_00001".equals(returnMap.get("TR_CATE_CD"))){
				commonService.insertViewPoint(PointTyp.POI_OTHER_VIEW, params.get("mid"), (String)returnMap.get("BD_ID"), (String)returnMap.get("REG_ID"));
			}
			// 일반자료
			else{
				commonService.insertViewPoint(PointTyp.POI_TR_VIEW, params.get("mid"), (String)returnMap.get("BD_ID"), (String)returnMap.get("REG_ID"));
			}			
		}
		*/
		
		//파일목록
		params.put("bid", params.get("bdId"));
		List<Map<String,Object>> attList = uploadService.selectAttachList(params);
		
		model.addAttribute("params",params);
		model.addAttribute("returnMap",returnMap);
		model.addAttribute("attList", attList);
		
	return "tr/trView";	
	}
	
	/*수정화면으로*/
	@RequestMapping(value="/tr/trUpdate.do",method=RequestMethod.GET)
	public String trUpdate(@RequestParam Map<String,String> params,Model model){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		List<Map<String,String>> trCateCdList = commonService.selectCodeList("TR_CATE_CD");
		
		Map<String,Object> resultMap = trService.selectTrOne(params);
		
		params.put("bid", params.get("bdId"));
		List<Map<String,Object>> attList = uploadService.selectAttachList(params);
		
		model.addAttribute("trCateCdList",trCateCdList);
		model.addAttribute("resultMap",resultMap);
		model.addAttribute("attList", attList);
		model.addAttribute("params",params);
		
		return "tr/trUpdate";
	}

	/*수정하기*/
	@RequestMapping(value="/tr/trUpdateAction.do",method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> trUpdateAction(@RequestParam Map<String,String>  params){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		String[] attachNormals = request.getParameterValues("ATT_NORMAL");
		
		int ret = trService.updateTr(params,attachNormals);
		
		Map<String,String> returnMap = new HashMap<String,String>();
		if(ret == 1){
			returnMap.put("result","true");
		}else{
			returnMap.put("result","false");
		}
		return returnMap;
	} 
	/*삭제*/
	@RequestMapping(value="/tr/trDeleteAction.do",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> trDeleteAction(@RequestParam Map<String,String> params){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		int ret = trService.deleteTr(params);
		
		Map<String,String> returnMap = new HashMap<String,String>();
		if(ret == 1){
			returnMap.put("result","true");
		}else{
			returnMap.put("result","false");
		}
		return returnMap;
	}

}
