package com.skplanet.kms.admin.member;

import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.skplanet.kms.login.LoginService;
import com.skplanet.kms.util.SHA256;

@Service
public class MemberService {
	
	@Autowired
	HttpServletRequest request;
	@Autowired
	private MemberDAO memberDAO;
	@Autowired
	private LoginService loginService;
	private static final PrintWriter out = null;
	private static final Logger logger = LoggerFactory.getLogger(MemberService.class);
	
	
	public int selectMemberCnt(Map<String, String> params) {
		return memberDAO.selectMemberCnt(params);
	}
	public List<Map<String,Object>> selectMemberList(Map<String, String> params) {
		List <Map<String,Object>> resultList = memberDAO.selectMemberList(params);
		List <Map<String,Object>> resultSsMap =null;
		
		for (int i = 0; i<resultList.size();i++){
			params.put("divCd",(String) resultList.get(i).get("DIV_CD"));
			
			resultSsMap=memberDAO.selectMemberJikgupList(params);
			
			if(resultSsMap.size() == 3){
				resultList.get(i).put("TEAM",(String)resultSsMap.get(0).get("CD_NM"));
				resultList.get(i).put("C_TEAM",(String)resultSsMap.get(1).get("CD_NM"));
				resultList.get(i).put("S_TEAM",(String)resultSsMap.get(2).get("CD_NM"));
				
				resultList.get(i).put("TEAM_CD",(String)resultSsMap.get(0).get("DIV_CD"));
				resultList.get(i).put("C_TEAM_CD",(String)resultSsMap.get(1).get("DIV_CD"));
				resultList.get(i).put("S_TEAM_CD",(String)resultSsMap.get(2).get("DIV_CD"));
			}else if(resultSsMap.size() == 2){
				resultList.get(i).put("C_TEAM",(String)resultSsMap.get(0).get("CD_NM"));
				resultList.get(i).put("S_TEAM",(String)resultSsMap.get(1).get("CD_NM"));
				resultList.get(i).put("TEAM","");
				
				resultList.get(i).put("C_TEAM_CD",(String)resultSsMap.get(0).get("DIV_CD"));
				resultList.get(i).put("S_TEAM_CD",(String)resultSsMap.get(1).get("DIV_CD"));
				resultList.get(i).put("TEAM_CD","");
			}else if(resultSsMap.size() == 1){
				resultList.get(i).put("S_TEAM",(String)resultSsMap.get(0).get("CD_NM"));
				resultList.get(i).put("TEAM","");
				resultList.get(i).put("C_TEAM","");
				
				resultList.get(i).put("S_TEAM_CD",(String)resultSsMap.get(0).get("DIV_CD"));
				resultList.get(i).put("C_TEAM_CD","");
				resultList.get(i).put("TEAM_CD","");
			}else{
				resultList.get(i).put("TEAM","");
				resultList.get(i).put("C_TEAM","");
				resultList.get(i).put("S_TEAM","");
				
				resultList.get(i).put("S_TEAM_CD","");
				resultList.get(i).put("C_TEAM_CD","");
				resultList.get(i).put("TEAM_CD","");
			}
			
		}
		return resultList;
	}
	public Map<String,Object> selectMemberOne(Map<String, String> params) {
		return memberDAO.selectMemberOne(params);
	}
	public List<Map<String,String>> selectOnlyTeamCodeList(String upperCd){
		return memberDAO.selectOnlyTeamCodeList(upperCd);
	}
	/*부서코드추가*/
	public List<Map<String,String>> selectTeamCodeList(String divCd){
		return memberDAO.selectTeamCodeList(divCd);
	}
	public int updateMember(Map<String, String> params){
		return  memberDAO.updateMember(params);
	}
	
	
	public int insertMember(Map<String, String> params) {
		return memberDAO.insertMember(params);
	}
	public int selectMidCheck(Map<String, String> params) {
	return memberDAO.selectMidCheck(params);
	}
	
	public String excelFileInsert(List<CustomerVo> list) throws SQLException {

		Map<String, String> voMap = new HashMap<String,String>();
		
		String tempVal="";
		String sTeamCd="";
		String cTeamCd="";
		String teamCd="";
		String sessionMid="";
		String passwd="";
		String divCd="";
		String tfStr = "";
		String excelErrMsg="OK";

		List <Map<String,Object>> posList = memberDAO.selectExcelPosList();
		List <Map<String,Object>> selectExcelJikgupList = memberDAO.selectExcelJikgupList();
		
		//유효성체크
		int i=0;
		try{
			for(i=0;i<list.size();i++){

				tempVal=(String)list.get(i).getMID();
				if(tempVal.length() < 7 || tempVal.equals(null) || tempVal.equals("")){
					excelErrMsg = "[업로드 실패] "+  (i+2)+"행 [사원번호] 에러.";
					return excelErrMsg;
				}

				tempVal = (String)list.get(i).getBIRTH_DT();
				if(  tempVal.equals(null) || tempVal.equals("")){
					excelErrMsg = "[업로드 실패] "+  (i+2)+"행 [생년월일] 에러.";
					return excelErrMsg;
				}
			
				tempVal = (String)list.get(i).getEMAIL();
				//boolean b = Pattern.matches("[\\w\\~\\-\\.]+@[\\w\\~\\-]+(\\.[\\w\\~\\-]+)+",tempVal);
				//if(tempVal.equals("") || tempVal.equals(null) || !b  ){
				if(tempVal.equals("") || tempVal.equals(null)){
					excelErrMsg =  "[업로드 실패] "+ (i+2)+"행 [이메일]형식 에러.";
					return excelErrMsg;
				}

				int tfCnt = 0;
				tempVal = (String)list.get(i).getPOS_CD();
				//logger.debug("___pos:"+tempVal);
				if(tempVal.equals(null) || tempVal.equals("")){
					excelErrMsg =  "[업로드 실패] "+ (i+2)+"행 [직책코드] 에러.";
					return excelErrMsg;
				}
				for(int j=0;j<posList.size();j++){
					if(((String)posList.get(j).get("CD")).equals(tempVal)){
						tfCnt++;
					}
				}
				//logger.debug("___tfCnt:"+tfCnt);
				if(tfCnt == 0 || tempVal.length() == 0){
					excelErrMsg =  "[업로드 실패] "+ (i+2)+"행 [직책코드] 에러.";
					return excelErrMsg;
				}
				/***************************************************************************************
				 * 부문/본부 팀 유효성체크
				 * 부문필수
				 * 상위레벨값이 빈 상태로의 데이터 체크
				 * 하위레벨이 빈 경우 허용할것
				 * 부서를 입력하여 해당 부서에 해당하는 상위레벨의 부서를 대상으로 유효성 케크(selectMemberJikgupList)
				 * **************************************************************************************/
				int getSecCdSize = ((String)list.get(i).getSEC_CD()).length();
				int getCenCdSize = ((String)list.get(i).getCEN_CD()).length();
				int getTeaCdSize = ((String)list.get(i).getTEA_CD()).length();

				//비었는가
				if(getSecCdSize > 0 || getCenCdSize >0 || getTeaCdSize > 0 ){
					if(getSecCdSize > 0){
						tempVal = (String)list.get(i).getSEC_CD();
						if(tempVal.equals(null) || tempVal.equals("")){
							excelErrMsg =  "[업로드 실패] "+ (i+2)+"행 [부문코드] 에러.";
							return excelErrMsg;
						}
						tfStr = checkFunc(tempVal,selectExcelJikgupList,"[부문코드]");
						if(tfStr.equals("OK")){
						}else{
							excelErrMsg = "[업로드 실패] "+ (i+2)+tfStr;
							return excelErrMsg;
						}
					}

					if(getCenCdSize > 0){
						tempVal = (String)list.get(i).getCEN_CD();
						if(tempVal.equals(null) || tempVal.equals("")){
							excelErrMsg =  "[업로드 실패] "+ (i+2)+"행 [본부코드] 에러.";
							return excelErrMsg;
						}
						
						tfStr = checkFunc(tempVal,selectExcelJikgupList,"[본부코드]");
						if(tfStr.equals("OK")){
						}else{
							excelErrMsg = "[업로드 실패] "+  (i+2)+tfStr;
							return excelErrMsg;
						}
					}

					if(getTeaCdSize > 0){
						tempVal = (String)list.get(i).getTEA_CD();
						if(tempVal.equals(null) || tempVal.equals("")){
							excelErrMsg =  "[업로드 실패] "+ (i+2)+"행 [팀코드] 에러.";
							return excelErrMsg;
						}
						
						tfStr = checkFunc(tempVal,selectExcelJikgupList,"[팀코드]");
						if(tfStr.equals("OK")){
						}else{
							excelErrMsg = "[업로드 실패] "+  (i+2)+tfStr;
							return excelErrMsg;
						}
					}
				}else if( 
						(getSecCdSize == 0 && getCenCdSize == 0 && getTeaCdSize == 0) ||
						(getSecCdSize == 0 && getCenCdSize == 0 && getTeaCdSize > 0) ||
						(getSecCdSize == 0 && getCenCdSize > 0 && getTeaCdSize > 0) ||
						(getSecCdSize == 0 && getCenCdSize > 0 && getTeaCdSize == 0) 
						){
							excelErrMsg = "[업로드 실패] "+  (i+2)+"행 [부서코드] 에러.";
							return excelErrMsg;
				}	
	
				tempVal = ((String)list.get(i).getCR_APPOINT_YN());
				if(tempVal.equals("") || tempVal.equals(null) || tempVal.length() == 0){
					list.get(i).setCR_APPOINT_YN("N");
					tempVal = "N";
				}
				if(!"YN".contains(tempVal)){
					excelErrMsg = "[업로드 실패] "+  (i+2)+"행 [Credential:YN]코드 에러.";
					return excelErrMsg;
				}
				
				tempVal = ((String)list.get(i).getKC_APPOINT_YN());
				if(tempVal.equals(null) || tempVal.equals("") || tempVal.length() == 0 ){
					list.get(i).setKC_APPOINT_YN("N");
					tempVal ="N";
				}
				if(!"YN".contains(tempVal)){
					excelErrMsg = "[업로드 실패] "+  (i+2)+"행 [지식채널:YN]코드 에러.";
					return excelErrMsg;
				}
				
			}
		}catch(Exception e){
			out.println("<script>");
			out.println("alert('엑셀 데이터 입력 형식이 맞지 않습니다. [업로드 실패] '+"+(i+2)+");");
			out.println("</script>");
		}
	
		/*insert*/
		sessionMid = (String)loginService.getLoginVO(request).getMid();
		
		for(int k=0; k<list.size(); k++){
			voMap.put("mid",(String)list.get(k).getMID());
			passwd=(String)SHA256.encrypt((String)list.get(k).getBIRTH_DT());
			
			voMap.put("passwd",passwd);
			voMap.put("memberNm",(String)list.get(k).getMEMBER_NM());
			
			String repStr = (String)list.get(k).getBIRTH_DT();
			repStr = repStr.replace("-", "");
			
			voMap.put("birthDt", repStr);
			
			voMap.put("email",(String)list.get(k).getEMAIL());
			voMap.put("posCd",(String)list.get(k).getPOS_CD());
			
			sTeamCd = (String)list.get(k).getSEC_CD();
			cTeamCd = (String)list.get(k).getCEN_CD();
			teamCd =  (String)list.get(k).getTEA_CD();
			
			if( !teamCd.equals(null) && !teamCd.equals("") ){
				divCd=teamCd;
			}else if( !cTeamCd.equals(null) && !cTeamCd.equals("") ){
				divCd=cTeamCd;
			}else if( !sTeamCd.equals(null) && !sTeamCd.equals("") ){
				divCd=sTeamCd;
			}
			voMap.put("divCd",divCd);
			String crStr = (String)list.get(k).getCR_APPOINT_YN();
			if(crStr.equals("Y")){
				voMap.put("crAppointYn", "Y");
			}else{
				voMap.put("crAppointYn", "N");
			}
			String kcStr = (String)list.get(k).getKC_APPOINT_YN();
			if(kcStr.equals("Y")){
				voMap.put("kcAppointYn", "Y");
			}else{
				voMap.put("kcAppointYn", "N");
			}
			
			voMap.put("sessionId",sessionMid);		
			
			memberDAO.insertMemberExcel(voMap);	
		}
		return excelErrMsg;
	}
	/*********************************메시지***************************************/
	public String checkFunc(String tempVal,List<Map<String,Object>> selectExcelJikgupList,String cdMsg){
		String msg = "OK";
		boolean check = false;
		for(int j=0;j<selectExcelJikgupList.size();j++){
			if(((String)selectExcelJikgupList.get(j).get("CD")).equals(tempVal)){
				check = true;
			}
		}
		if(!check){
			msg = " 행 데이터 "+cdMsg+" 에러.";
			return msg;
		}
		return msg;
	}
	/***************************************************************************/
	public int selectAdmMemberCnt(Map<String, String> params) {
		return memberDAO.selectAdmMemberCnt(params);
	}
	public List<Map<String,Object>> selectAdmMemberList(Map<String, String> params) {
		return memberDAO.selectAdmMemberList(params);
	}
	public int updateAdmMember(Map<String, String> params){
		return  memberDAO.updateAdmMember(params);
	}
	public int insertAdmMember(Map<String, String> params) {
		return memberDAO.insertAdmMember(params);
	}
	public int selectAdmMidCheck(Map<String, String> params) {
	return memberDAO.selectAdmMidCheck(params);
	}
	public Map<String,Object> selectAdmMemberOne(Map<String, String> params) {
		return memberDAO.selectAdmMemberOne(params);
	}
}
