package egovframework.fusion.member.service;

import java.util.Map;

import egovframework.fusion.member.vo.MemberVO;

public interface MemberService {
	// 로그인
	Map<String, Object> login(MemberVO memberVO);
	
	// 아이디 중복 체크
	Map<String, Object> idCheck(MemberVO memberVO);
	
	// 회원가입
	Map<String, Object> join(MemberVO memberVO);
	
	// 로그아웃
	Map<String, Object> logout();
}
