package egovframework.fusion.member.service;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.fusion.member.vo.MemberVO;

@Mapper
public interface MemberMapper {
	// 회원 단건 조회
	MemberVO getMember(MemberVO memberVO);
	
	// 회원 가입
	int insertMember(MemberVO memberVO);
}
