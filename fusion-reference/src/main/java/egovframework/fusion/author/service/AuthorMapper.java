package egovframework.fusion.author.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.fusion.author.vo.AuthorVO;

@Mapper
public interface AuthorMapper {
	List<AuthorVO> selectAuthorList();
}
