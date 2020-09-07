package com.qweib.cloud.biz.system.service.common.impl;

import com.qweib.cloud.biz.system.service.common.OrderBaseService;
import com.qweib.cloud.biz.system.service.common.dto.MemberBaseDTO;
import com.qweib.cloud.core.domain.SysBforder;
import com.qweib.cloud.core.domain.SysCustomer;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.domain.shop.ShopMemberDTO;
import com.qweib.cloud.core.domain.shop.ShopMemberQuery;
import com.qweib.cloud.core.domain.vo.OrderMemberType;
import com.qweib.cloud.repository.SysCustomerDao;
import com.qweib.cloud.repository.mall.ShopMemberCertifyDao;
import com.qweib.cloud.repository.plat.SysMemberDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author zzx
 * @version 1.1 2019/11/9
 * @description:订单共用方法
 */
@Service
public class OrderBaseServiceImpl implements OrderBaseService {
    @Resource
    private SysCustomerDao customerDao;
    @Resource
    private SysMemberDao memberDao;
    @Resource
    private ShopMemberCertifyDao shopMemberCertifyDao;

    /**
     * 根据订单empType获取业务员基本信息
     *
     * @param database
     * @param order
     * @return
     */
    @Override
    public MemberBaseDTO getSalesman(String database, SysBforder order) {
        if (order.getMid() == null || order.getEmpType() == null) {
            return null;
        }
        MemberBaseDTO dto = null;
        //员工
        if (order.getEmpType() == OrderMemberType.staff.getCode()) {
            SysMember member = memberDao.queryCompanySysMemberById(database, order.getMid());
            if (member != null) {
                dto = new MemberBaseDTO(member.getMemberId(), member.getMemberId(), member.getMemberNm(), member.getMemberMobile());
            }
        } //会员(商城)
        else if (order.getEmpType() == OrderMemberType.member.getCode()) {
            ShopMemberQuery query = new ShopMemberQuery();
            query.setMemId(order.getMid());//平台MEMID
            ShopMemberDTO shopMemberDTO = shopMemberCertifyDao.getShopMember(query, database);
            if (shopMemberDTO != null) {
                dto = new MemberBaseDTO(shopMemberDTO.getMemberId(), shopMemberDTO.getMemberId(), shopMemberDTO.getName(), shopMemberDTO.getMobile());
            }
        }
        return dto;
    }

    /**
     * 根据proType获取客户基本信息
     *
     * @param database
     * @param order
     * @return
     */
    @Override
    public MemberBaseDTO getCustomer(String database, SysBforder order) {
        if (order.getCid() == null || order.getProType() == null) return null;
        MemberBaseDTO dto = null;
        if (order.getProType() == OrderMemberType.staff.getCode()) {//员工
            SysMember member = memberDao.queryCompanySysMemberById(database, order.getCid());
            if (member != null) {
                dto = new MemberBaseDTO(member.getMemberId(), member.getMemberId(), member.getMemberNm(), member.getMemberMobile());
            }
        } else if (order.getProType() == OrderMemberType.customer.getCode()) {//客户
            SysCustomer customer = customerDao.queryCustomerById(database, order.getCid());
            if (customer != null) {
                dto = new MemberBaseDTO(customer.getId(), customer.getMemId(), customer.getKhNm(), customer.getMobile());
            }
        } else if (order.getProType() == OrderMemberType.member.getCode()) {//会员(商城)
            ShopMemberQuery query = new ShopMemberQuery();
            query.setId(order.getCid());//会员ID
            ShopMemberDTO shopMemberDTO = shopMemberCertifyDao.getShopMember(query, database);
            if (shopMemberDTO != null) {
                dto = new MemberBaseDTO(shopMemberDTO.getMemberId(), shopMemberDTO.getMemberId(), shopMemberDTO.getName(), shopMemberDTO.getMobile());
            }
        }
        return dto;
    }
}
