package com.qweib.cloud.core.domain;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * 在线用户内存 类.
 *
 * @author lhq
 * @see
 * @since JDK 1.6
 */
@Getter
@Setter
public class OnlineUser implements Serializable {

    private static final long serialVersionUID = 1418954919330809213L;


    /**
     * 当前用户访问唯一标识.
     */
    private String token;

    /**
     * 平台用户id
     */
    private Integer memId;
    /**
     * 账号
     */
    private String memberNm;
    /**
     * 手机号码
     */
    private String tel;
    /**
     * 数据库名称
     */
    private String database;
    /**
     * 访问时间.
     */
    private Date accessTime;
    /**
     * 验证码(临时变量)
     */
    private String code;
    private String tpNm;
    private Integer cid;

    private String fdCompanyId;//企业ID
    private String fdCompanyNm;//企业名称

    private String companys;//所属几个公司
    private List<Integer> usrRoleIds;    //角色

    private String openId;//微信用户的openId
    //类型：1公众号，2小程序
    private Integer openIdType;
    private String unionId;//微信开放平台ID
    private String nickName;//微信用户的昵称
    private String picUrl;//微信用户的图片地址
    private String sexStr;//微信用户的性别
    private String country;//微信用户所在的国家
    private String province;//微信用户所在的省
    private String city;//微信用户所在的城市

    private SysCorporation sysCorporation;//当前操作公司(商城登陆后使用)zzx
    private String appToken;//使用在APP端进入商城后,临时商城TOKEN绑定APP端的TOKEN,方便后继用户购买下单时自动注册成商城会员
    private Integer shopMemberId;//商城会员ID(暂时手机端才用到)
    private String shopSource;//商城中用户类型，来自用户表的source
    //是否被踢出
    private int presence;

    private Integer isDistributor;//是否分销会员0否，1是

    private String avatarUrl;

    public OnlineUser(Integer memId, String memberNm,
                      String tel, String database, String tpNm, Integer cid) {
        this.memId = memId;
        this.memberNm = memberNm;
        this.tel = tel;
        this.database = database;
        this.tpNm = tpNm;
        this.cid = cid;
    }

    public OnlineUser(String tel, String database) {
        this.tel = tel;
        this.database = database;
    }

    public OnlineUser() {
        super();
    }


}
