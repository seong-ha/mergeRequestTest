package egovframework.fusion.aop.service;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.fusion.aop.vo.AccessLogVO;

@Mapper
public interface AccessLogMapper {
	int insertAccessLog(AccessLogVO accessLogVO);
}
