package com.skplanet.kms.login;

import java.io.Serializable;

public class LoginVO implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	boolean logIn = false;			// 로그인 여부
	String mid;						// 아이디(사번)
	String memberNm;				// 이름
	
	String admYn;		// 관리자 여부
	String posCd;		// 직책코드
	String divCd;		// 부서코드

	String crAppointYn;	// CA 지정인 여부
	String kcAppointYn;	// 지식채널 지정인 여부
	String superYn;		// 슈퍼계정 여부
	
	public boolean isLogIn() {
		return logIn;
	}

	public void setLogIn(boolean logIn) {
		this.logIn = logIn;
	}

	public String getMid() {
		return mid;
	}

	public void setMid(String mid) {
		this.mid = mid;
	}

	public String getMemberNm() {
		return memberNm;
	}

	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}

	public String getAdmYn() {
		return admYn;
	}

	public void setAdmYn(String admYn) {
		this.admYn = admYn;
	}

	public String getPosCd() {
		return posCd;
	}

	public void setPosCd(String posCd) {
		this.posCd = posCd;
	}

	public String getDivCd() {
		return divCd;
	}

	public void setDivCd(String divCd) {
		this.divCd = divCd;
	}

	public String getCrAppointYn() {
		return crAppointYn;
	}

	public void setCrAppointYn(String crAppointYn) {
		this.crAppointYn = crAppointYn;
	}

	public String getKcAppointYn() {
		return kcAppointYn;
	}

	public void setKcAppointYn(String kcAppointYn) {
		this.kcAppointYn = kcAppointYn;
	}

	public String getSuperYn() {
		return superYn;
	}

	public void setSuperYn(String superYn) {
		this.superYn = superYn;
	}
	
}
