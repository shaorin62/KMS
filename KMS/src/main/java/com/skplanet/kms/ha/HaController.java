package com.skplanet.kms.ha;

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
public class HaController {
	
	private static final Logger logger = LoggerFactory.getLogger(HaController.class);
	
	
	
	@Autowired
	private LoginService loginService;
	@Autowired
	private CommonService commonService;
	@Autowired
	private HaService haService;
	@Autowired
	private HttpServletRequest request;
	@Autowired
	private UploadService uploadService;
	@Value("#{commonProperties['file.upload.path']}")
	private String fileUploadPath;
	
	
	/*리스트화면으로*/
	@RequestMapping(value="/ha/haList.do",method = RequestMethod.GET)
	public String haList(@RequestParam Map<String,String> params, Model model){
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		List<Map<String,String>> haCateCdList = commonService.selectCodeList("HA_CATE_CD");
		
		if(params.get("haCateCd")==null || "".equals(params.get("haCateCd"))){
			// 디폴트 영상
			params.put("haCateCd", "HAC_00001");
		}
		
		int listSize = 10;
		if("HAC_00001".equals(params.get("haCateCd"))){
			// 리스트 사이즈 (영상과 인쇄물은 한페이지에 9개 나머지는 10개)
			listSize = 9;
			
			//매체 리스트
			List<Map<String,String>> mediaList = commonService.selectCodeList("MEDIA_CD");
			model.addAttribute("mediaList", mediaList);
		}
		
		//본문
		ListPage listPage = new ListPage(listSize, params.get("pageNo"));
		
		params.put("firstRow", listPage.getFirstRow()+"");
		params.put("lastRow", listPage.getLastRow()+"");
		
		listPage.setTotalCount(haService.selectHaCnt(params));
		
		List<Map<String, Object>> haList = haService.selectHaList(params);
		listPage.setList(haList);
		//추후권한부여자에게만 "등록"버튼 활성화 위해 판별하기
		
		model.addAttribute("params",params);
		model.addAttribute("haCateCdList",haCateCdList);
		
		model.addAttribute("listPage",listPage);
		
		return "ha/haList";
	}
	
	/*입력하기*/
	@RequestMapping(value="/ha/haInsertAction.do",method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> haInsertAction(@RequestParam Map<String,String>  params){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		String[] attachNormals = request.getParameterValues("ATT_NORMAL");
		
		Map<String,String> returnMap = new HashMap<String,String>();
		if(((String)params.get("title")).equals(null) || ((String)params.get("title")) == ""){
			returnMap.put("result", "false");
			return returnMap;
		}
		
		int ret = haService.insertHa(params,attachNormals);
		
		// 등록 포인트 적립
		if(ret==1){
			commonService.insertRegPoint(PointTyp.POI_HA_REG, params.get("mid"), params.get("haId"));
		}
		
		if(ret == 1){
			returnMap.put("result","true");
		}else{
			returnMap.put("result","false");
		}
		return returnMap;
	} 
	
	/*입력화면으로*/                                       
	@RequestMapping(value="/ha/haInsert.do",method=RequestMethod.GET)
	public String haInsert(@RequestParam Map<String,String> params,Model model){
		
		System.out.println("======================>1");
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		List<Map<String,String>> haCateCdList = commonService.selectCodeList("HA_CATE_CD");
		List<Map<String,String>> mediaList = commonService.selectCodeList("MEDIA_CD");
		
		System.out.println("======================>2");
		
		
		model.addAttribute("params",params);
		model.addAttribute("haCateCdList", haCateCdList);
		model.addAttribute("mediaList", mediaList);
		
		return "ha/haInsert";
	}
	
	/*상세화면으로*/
	@RequestMapping(value="/ha/haView.do",method=RequestMethod.GET)
	public String haView(@RequestParam Map<String,String> params,Model model){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn", loginService.getLoginVO(request).getSuperYn());
		
		haService.updateHaHit(params);
		
		Map<String, Object> ha = haService.selectHaOne(params);
		//파일첨부
		params.put("bid", params.get("haId"));
		List<Map<String,Object>> attList = uploadService.selectAttachList(params);
		
		model.addAttribute("params",params);
		model.addAttribute("ha",ha);
		model.addAttribute("attList", attList);
	
		return "ha/haView";	
	}
	
	/*수정화면으로*/
	@RequestMapping(value="/ha/haUpdate.do",method=RequestMethod.GET)
	public String haUpdate(@RequestParam Map<String,String> params,Model model){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		List<Map<String,String>> haCateCdList = commonService.selectCodeList("HA_CATE_CD");
		List<Map<String,String>> mediaList = commonService.selectCodeList("MEDIA_CD");
		
		Map<String,Object> ha = haService.selectHaOne(params);
		
		params.put("bid", params.get("haId"));
		List<Map<String,Object>> attList = uploadService.selectAttachList(params);
		
		model.addAttribute("haCateCdList",haCateCdList);
		model.addAttribute("mediaList", mediaList);
		model.addAttribute("params",params);
		model.addAttribute("ha",ha);
		model.addAttribute("attList", attList);
		
		return "ha/haUpdate";
	}

	/*수정하기*/
	@RequestMapping(value="/ha/haUpdateAction.do",method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> haUpdateAction(@RequestParam Map<String,String>  params){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		String[] attachNormals = request.getParameterValues("ATT_NORMAL");
		
		int ret = haService.updateHa(params,attachNormals);
		
		Map<String,String> returnMap = new HashMap<String,String>();
		if(ret == 1){
			returnMap.put("result","true");
		}else{
			returnMap.put("result","false");
		}
		return returnMap;
	} 
	
	/*삭제*/
	@RequestMapping(value="/ha/haDeleteAction.do",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> haDeleteAction(@RequestParam Map<String,String> params){
		
		params.put("mid", loginService.getLoginVO(request).getMid());
		params.put("superYn",loginService.getLoginVO(request).getSuperYn());
		
		
		int ret = haService.deleteHa(params);
		
		Map<String,String> returnMap = new HashMap<String,String>();
		if(ret == 1){
			returnMap.put("result","true");
		}else{
			returnMap.put("result","false");
		}
		return returnMap;
	}

}
