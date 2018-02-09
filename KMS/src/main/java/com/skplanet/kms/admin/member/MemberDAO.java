package com.skplanet.kms.admin.member;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;


@Repository
public class MemberDAO {
	private static final Logger logger = LoggerFactory.getLogger(MemberDAO.class);
	@Autowired
	private SqlSession kmsSqlSession;
	
	private static final String NS = MemberDAO.class.getPackage().getName()+".";
	
	public int selectMemberCnt(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectMemberCnt",params);
	}
	public List<Map<String, Object>> selectMemberList(Map<String, String> params) {
		return kmsSqlSession.selectList(NS+"selectMemberList",params);
	}
	public List<Map<String,Object>> selectMemberJikgupList(Map<String,String> params){
		return kmsSqlSession.selectList(NS+"selectMemberJikgupList",params);
	}
	public Map<String, Object> selectMemberOne(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectMemberOne",params);
	}
	public List<Map<String,String>> selectTeamCodeList(String divCd){
		return kmsSqlSession.selectList(NS + "selectTeamCodeList", divCd);
	}
	public List<Map<String,String>> selectOnlyTeamCodeList(String upperCd){
		return kmsSqlSession.selectList(NS + "selectOnlyTeamCodeList", upperCd);
	}
	public int updateMember(Map<String, String> params) {
		return kmsSqlSession.update(NS+"updateMember", params);
	}
	public int insertMember(Map<String, String> params) {
		return kmsSqlSession.insert(NS+"insertMember",params);
	}
	public  int selectMidCheck(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectMidCheck",params);
	}
	public int insertMemberExcel(Map<String, String> params) {
		return kmsSqlSession.update(NS+"insertMemberExcel",params);
	}
	public List<Map<String,Object>> selectExcelJikgupList(){
		return kmsSqlSession.selectList(NS+"selectExcelJikgupList");
	}
	public List<Map<String,Object>> selectExcelPosList(){
		return kmsSqlSession.selectList(NS+"selectExcelPosList");
	}
	/*************************************************************************/
	public int selectAdmMemberCnt(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectAdminCnt",params);
	}
	public List<Map<String, Object>> selectAdmMemberList(Map<String, String> params) {
		return kmsSqlSession.selectList(NS+"selectAdmMemberList",params);
	}
	public int updateAdmMember(Map<String, String> params) {
		return kmsSqlSession.update(NS+"updateAdmMember", params);
	}
	public int insertAdmMember(Map<String, String> params) {
		return kmsSqlSession.insert(NS+"insertAdmMember",params);
	}
	public  int selectAdmMidCheck(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectAdmMidCheck",params);
	}
	public Map<String, Object> selectAdmMemberOne(Map<String, String> params) {
		return kmsSqlSession.selectOne(NS+"selectAdmMemberOne",params);
	}
}
