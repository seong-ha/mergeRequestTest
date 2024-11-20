package egovframework.fusion.author.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.fusion.author.vo.AuthorVO;

@Service
public class AuthorServiceImpl implements AuthorService {
	
	@Autowired
	AuthorMapper dao;
	
	@Override
	public List<AuthorVO> getAuthorList() {
		return dao.selectAuthorList();
	}

}
