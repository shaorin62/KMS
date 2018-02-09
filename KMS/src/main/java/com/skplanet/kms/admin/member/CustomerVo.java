package com.skplanet.kms.admin.member;

public class CustomerVo {

	private String	MID;				//아이디(사번)
	private String	PASSWD;             //패스워드
	private String	MEMBER_NM;          //회원 이름
	private String	POS_CD;             //직책 코드
	private String	SEC_CD;             //직책 코드
	private String	CEN_CD;             //직책 코드
	private String	TEA_CD;             //직책 코드
	private String	DIV_CD;             //부서 코드
	private String	BIRTH_DT;           //생년월일
	private String	EMAIL;              //이메일
	private String	CR_APPOINT_YN;      //CR 지정인 여부
	private String	REG_ID;             //등록자 ID
	private String	REG_DTM;            //등록 일시
	private String	UPD_ID;             //수정자 ID
	private String	UPD_DTM;            //수정 일시
	private String	DBSTS;              //DB상태
	private String	KC_APPOINT_YN;      //지식채널 지정인 여부
	
	

	
	
	public String getSEC_CD() {
		return SEC_CD;
	}
	public void setSEC_CD(String sEC_CD) {
		SEC_CD = sEC_CD;
	}
	public String getCEN_CD() {
		return CEN_CD;
	}
	public void setCEN_CD(String cEN_CD) {
		CEN_CD = cEN_CD;
	}
	public String getTEA_CD() {
		return TEA_CD;
	}
	public void setTEA_CD(String tEA_CD) {
		TEA_CD = tEA_CD;
	}
	public String getMID() {
		return MID;
	}
	public void setMID(String mID) {
		MID = mID;
	}
	public String getPASSWD() {
		return PASSWD;
	}
	public void setPASSWD(String pASSWD) {
		PASSWD = pASSWD;
	}
	public String getMEMBER_NM() {
		return MEMBER_NM;
	}
	public void setMEMBER_NM(String mEMBER_NM) {
		MEMBER_NM = mEMBER_NM;
	}
	public String getPOS_CD() {
		return POS_CD;
	}
	public void setPOS_CD(String pOS_CD) {
		POS_CD = pOS_CD;
	}
	public String getDIV_CD() {
		return DIV_CD;
	}
	public void setDIV_CD(String dIV_CD) {
		DIV_CD = dIV_CD;
	}
	public String getBIRTH_DT() {
		return BIRTH_DT;
	}
	public void setBIRTH_DT(String bIRTH_DT) {
		BIRTH_DT = bIRTH_DT;
	}
	public String getEMAIL() {
		return EMAIL;
	}
	public void setEMAIL(String eMAIL) {
		EMAIL = eMAIL;
	}
	public String getCR_APPOINT_YN() {
		return CR_APPOINT_YN;
	}
	public void setCR_APPOINT_YN(String cR_APPOINT_YN) {
		CR_APPOINT_YN = cR_APPOINT_YN;
	}
	public String getREG_ID() {
		return REG_ID;
	}
	public void setREG_ID(String rEG_ID) {
		REG_ID = rEG_ID;
	}
	public String getREG_DTM() {
		return REG_DTM;
	}
	public void setREG_DTM(String rEG_DTM) {
		REG_DTM = rEG_DTM;
	}
	public String getUPD_ID() {
		return UPD_ID;
	}
	public void setUPD_ID(String uPD_ID) {
		UPD_ID = uPD_ID;
	}
	public String getUPD_DTM() {
		return UPD_DTM;
	}
	public void setUPD_DTM(String uPD_DTM) {
		UPD_DTM = uPD_DTM;
	}
	public String getDBSTS() {
		return DBSTS;
	}
	public void setDBSTS(String dBSTS) {
		DBSTS = dBSTS;
	}
	public String getKC_APPOINT_YN() {
		return KC_APPOINT_YN;
	}
	public void setKC_APPOINT_YN(String kC_APPOINT_YN) {
		KC_APPOINT_YN = kC_APPOINT_YN;
	}
	
	@Override
	public String toString() {
		StringBuffer sb = new StringBuffer();
		
		sb.append("MID : " + MID);							
		sb.append(" ,PASSWD : " + PASSWD);         
		sb.append(" ,MEMBER_NM : " + MEMBER_NM);      
		sb.append(" ,POS_CD : " + POS_CD);
		sb.append(" ,POS_CD : " + SEC_CD);     
		sb.append(" ,POS_CD : " + CEN_CD);     
		sb.append(" ,POS_CD : " + TEA_CD);     
		sb.append(" ,DIV_CD : " + DIV_CD);         
		sb.append(" ,BIRTH_DT : " + BIRTH_DT);       
		sb.append(" ,EMAIL : " + EMAIL);          
		sb.append(" ,CR_APPOINT_YN : " + CR_APPOINT_YN);  
		sb.append(" ,REG_ID : " + REG_ID);         
		sb.append(" ,REG_DTM : " + REG_DTM);        
		sb.append(" ,UPD_ID : " + UPD_ID);         
		sb.append(" ,UPD_DTM : " + UPD_DTM);        
		sb.append(" ,DBSTS : " + DBSTS);          
		sb.append(" ,KC_APPOINT_YN : " + KC_APPOINT_YN);  
		
		return sb.toString();
	}
	
}
