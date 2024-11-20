package egovframework.fusion.member.service;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.fusion.member.vo.MemberVO;

@Service
public class MemberServiceImpl implements MemberService {
	@Autowired
	MemberMapper memberMapper;
	
	@Autowired
	HttpServletRequest request;
	
	// 로그인
	@Override
	public Map<String, Object> login(MemberVO memberVO) {
		MemberVO compare  = memberMapper.getMember(memberVO);
		
		if (compare == null) {
			return resultMap(0, "존재하지 않는 아이디입니다.");
		} else {
			if (!memberVO.getPwd().equals(compare.getPwd())) {
				return resultMap(0, "비밀번호를 잘못 입력하셨습니다.");
			} else if (memberVO.getPwd().equals(compare.getPwd())) {
				HttpSession session = request.getSession();
				session.setAttribute("member_no", compare.getMember_no());
				session.setAttribute("id", compare.getId());
				session.setAttribute("name", compare.getName());
				session.setAttribute("author_no", compare.getAuthor_no());
				
				return resultMap(1, "정상 로그인되었습니다.");
			}
		}
		
		return resultMap(0, "로그인에 실패했습니다. 관리자에게 문의바랍니다.");
	}

	// 아이디 중복 체크
	@Override
	public Map<String, Object> idCheck(MemberVO memberVO) {
		MemberVO resultVO = memberMapper.getMember(memberVO);
		
		if (resultVO != null) {
			return resultMap(1, "이미 존재하는 아이디입니다.");
		} else {
			return resultMap(0, "사용 가능한 아이디입니다.");
		}
	}
	
	// 회원가입
	@Override
	public Map<String, Object> join(MemberVO memberVO) {
		int result = memberMapper.insertMember(memberVO);
		
		if (result == 1) {
			return resultMap(1, "회원가입에 성공했습니다.");
		} else {
			return resultMap(0, "회원가입에 실패했습니다.");
		}
		
	}
	
	// 로그아웃
	@Override
	public Map<String, Object> logout() {
		HttpSession session = request.getSession();
		
		try {
			session.invalidate();
			return resultMap(1, "성공적으로 로그아웃되었습니다.");
		} catch (Exception e) {
			// TODO: handle exception
		}
		return resultMap(0, "로그아웃에 실패했습니다.");
	}
	
	// 결과를 map형태로 제작
	public Map<String, Object> resultMap(int result, String message) {
		Map<String, Object> map = new HashMap<>();
		map.put("result", result);
		map.put("msg", message);
		
		return map;
	}

	
}
